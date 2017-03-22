BioDigital Human Content API using PHP 
========



Sample code using [PHP](https://secure.php.net/) to demonstrate making requests to the BioDigital Human Content API service.  This example provides a basic approach to:

* Requesting an access token from the BioDigital OAuth2 services
* Using an access token to make authorized requests to a Content API endpoint



## Getting Started

Below are the steps for getting this example running on your local machine for development and testing purposes.

### Prerequisites

1.  The **developer key and secret** of a [registered BioDigital developer application](https://devsupport.biodigital.com/hc/en-us/articles/234450188-How-to-register-my-App).  These credentials will be used as your *client id* and *client secret* when making requests to the BioDigital OAuth2 services.

2. [PHP v5.6](https://secure.php.net/downloads.php) or higher.  


### Running on local machine

* Install any library prerequisites or dependencies on your local machine.

*  Download the code files to a directory.  Edit the **client.php** script file by:

   * _(Required)_  Replacing `<DEVELOER_KEY>` and `<DEVELOPER_SECRET>` with your developer key and secret credentials.

	* _(Optional)_  Set the defined SSLVERIFY variable to *false* to turn off ssl cert verification for request calls (default is *true*). 


```php
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

* Open a browser to the running server on http://localhost:5656/    
  
  

## Official Documentation

* Developer APIs and services:   [developer.biodigital.com/documentation](https://developer.biodigital.com/documentation)

* Developer FAQs and troubleshooting topics:  [devsupport.biodigital.com](https://devsupport.biodigital.com)


## Author

* **BioDigital, Inc.** - developers@biodigital.com


## License

See the [LICENSE](https://github.com/biodigital-inc/bdhuman-contentapi/blob/master/LICENSE) file for more info.


