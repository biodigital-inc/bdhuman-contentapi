BioDigital Human Content API using Node.js 
========



Sample code using [Node.js](https://nodejs.org) to demonstrate making requests to the BioDigital Human Content API service.  This example provides a basic approach to:

* Requesting an access token from the BioDigital OAuth2 services
* Using an access token to make authorized requests to a Content API endpoint



## Getting Started

Below are the steps for getting this example running on your local machine for development and testing purposes.

### Prerequisites

1.  The **developer key and secret** of a [registered BioDigital developer application](https://devsupport.biodigital.com/hc/en-us/articles/234450188-How-to-register-my-App).  These credentials will be used as your *client id* and *client secret* when making requests to the BioDigital OAuth2 services.

2. [Node.js v7](https://nodejs.org/en/download/current/) or higher.
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

*  Open a command terminal and switch to the root directory of the code files.  Run the **client.js** script with the following command line parameters (unspecified optional parameters will use default values):
 
 	* **_--host=[VALUE]_**  (Optional):  server host value.  Default is 127.0.0.1.
 	* **_--port=[VALUE]_**   (Optional):  server port value.  Default is 5000.

```
node client.js --host localhost --port 5656
```

* Open a browser to the running server on http://localhost:5656/    
  
  

## Official Documentation

* Developer APIs and services:   [developer.biodigital.com/documentation](https://developer.biodigital.com/documentation)

* Developer FAQs and troubleshooting topics:  [devsupport.biodigital.com](https://devsupport.biodigital.com)


## Author

* **BioDigital, Inc.** - developers@biodigital.com


## License

See the [LICENSE](https://github.com/biodigital-inc/bdhuman-contentapi/blob/master/LICENSE) file for more info.

