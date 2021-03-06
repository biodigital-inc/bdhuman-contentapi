﻿BioDigital Human Content API using .NET Visual C#
========



Code samples using a [.NET 4.5 Visual Studio 2015 C# Web Application](https://msdn.microsoft.com/en-us/library/kx37x362.aspx) to demonstrate making requests to the BioDigital Human Content API.  These examples provide basic approaches to:

* Requesting an access token from the BioDigital OAuth2 services
* Using an access token to make authorized requests to various Content API endpoints


## Getting Started

Below are the steps for getting this example running on your local machine for development and testing purposes.

### Prerequisites

1.  The **developer key and secret** of a [registered BioDigital developer application](https://devsupport.biodigital.com/hc/en-us/articles/234450188-How-to-register-my-App).  These credentials will be used as your *client id* and *client secret* when making requests to the BioDigital OAuth2 services.

2. This web application was created using the [Visual Studio Community (2015)](https://www.visualstudio.com/vs/community/) IDE.  Ensure the **Visual C#** Programming Language feature is selected upon installation.
 
3. This web application uses the following [NuGet packages](https://www.nuget.org/), in addition to the standard toolkit.  These packages should be listed within the provided **package.config** file and can be mangaged via the [NuGet Package Manager UI in Visual Studio](https://docs.microsoft.com/en-us/nuget/tools/package-manager-ui):
	*  [Newtonsoft.Json](http://www.newtonsoft.com/json) - http://www.newtonsoft.com/json
    *  [Microsoft.CodeDom.Providers.DotNetCompilerPlatform](https://www.nuget.org/packages/Microsoft.CodeDom.Providers.DotNetCompilerPlatform/) - https://www.nuget.org/packages/Microsoft.CodeDom.Providers.DotNetCompilerPlatform/
    *  [Microsoft.Net.Compilers](https://www.nuget.org/packages/Microsoft.Net.Compilers) - https://www.nuget.org/packages/Microsoft.Net.Compilers


### Running on local machine

* Install any library prerequisites or dependencies on your local machine.


*  Download the code files to a directory.  Edit the **Web.config** file by replacing `<DEVELOER_KEY>` and `<DEVELOPER_SECRET>` with your developer key and secret credentials.


```csharp
    <!--
    Your API / Developer key you received when you registered your
    application at https://developer.biodigital.com
    -->
    <add key="CLIENT_ID" value="DEVELOPER_KEY"/>
    <!--
    Your API / Developer secret you received when you registered your
    application at https://developer.biodigital.com    
    -->
    <add key="CLIENT_SECRET" value="DEVELOPER_SECRET"/> 


```

*  Start Visual Studio and open the project via the **WebApp.sln** solution file.  

*  Run the [**Build** and **View in Browser**](https://msdn.microsoft.com/en-us/library/df5x06h3(v=vs.110).aspx) options to test the application via a browser.  

  
  

## Official Documentation

* Developer APIs and services:   [developer.biodigital.com](https://developer.biodigital.com)
* Developer FAQs and troubleshooting topics:  [devsupport.biodigital.com](https://devsupport.biodigital.com)
* Integration trouble?  General questions?  Contact developers@biodigital.com


## Author

* [BioDigital, Inc.](https://www.biodigital.com/)


## License

See the [LICENSE](https://github.com/biodigital-inc/bdhuman-contentapi/blob/master/LICENSE) file for more info.


## Disclaimer

These code examples are provided as is and are only intended to be used for illustration purposes. This code is not production-ready and is not meant to be used in a production environment. This repository is to be used as a tool to help developers learn how to integrate with [BioDigital, Inc.](https://www.biodigital.com/) API services. Any use of this repository or any of its code in a production environment is highly discouraged.

