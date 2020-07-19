/** 
 ///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 // BioDigital Content API OAuth using Node.js
 //
 // Author: BioDigital Inc.
 // Email: developers@biodigital.com
 //
 // This example uses the Node v4.2.2, npm v3.10.9, and the minimist, utf8,
 // request, and express libraries, 
 // and references found here:  https://nodejs.org/en/
 //                             https://www.npmjs.com
 //                             https://www.npmjs.com/package/minimist
 //                             https://www.npmjs.com/package/utf8
 //                             https://www.npmjs.com/package/express
 //                             https://www.npmjs.com/package/request
 //
 // For more information about the OAuth process for web applications
 // accessing BioDigital APIs, please visit:
 // https://developer.biodigital.com
 //
 //////////////////////////////////////////////////////////////////////
 */
     
var settings = require('./settings');
var utf8 = require('utf8');
var request = require('request');
var express = require('express')
var app = express()

/*Add routes*/
app.get('/', index)
app.get('/request-access-token', request_access_token)
app.get('/query-collection-myhuman', query_collection_myhuman)

app.listen(settings.APP_PORT, settings.APP_HOST, function () {
    console.log("Server running at http://" + settings.APP_HOST + ":" + settings.APP_PORT + "/");
})

function index(req, res) {

    var html = '';
    var status = 200;

    html += '<pre>';
    html += '<h3>Private Application Authentication</h3>';
    html += '<pre>';
    html += '<a href="/request-access-token">Request Access Token</a>';
    res.type('text/html');
    res.status(status).send(html);
}

function request_access_token(req, res) {


    // ***********************************************************
    // Exchanges basic client credentials for an access token
    // ***********************************************************

    // Construct authentication string:
    //  1. Concatenate the client id, a colon character ":", and the client secret into a single string
    //  2. URL encode the string from step 1
    //  3. Base64 encode the string from step 2  
    var auth_str = settings.CLIENT_ID + ":" + settings.CLIENT_SECRET;
    auth_str = utf8.encode(auth_str);
    var buffer = new Buffer(auth_str);
    auth_str = buffer.toString('base64');

	// For Private application authentication, you must specifiy
	// grant_type=client_credentials and the service scope.  For the 
	// Content API, scope=contentapi
    var post_data_string = JSON.stringify({
        "grant_type": settings.GRANT_TYPE,
        "scope": settings.SCOPE
    });

    // Construct an Authorization header with the value of 'Basic <base64 encoded auth string>'
    var headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/json',
        "Authorization": "Basic " + auth_str
    }

    // Configure the request
    var url = settings.OAUTH_TOKEN_URL;
    var options = {
        url: url,
        method: 'POST',
        headers: headers,
        form: post_data_string
    }

    // Start the request
    request(options, function (error, response, body) {

        var html = "";
        html += "<pre>";
        html += "<a href=\"/\">Start Over</a>";
        var status = 200;  

        if (response.statusCode == 400 || response.statusCode == 500) {

            var response_obj = JSON.parse(body);
            var response_print = JSON.stringify(response_obj, undefined, 2);

            // Handle known error
            html += "<pre>";
            html += "<h3>Known Error:</h3>";
            html += "<pre>";
            html += response_print;

        }
        else if (response.statusCode == 200) {

            var response_obj = JSON.parse(body);

            html += "<pre>";
            html += "<h3>Successfully requested access token!</h3>";
            html += "<pre>";
            html += "token_type:  " + response_obj.token_type + "";
            html += "<pre>";
            html += "access_token:  " + response_obj.access_token + "";
            html += "<pre>";
            html += "token_type:  " + response_obj.token_type + "";
            html += "<pre>";
            html += "expires_in (sec):  " + response_obj.expires_in + "";
            html += "<pre>";
            html += "timestamp:  " + response_obj.timestamp + "";

            html += "<pre>";
            html += "<h3>Query Content API with Access Token</h3>";
            html += "<pre>";
            html += "<a href=\"/query-collection-myhuman?access_token=" + response_obj.access_token + "\">Query Collection: myhuman</a>";

        }
        else {
            // Handle unknown error
            status = response.statusCode
            html += "<pre>";
            html += "<h3>Unknown Error:</h3>";
            html += "<pre>";
            html += status;
            html += "<pre>";
            html += JSON.stringify(body);
            html += "<pre>";
            html += JSON.stringify(error);
        }

        res.type('text/html');
        res.status(status).send(html);
    }) 
}

function query_collection_myhuman(req, res) {

    // ***********************************************************
    //  Query Content API Collection with access token.
    // ***********************************************************       

    var access_token = req.query.access_token;
    var status = 200;
    var html = "";
    html += "<pre>";
    html += "<a href=\"/\">Start Over</a>";

    if (access_token && req.query.access_token != "") {


        // Construct an Authorization header with the value of 'Bearer <access token>'
        var headers = {
            'Accept': 'application/json',
            "Authorization": "Bearer " + access_token,
            'Cache-Control': 'no-cache'
        }

        // Configure the request
        var url = settings.CONTENTAPI_COLLECTIONS_URL + "myhuman";
        var options = {
            url: url,
            method: 'GET',
            headers: headers
        }

        // Start the request
        request(options, function (error, response, body) {

            if (response.statusCode == 400 || response.statusCode == 500) {

                var response_obj = JSON.parse(body);
                var response_print = JSON.stringify(response_obj, undefined, 2);

                // Handle known error
                html += "<pre>";
                html += "<h3>Known Error:</h3>";
                html += "<pre>";
                html += response_print;

            }
            else if (response.statusCode == 200) {

                var response_obj = JSON.parse(body);
                var response_print = JSON.stringify(response_obj, undefined, 2);

                // Handle known error
                html += "<pre>";
                html += "<h3>Success:</h3>";
                html += "<pre>";
                html += response_print;

            }
            else {
                // Handle unknown error
                status = response.statusCode
                html += "<pre>";
                html += "<h3>Unknown Error:</h3>";
                html += "<pre>";
                html += status;
                html += "<pre>";
                html += JSON.stringify(body);
                html += "<pre>";
                html += JSON.stringify(error);
            }

            res.type('text/html');
            res.status(status).send(html);

        })               
    }
    else {
        status = 401;
        html += "<pre>";
        html += "You did not provide the access_token parameter";
        res.type('text/html');
        res.status(status).send(html);
    }

}

