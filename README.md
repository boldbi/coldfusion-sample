# BoldBI Embedding ColdFusion Sample

This Bold BI ColdFusion sample contains the Dashboard embedding sample. This sample demonstrates the rendering of dashboard available in your Bold BI server.

This section guides you in using the Bold BI dashboard in your ColdFusion sample application.

* [Requirements to run the demo](#requirements-to-run-the-demo)
* [Using the ColdFusion sample](#using-the-coldfusion-sample)
* [Online Demos](#online-demos)
* [Documentation](#documentation)

## Requirements to run the demo

The samples require the following to run:

* [ColdFusion software] (<https://helpx.adobe.com/coldfusion/kb/coldfusion-downloads.html>)

## Using the ColdFusion sample

* Open the ColdFusion embed sample in respective IDE.

* Open the BoldBIEmbed.html file in the following location, /coldfusion/BoldBIEmbed.html.

* Please change the following properties in the `BoldBIEmbed.html` file as per your Bold BI Server.

| Parameter             | Description                                                                                             |
|-----------------------|---------------------------------------------------------------------------------------------------------|
| **ServerUrl**         | Dashboard Server URL (Example for on-premise: <http://demo.boldbi.com/bi/site/site1>) (Example for cloud: <http://demo.boldbi.com/bi>). |
| **SiteIdentifier**    | For the Bold BI Enterprise edition, it should be like `site/site1`. For Bold BI Cloud, it should be an empty string.                        |
| **Environment**       | Your Bold BI application environment. (If Cloud, you should use `cloud,` if Enterprise, you should use `enterprise`).                        |
| **dashboardId**       | Id of the dashboard you want to embed.                                                                 |
| **authorizationServerUrl** | API in `embedDetails.cfc` to get the particular dashboard details.                                                            |

* Open the `embedDetails.cfc` and provide the below details.

| Parameter     | Description |
|---------------|-------------|
| **UserEmail** | UserEmail of the Admin in your Bold BI, which would be used to get the dashboard list. |
| **EmbedSecret** | Get your EmbedSecret key from the Embed tab by enabling the `Enable embed authentication` on the [Administration page](https://help.boldbi.com/embedded-bi/site-administration/embed-settings/?utm_source=github&utm_medium=backlinks). |

* Now, run the ColdFusion sample.

Please refer to the [help documentation](https://help.boldbi.com/embedded-bi/javascript-based/samples/v3.3.40-or-later/other-platform-samples/#coldfusion-sample-to-embed-dashboard?utm_source=github&utm_medium=backlinks) to know how to run the sample.

## Online Demos

Look at the Bold BI Embedding sample to live demo [here](https://samples.boldbi.com/embed?utm_source=github&utm_medium=backlinks).

## Documentation

A complete Bold BI Embedding documentation can be found on the [Bold BI Embedding Help](https://help.boldbi.com/embedded-bi/javascript-based/?utm_source=github&utm_medium=backlinks).
