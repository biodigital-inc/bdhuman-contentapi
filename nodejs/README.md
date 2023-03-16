BioDigital Human Content API using Node.js 
========



Code samples using [Node.js](https://nodejs.org) to demonstrate making requests to the BioDigital Human Content API.  These examples provide basic approaches to:

* Requesting an access token from the BioDigital OAuth2 services
* Using an access token to make authorized requests to various Content API endpoints



## Getting Started

Below are the steps for getting this example running on your local machine for development and testing purposes.

### Prerequisites

1.  The **developer key and secret** of a [registered BioDigital developer application](https://devsupport.biodigital.com/hc/en-us/articles/234450188-How-to-register-my-App).  These credentials will be used as your *client id* and *client secret* when making requests to the BioDigital OAuth2 services.

2. [Node.js v4.2.2](https://nodejs.org/en/download/current/) or higher.
3. [npm v3](https://nodejs.org/en/download/current/) or higher (should be included with Node.js installation), along with the below packages, which are listed in the provided **package.json** file.  Running `npm install` on the provided **package.json** file should download and install these dependencies:
	*  [express](https://www.npmjs.com/package/express) - https://www.npmjs.com/package/express
	*  [minimist](https://www.npmjs.com/package/minimist) - https://www.npmjs.com/package/minimist
	*  [request](https://www.npmjs.com/package/request) - https://www.npmjs.com/package/request
	*  [utf8](https://www.npmjs.com/package/utf8) - https://www.npmjs.com/package/utf8


### Running on local machine

* Install any library prerequisites or dependencies on your local machine.


*  Download the code files to a directory.  Edit the **settings.js** script file by replacing `<DEVELOER_KEY>` and `<DEVELOPER_SECRET>` with your developer key and secret credentials.


```node
// Your API / Developer key you received when you registered your
// application at https://developer.biodigital.com
exports.CLIENT_ID = '<DEVELOPER_KEY>';

// Your API / Developer secret you received when you registered your
// application at https://developer.biodigital.com
exports.CLIENT_SECRET = '<DEVELOPER_SECRET>';

```

*  Open a command terminal and switch to the root version directory (e.g. v2.0/) of the relevant code files.  Run the **client.js** script with the following command line parameters (unspecified optional parameters will use default values):
 
 	* **_--host=[VALUE]_**  (Optional):  server host value.  Default is 127.0.0.1.
 	* **_--port=[VALUE]_**   (Optional):  server port value.  Default is 5000.

```
node client.js --host localhost --port 5656
```

* Open a browser to the running server on http://localhost:5656/    
  
  

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

