BioDigital Human Content API using .NET Visual C#
========



Sample code using a [.NET 4.5 Visual Studio 2015 C# Web Application](https://msdn.microsoft.com/en-us/library/kx37x362.aspx) to demonstrate making requests to the BioDigital Human Content API service.  This example provides a basic approach to:

* Requesting an access token from the BioDigital OAuth2 services
* Using an access token to make authorized requests to a Content API endpoint



## Getting Started

Below are the steps for getting this example running on your local machine for development and testing purposes.

### Prerequisites

1.  An [api / developer key and secret](https://devsupport.biodigital.com/hc/en-us/articles/234672847-Why-do-I-have-to-register-an-App-) from a verified and active BioDigital Developer account.  These will be used as your ***client id*** and ***client secret*** when making requests to the BioDigital OAuth2 services.


2. This web application was created using the [Visual Studio Community (2015)](https://www.visualstudio.com/vs/community/) IDE.  Ensure the **Visual C#** Programming Language feature is selected upon installation.
 
3. This web application uses the following [NuGet packages](https://www.nuget.org/), in addition to the standard toolkit.  These packages should be listed within the provided **package.config** file and can be mangaged via the [NuGet Package Manager UI in Visual Studio](https://docs.microsoft.com/en-us/nuget/tools/package-manager-ui):
	*  [Newtonsoft.Json](http://www.newtonsoft.com/json) - http://www.newtonsoft.com/json


### Running on local machine

* Install any library prerequisites or dependencies on your local machine.


*  Download the code files to a directory.  Edit the **Web.config** file by replacing `<DEVELOER_KEY>` and `<DEVELOPER_SECRET>` with your developer key and secret credentials.


```cs
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

*  Run the [**Build** and **View in Browswer**](https://msdn.microsoft.com/en-us/library/df5x06h3(v=vs.110).aspx) options to test the application via a browser.  

  
  

## Official Documentation

For documentation on BioDigital Human developer APIs and services, please visit [developer.biodigital.com/documentation](https://developer.biodigital.com/documentation)

For access to BioDigital Human developer FAQs and troubleshooting topics, please visit [devsupport.biodigital.com](https://devsupport.biodigital.com)

## Author

* **BioDigital, Inc.** - developers@biodigital.com

