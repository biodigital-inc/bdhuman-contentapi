BioDigital Human Content API using PHP 
========



Sample code using [PHP](https://secure.php.net/) to demonstrate making requests to the BioDigital Human Content API service.  This example provides a basic approach to:

* Requesting an access token from the BioDigital OAuth2 services
* Using an access token to make authorized requests to a Content API endpoint



## Getting Started

Below are the steps for getting this example running on your local machine for development and testing purposes.

### Prerequisites

1.  An [api / developer key and secret](https://devsupport.biodigital.com/hc/en-us/articles/234672847-Why-do-I-have-to-register-an-App-) from a verified and active BioDigital Developer account.  These will be used as your ***client id*** and ***client secret*** when making requests to the BioDigital OAuth2 services.


2. [PHP v5.6](https://secure.php.net/downloads.php) or higher.  


### Running on local machine

* Install any library prerequisites or dependencies on your local machine.

*  Download the code files to a directory.  Edit the **client.php** script file by:

   * _(Required)_  Replacing `<DEVELOER_KEY>` and `<DEVELOPER_SECRET>` with your developer key and secret credentials.

	* _(Optional)_  Set the defined SSLVERIFY variable to *false* to turn off ssl cert verification for request calls (default is *true*). 


```python
define('SSLVERIFY', false);  

// Your API / Developer key you received when you registered your
// application at https://developer.biodigital.com
define('CLIENT_ID', '<DEVELOPER_KEY>');

// Your API / Developer secret you received when you registered your
// application at https://developer.biodigital.com
define('CLIENT_SECRET', '<DEVELOPER_SECRET>');
```

*  Open a command terminal and switch to the root directory of the code files.  Run the **client.php** script via the PHP built in server by specfying a host and port:  

```
php -S localhost:5656 client.php
```

* Open a browser to the running server on http://_host_:_port_/    
  
  

## Official Documentation

For documentation on BioDigital Human developer APIs and services, please visit [developer.biodigital.com/documentation](https://developer.biodigital.com/documentation)

For access to BioDigital Human developer FAQs and troubleshooting topics, please visit [devsupport.biodigital.com](https://devsupport.biodigital.com)

## Author

* **BioDigital, Inc.** - developers@biodigital.com

