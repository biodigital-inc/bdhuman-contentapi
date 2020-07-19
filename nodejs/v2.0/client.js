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
app.get('/query-collection-mycollections', query_collection_mycollections)
app.get('/query-collection-mycollections-id', query_collection_mycollections_id)
app.get('/query-collection-mycollections-id-contentlist', query_collection_mycollections_id_contentlist)

app.set("view engine", "ejs");

app.listen(settings.APP_PORT, settings.APP_HOST, function () {
    console.log("Server running at http://" + settings.APP_HOST + ":" + settings.APP_PORT + "/");
})

function index(req, res) {

    var status = 200;       
    var html = "<h3>Private Application Authentication</h3>";
    html += "<p><a href=\"/request-access-token\">Request Access Token</a></p>";
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
        var status = 200;  

        if (response.statusCode == 400 || response.statusCode == 500) {

            var response_obj = JSON.parse(body);
            var response_print = JSON.stringify(response_obj, undefined, 2);

            // Handle known error
            html += "<p><a href=\"/\">Start Over</a></p></body>";
            html += "<h3>Known Error:</h3>";
            html += "<p>";
            html += response_print;
            html += "</p>";
            res.type('text/html');
            res.status(status).send(html);

        }
        else if (response.statusCode == 200) {

            var response_obj = JSON.parse(body);

            params = {
                access_token: response_obj.access_token,
                token_type: response_obj.token_type,
                expires_in: response_obj.expires_in,
                timestamp: response_obj.timestamp
            }

            res.render("access-token", params); // access-token refers to access-token.ejs
        }
        else {
            // Handle unknown error
            status = response.statusCode
            html += "<p><a href=\"/\">Start Over</a></p></body>";
            html += "<h3>Unknown Error:</h3>";
            html += "<p>";
            html += status;
            html += "</p>";
            html += JSON.stringify(body);
            html += "<p>";
            html += JSON.stringify(error);
            html += "</p>";
            res.type('text/html');
            res.status(status).send(html);
        }

    }) 
}

function query_collection_myhuman(req, res) {

    // ***********************************************************
    //  Query Content API Collection with access token.
    // ***********************************************************       

    var access_token = req.query.access_token;
    var status = 200;
    var html = "";

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
                html += "<p><a href=\"/\">Start Over</a></p></body>";
                html += "<h3>Known Error:</h3>";
                html += "<p>";
                html += response_print;
                html += "</p>";
                res.type('text/html');
                res.status(status).send(html);

            }
            else if (response.statusCode == 200) {

                var response_obj = JSON.parse(body);
                var response_print = JSON.stringify(response_obj, undefined, 2);

                params = {
                    access_token: access_token,
                    endpoint_path: 'myhuman/',
                    myhuman_results: response_print
                }

                res.render("myhuman", params); // myhuman refers to myhuman.ejs

            }
            else {
                // Handle unknown error
                status = response.statusCode
                html += "<p><a href=\"/\">Start Over</a></p></body>";
                html += "<h3>Unknown Error:</h3>";
                html += "<p>";
                html += status;
                html += "</p>";
                html += JSON.stringify(body);
                html += "<p>";
                html += JSON.stringify(error);
                html += "</p>";
                res.type('text/html');
                res.status(status).send(html);
            }
        })               
    }
    else {
        status = 401;
        html += "<p>";
        html += "You did not provide the access_token parameter";
        html += "</p>";
        res.type('text/html');
        res.status(status).send(html);
    }

}

function query_collection_mycollections(req, res) {

    // ***********************************************************
    //  Query Content API Collection with access token.
    // ***********************************************************       

    var access_token = req.query.access_token;
    var status = 200;
    var html = "";

    if (access_token && req.query.access_token != "") {


        // Construct an Authorization header with the value of 'Bearer <access token>'
        var headers = {
            'Accept': 'application/json',
            "Authorization": "Bearer " + access_token,
            'Cache-Control': 'no-cache'
        }

        // Configure the request
        var url = settings.CONTENTAPI_COLLECTIONS_URL + "mycollections";
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
                html += "<p><a href=\"/\">Start Over</a></p></body>";
                html += "<h3>Known Error:</h3>";
                html += "<p>";
                html += response_print;
                html += "</p>";
                res.type('text/html');
                res.status(status).send(html);

            }
            else if (response.statusCode == 200) {

                var response_obj = JSON.parse(body);
                var response_print = JSON.stringify(response_obj, undefined, 2);

                params = {
                    access_token: access_token,
                    endpoint_path: 'mycollections/',
                    mycollections_results: response_print,
                    mycollections_results_obj: response_obj
                }

                res.render("mycollections", params); // mycollections refers to mycollections.ejs

            }
            else {
                // Handle unknown error
                status = response.statusCode
                html += "<p><a href=\"/\">Start Over</a></p></body>";
                html += "<h3>Unknown Error:</h3>";
                html += "<p>";
                html += status;
                html += "</p>";
                html += JSON.stringify(body);
                html += "<p>";
                html += JSON.stringify(error);
                html += "</p>";
                res.type('text/html');
                res.status(status).send(html);
            }
        })
    }
    else {
        status = 401;
        html += "<p>";
        html += "You did not provide the access_token parameter";
        html += "</p>";
        res.type('text/html');
        res.status(status).send(html);
    }

}

