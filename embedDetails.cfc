<!--- Bold BI Embedding API Component --->
<cfcomponent displayname="embedDetails">

	<!--- CORS Headers --->
	<cfheader name="Access-Control-Allow-Origin" value="*">
	<cfheader name="Access-Control-Allow-Methods" value="GET, POST, OPTIONS">
	<cfheader name="Access-Control-Allow-Headers" value="Content-Type, Authorization">

	<!--- tokenGeneration: Reads embedConfig.json and generates Bold BI access token --->
	<cffunction name="tokenGeneration" access="remote" returnformat="JSON">

		<cfset var result = {}>
		<cfset var embedConfigPath = expandPath("./embedConfig.json")>
		<cfset var fileContent = "">
		<cfset var embedConfig = "">
		<cfset var siteIdentifier = "">
		<cfset var tokenUrl = "">
		<cfset var requestBody = "">
		<cfset var httpResponse = "">
		<cfset var responseData = "">

		<cftry>
			<!--- Read embedConfig.json --->
			<cfif NOT fileExists(embedConfigPath)>
				<cfset result.success = false>
				<cfset result.error = "embedConfig.json not found">
				<cfheader statusCode="404">
				<cfreturn result>
			</cfif>

			<cffile action="read" file="#embedConfigPath#" variable="fileContent">
			<cfset embedConfig = deserializeJSON(fileContent)>

			<!--- Get siteIdentifier --->
			<cfset siteIdentifier = structKeyExists(embedConfig, "siteIdentifier") ? trim(embedConfig.siteIdentifier) : "">

			<!--- Build token URL --->
			<cfif len(siteIdentifier)>
				<cfset tokenUrl = embedConfig.serverUrl & "/api/" & siteIdentifier & "/embed/authorize">
			<cfelse>
				<cfset tokenUrl = embedConfig.serverUrl & "/api/embed/authorize">
			</cfif>

			<!--- Build request body --->
			<cfset requestBody = serializeJSON({
				"email": embedConfig.userEmail,
				"serverurl": embedConfig.serverUrl,
				"siteidentifier": siteIdentifier,
				"embedsecret": embedConfig.embedSecret,
				"dashboard": { "id": embedConfig.dashboardId }
			})>

			<!--- Call Bold BI API --->
			<cfhttp url="#tokenUrl#" method="POST" result="httpResponse" timeout="30">
				<cfhttpparam type="header" name="Content-Type" value="application/json">
				<cfhttpparam type="body" value="#requestBody#">
			</cfhttp>

			<!--- Handle response --->
			<cfif httpResponse.statusCode NEQ "200 OK">
				<cfset result.success = false>
				<cfset result.error = "Token Generation Failed. Status: " & httpResponse.statusCode>
				<cfheader statusCode="500">
				<cfreturn result>
			</cfif>

			<cfset responseData = deserializeJSON(httpResponse.fileContent)>

			<!--- Extract access_token from response (handle multiple response structures) --->
			<cfset var accessToken = "">
			<cfif structKeyExists(responseData, "Data") AND isStruct(responseData.Data) AND structKeyExists(responseData.Data, "access_token")>
				<!--- Structure: { "Data": { "access_token": "..." } } --->
				<cfset accessToken = responseData.Data.access_token>
			<cfelseif structKeyExists(responseData, "access_token")>
				<!--- Structure: { "access_token": "..." } --->
				<cfset accessToken = responseData.access_token>
			<cfelseif structKeyExists(responseData, "token")>
				<!--- Structure: { "token": "..." } --->
				<cfset accessToken = responseData.token>
			<cfelse>
				<!--- Unknown structure - return raw response for debugging --->
				<cfset result.success = false>
				<cfset result.error = "Unexpected API response structure">
				<cfset result.rawResponse = httpResponse.fileContent>
				<cfheader statusCode="500">
				<cfreturn result>
			</cfif>

			<cfset result.success = true>
			<cfset result.access_token = accessToken>
			<cfset result.token_type = "Bearer">
			<cfset result.dashboardId = embedConfig.dashboardId>
			<cfset result.serverUrl = embedConfig.serverUrl>
			<cfset result.siteIdentifier = siteIdentifier>
			<cfheader statusCode="200">
			<cfreturn result>

		<cfcatch type="any">
			<cfset result.success = false>
			<cfset result.error = cfcatch.message>
			<cfheader statusCode="500">
			<cfreturn result>
		</cfcatch>
		</cftry>
	</cffunction>

</cfcomponent>
