﻿BioDigital Human Content API using Python 
========



Code samples using [Python](https://www.python.org/) to demonstrate making requests to the BioDigital Human Content API.  These examples provide basic approaches to:

* Requesting an access token from the BioDigital OAuth2 services
* Using an access token to make authorized requests to various Content API endpoints


## Getting Started

Below are the steps for getting these example running on your local machine for development and testing purposes.


### Prerequisites

1.  The **developer key and secret** of a [registered BioDigital developer application](https://devsupport.biodigital.com/hc/en-us/articles/234450188-How-to-register-my-App).  These credentials will be used as your *client id* and *client secret* when making requests to the BioDigital OAuth2 services.

2. [Python v3.4](https://www.python.org/) or higher, along with the following python libraries:  

   * [Flask](http://flask.pocoo.org/)
   * [python-requests](http://docs.python-requests.org/)

### Running on local machine

* Install any library prerequisites or dependencies on your local machine.

*  Download the code files to a directory.  Edit the **client.py** script file by replacing `<DEVELOER_KEY>` and `<DEVELOPER_SECRET>` with your developer key and secret credentials. 


```python
# Your API / Developer key you received when you registered your
# application at https://developer.biodigital.com
"CLIENT_ID": "<DEVELOPER_KEY>",

# Your API / Developer secret you received when you registered your
# application at https://developer.biodigital.com
"CLIENT_SECRET": "<DEVELOPER_SECRET>"
```

*  Open a command terminal and switch to the root version directory (e.g. v2.0/) of the relevant code files.  Run the **client.py** python script with the following command line parameters (unspecified optional parameters will use default values):

 *  **_--debug_**  (Optional):  turns on [Werkzeug](http://werkzeug.pocoo.org/docs/0.11/debug/) debugging tracebacks. 
 *  **_--host=[VALUE]_**  (Optional):  flask server host value.  Default is 127.0.0.1.
 *  **_--port=[VALUE]_**   (Optional):  flask server port value.  Default is 5000.
 *  **_--sslverify=[True|False]_**  (Optional):  Turn on requests ssl cert verification.  Default is True.


```
python client.py --debug --host=localhost --port=5656 --sslverify=True
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