function query_collection_mycollections_id(req, res) {

    // ***********************************************************
    //  Query Content API Collection with access token.
    // ***********************************************************       

    var access_token = req.query.access_token;
    var collection_id = req.query.collection_id;
    var status = 200;
    var html = "";

    if (access_token && req.query.access_token != "") {


        // Construct an Authorization header with the value of 'Bearer <access token>'
        var headers = {
            'Accept': 'application/json',
            "Authorization": "Bearer " + access_token,
            'Cache-Control': 'no-cache'
        }

        // Configure the request
        var url = settings.CONTENTAPI_COLLECTIONS_URL + "mycollections/" + collection_id.toString();
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
                html += "<p><a href=\"/\">Start Over</a></p></body>";
                html += "<h3>Known Error:</h3>";
                html += "<p>";
                html += response_print;
                html += "</p>";
                res.type('text/html');
                res.status(status).send(html);

            }
            else if (response.statusCode == 200) {

                var response_obj = JSON.parse(body);
                var response_print = JSON.stringify(response_obj, undefined, 2);

                params = {
                    access_token: access_token,
                    endpoint_path: 'mycollections/' + collection_id.toString(),
                    mycollections_id_results: response_print,
                    mycollections_id_results_obj: response_obj
                }
                res.render("mycollections-id", params); // mycollections-id refers to mycollections-id.ejs         
            }
            else {
                // Handle unknown error
                status = response.statusCode
                html += "<p><a href=\"/\">Start Over</a></p></body>";
                html += "<h3>Unknown Error:</h3>";
                html += "<p>";
                html += status;
                html += "</p>";
                html += JSON.stringify(body);
                html += "<p>";
                html += JSON.stringify(error);
                html += "</p>";
                res.type('text/html');
                res.status(status).send(html);
            }
        })
    }
    else {
        status = 401;
        html += "<p>";
        html += "You did not provide the access_token parameter";
        html += "</p>";
        res.type('text/html');
        res.status(status).send(html);
    }

}

function query_collection_mycollections_id_contentlist(req, res) {

    // ***********************************************************
    //  Query Content API Collection with access token.
    // ***********************************************************       

    var access_token = req.query.access_token;
    var collection_id = req.query.collection_id;
    var status = 200;
    var html = "";

    if (access_token && req.query.access_token != "") {


        // Construct an Authorization header with the value of 'Bearer <access token>'
        var headers = {
            'Accept': 'application/json',
            "Authorization": "Bearer " + access_token,
            'Cache-Control': 'no-cache'
        }

        // Configure the request
        var url = settings.CONTENTAPI_COLLECTIONS_URL + "mycollections/" + collection_id.toString() + '/content_list';
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
                html += "<p><a href=\"/\">Start Over</a></p></body>";
                html += "<h3>Known Error:</h3>";
                html += "<p>";
                html += response_print;
                html += "</p>";
                res.type('text/html');
                res.status(status).send(html);

            }
            else if (response.statusCode == 200) {

                var response_obj = JSON.parse(body);
                var response_print = JSON.stringify(response_obj, undefined, 2);

                params = {
                    access_token: access_token,
                    endpoint_path: 'mycollections/' + collection_id.toString() + '/content_list',
                    mycollections_id_contentlist_results: response_print,
                    mycollections_id_contentlist_results_obj: response_obj
                }
                res.render("mycollections-id-content_list", params); // mycollections-id-content_list refers to mycollections-id-content_list.ejs         
            }
            else {
                // Handle unknown error
                status = response.statusCode
                html += "<p><a href=\"/\">Start Over</a></p></body>";
                html += "<h3>Unknown Error:</h3>";
                html += "<p>";
                html += status;
                html += "</p>";
                html += JSON.stringify(body);
                html += "<p>";
                html += JSON.stringify(error);
                html += "</p>";
                res.type('text/html');
                res.status(status).send(html);
            }
        })
    }
    else {
        status = 401;
        html += "<p>";
        html += "You did not provide the access_token parameter";
        html += "</p>";
        res.type('text/html');
        res.status(status).send(html);
    }

}
