BioDigital Human Content API using Ruby 
========



Sample code using [Ruby](https://www.ruby-lang.org) to demonstrate making requests to the BioDigital Human Content API service.  This example provides a basic approach to:

* Requesting an access token from the BioDigital OAuth2 services
* Using an access token to make authorized requests to a Content API endpoint



## Getting Started

Below are the steps for getting this example running on your local machine for development and testing purposes.

### Prerequisites

1.  The developer key and secret of a [registered BioDigital developer application](https://devsupport.biodigital.com/hc/en-us/articles/234450188-How-to-register-my-App).  These credentials will be used as your ***client id*** and ***client secret*** when making requests to the BioDigital OAuth2 services.

2. [Ruby v2.3](https://www.ruby-lang.org/en/downloads/) or higher.


### Running on local machine

* Install any library prerequisites or dependencies on your local machine.


*  Download the code files to a directory.  Edit the **client.rb** script file by replacing `<DEVELOER_KEY>` and `<DEVELOPER_SECRET>` with your developer key and secret credentials.


```ruby
# Your API / Developer key you received when you registered your
# application at https://developer.biodigital.com
$CLIENT_ID = '<DEVELOPER_KEY>'

# Your API / Developer secret you received when you registered your
# application at https://developer.biodigital.com
$CLIENT_SECRET = '<DEVELOPER_SECRET>'

```

*  Open a command terminal and switch to the root directory of the code files.  Run the **client.rb** script with the following command line parameters (unspecified optional parameters will use default values):
 
 	* **_--host=[VALUE]_**  (Optional):  server host value.  Default is 127.0.0.1.
 	* **_--port=[VALUE]_**   (Optional):  server port value.  Default is 5000.
 	* **_--sslverify=[true|false]_**  (Optional):  Turn on requests ssl cert verification.  Default is true.

```
ruby client.rb --host localhost --port 5656 --sslverify=true
```

* Open a browser to the running server on http://_host_:_port_/    
  
  

## Official Documentation

* Developer APIs and services:   [developer.biodigital.com/documentation](https://developer.biodigital.com/documentation)

* Developer FAQs and troubleshooting topics:  [devsupport.biodigital.com](https://devsupport.biodigital.com)


## Author

* **BioDigital, Inc.** - developers@biodigital.com


## License

See the [LICENSE](https://github.com/biodigital-inc/bdhuman-contentapi/blob/master/LICENSE) file for more info.
