<?php

///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
// BioDigital Content API OAuth using PHP 5.6
//
// Author: BioDigital Inc.
// Email: developers@biodigital.com
//
// This example uses PHP sample code
// found here:  https://www.oauth.com/oauth2-servers/oauth2-clients/server-side-apps/
//
// For more information about the OAuth process for web applications
// accessing BioDigital APIs, please visit:
// https://developer.biodigital.com
//
//////////////////////////////////////////////////////////////////////

define('SSLVERIFY', false);  

// BioDigital OAuth endpoint for requesting an access token
define('OAUTH_TOKEN_URL', 'https://apis.biodigital.com/oauth2/v2/token/');

// BioDigital Content API endpoint for collection requests
define('CONTENTAPI_COLLECTIONS_URL', 'https://apis.biodigital.com/services/v2/content/collections/');

// Your API / Developer key you received when you registered your
// application at https://developer.biodigital.com
define('CLIENT_ID', '<DEVELOPER_KEY>');

// Your API / Developer secret you received when you registered your
// application at https://developer.biodigital.com
define('CLIENT_SECRET', '<DEVELOPER_SECRET>');

// The type of authorization being requested
define('GRANT_TYPE', 'client_credentials');

// The service scope in which your authorization will be used
define('SCOPE', 'contentapi');    


// Start a session so we have a place to store things
session_start();

include_once('myview.php');

// Helper functions:  These functions let us access query string parameters
// and session data easily without checking if keys exist first.
function get($key, $default=NULL) {
    return array_key_exists($key, $_GET) ? $_GET[$key] : $default;
}
function session($key, $default=NULL) {
    return array_key_exists($key, $_SESSION) ? $_SESSION[$key] : $default;
}

function request_access_token(){
    
    // ***********************************************************
    // Exchanges basic client credentials for an access token
    // ***********************************************************

    // Construct authentication string:
    //  1. Concatenate the client id, a colon character ":", and the client secret into a single string
    //  2. URL encode the string from step 1
    //  3. Base64 encode the string from step 2  
    $authstr = '%s:%s';
    $authstr = sprintf($authstr, CLIENT_ID, CLIENT_SECRET);
    $authstr = iconv(mb_detect_encoding($authstr, mb_detect_order(), true), "UTF-8", $authstr);
    $authstr = base64_encode($authstr);

    # For Private application authentication, you must specifiy
    # grant_type=client_credentials and the service scope.  For the 
    # Content API, scope=contentapi
    $post_data = array(
    'grant_type' => GRANT_TYPE,
    'scope' => SCOPE
    );
    $post_data_string = json_encode($post_data);

    $ch = curl_init(OAUTH_TOKEN_URL);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, SSLVERIFY);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS,"POST");
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data_string);

    // Construct an Authorization header with the value of 'Basic <base64 encoded auth string>'
    $headers[] = 'Authorization: Basic ' . $authstr;
    $headers[] = 'Content-Type: application/json;charset=UTF-8';
    $headers[] = 'Accept: application/json';
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    $response  = curl_exec($ch);

    if(curl_error($ch))
    {
        # Handle unknown error
        echo '<pre>';
        echo '<h3>Unknown Error:</h3>';
        echo '<pre>';
        echo curl_error($ch);
    }
    else
    {
        $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $json = json_decode($response);
        $json_print = json_encode($json, JSON_PRETTY_PRINT);
       
        if (in_array($httpcode, array(400,500), true) ){

            # Handle known error
            echo '<pre>';
            echo '<h3>Known Error:</h3>';
            echo '<pre>';
            echo $json_print;

        }
        else if ($httpcode == 200)
        {
            $results = json_decode($response);
            $_SESSION['access_token'] = $results->access_token;
            $_SESSION['token_type'] = $results->token_type;
            $_SESSION['expires_in'] = $results->expires_in;
            $_SESSION['timestamp'] = $results->timestamp;
            $dtime = DateTime::createFromFormat("Y-m-d\TH:i:s", $results->timestamp);
            $dtime->add(DateInterval::createFromDateString($results->expires_in . ' seconds'));
            $_SESSION['token_expiry'] = $dtime->format('Y-m-d\TH:i:s');

			$t = new MyView();
			$t->access_token = $_SESSION['access_token'];
			$t->token_type = $results->token_type;
			$t->expires_in = $results->expires_in;
			$t->timestamp = $results->timestamp;
			$t->token_expiry = $_SESSION['token_expiry'];

			$t->render('access-token.phtml');
        }
    }
    curl_close($ch);
}

function query_collection_myhuman ($access_token){

    // ***********************************************************
    //  Query Content API Collection with access token.
    // ***********************************************************       

    $url = CONTENTAPI_COLLECTIONS_URL . "myhuman";

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); # do not output, but store to variable
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, SSLVERIFY);

    # Construct an Authorization header with the value of 'Bearer <access token>'
    $headers[] = 'Authorization: Bearer ' . $access_token;
    $headers[] = 'Accept: application/json';
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    $response  = curl_exec($ch);

    if(curl_error($ch))
    {
        # Handle unknown error
        echo '<pre>';
        echo '<h3>Unknown Error:</h3>';
        echo '<pre>';
        echo curl_error($ch);
    }
    else
    {
        $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $json = json_decode($response);
        $json_print = json_encode($json, JSON_PRETTY_PRINT);

		$t = new MyView();

        if (in_array($httpcode, array(400,500), true)){

			$t->reponse_status = "Error!";
       }
        else if ($httpcode == 200)
        {
			$t->reponse_status = "Successful!";
        }
		$t->access_token = $_SESSION['access_token'];
		$t->endpoint_path = 'myhuman/';
		$t->myhuman_results = $json_print;

		$t->render('myhuman.phtml');
    }
    curl_close($ch);    
}

function query_collection_mycollections ($access_token){

    // ***********************************************************
    //  Query Content API Collection with access token.
    // ***********************************************************       

    $url = CONTENTAPI_COLLECTIONS_URL . "mycollections";

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); # do not output, but store to variable
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, SSLVERIFY);

    # Construct an Authorization header with the value of 'Bearer <access token>'
    $headers[] = 'Authorization: Bearer ' . $access_token;
    $headers[] = 'Accept: application/json';
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    $response  = curl_exec($ch);

    if(curl_error($ch))
    {
        # Handle unknown error
        echo '<pre>';
        echo '<h3>Unknown Error:</h3>';
        echo '<pre>';
        echo curl_error($ch);
    }
    else
    {
        $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $json = json_decode($response);
        $json_print = json_encode($json, JSON_PRETTY_PRINT);

		$t = new MyView();

        if (in_array($httpcode, array(400,500), true)){

			$t->reponse_status = "Error!";
       }
        else if ($httpcode == 200)
        {
			$t->reponse_status = "Successful!";
        }
		$t->access_token = $_SESSION['access_token'];
		$t->endpoint_path = 'mycollections/';
		$t->mycollections_results = $json_print;
		$t->mycollections_results_obj = $json;

		$t->render('mycollections.phtml');
    }
    curl_close($ch);    
}

function query_collection_mycollections_id ($access_token, $collection_id){

    // ***********************************************************
    //  Query Content API Collection with access token.
    // ***********************************************************       

    $url = CONTENTAPI_COLLECTIONS_URL . "mycollections/$collection_id";

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); # do not output, but store to variable
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, SSLVERIFY);

    # Construct an Authorization header with the value of 'Bearer <access token>'
    $headers[] = 'Authorization: Bearer ' . $access_token;
    $headers[] = 'Accept: application/json';
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    $response  = curl_exec($ch);

    if(curl_error($ch))
    {
        # Handle unknown error
        echo '<pre>';
        echo '<h3>Unknown Error:</h3>';
        echo '<pre>';
        echo curl_error($ch);
    }
    else
    {
        $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $json = json_decode($response);
        $json_print = json_encode($json, JSON_PRETTY_PRINT);

		$t = new MyView();

        if (in_array($httpcode, array(400,500), true)){

			$t->reponse_status = "Error!";
       }
        else if ($httpcode == 200)
        {
			$t->reponse_status = "Successful!";
        }
		$t->access_token = $_SESSION['access_token'];
		$t->endpoint_path = "mycollections/$collection_id";
		$t->mycollections_id_results = $json_print;
		$t->mycollections_id_results_obj = $json;

		$t->render('mycollections-id.phtml');
    }
    curl_close($ch);   
}

function query_collection_mycollections_id_content_list ($access_token, $collection_id){

    // ***********************************************************
    //  Query Content API Collection with access token.
    // ***********************************************************       

    $url = CONTENTAPI_COLLECTIONS_URL . "mycollections/$collection_id/content_list";

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); # do not output, but store to variable
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, SSLVERIFY);

    # Construct an Authorization header with the value of 'Bearer <access token>'
    $headers[] = 'Authorization: Bearer ' . $access_token;
    $headers[] = 'Accept: application/json';
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    $response  = curl_exec($ch);

    if(curl_error($ch))
    {
        # Handle unknown error
        echo '<pre>';
        echo '<h3>Unknown Error:</h3>';
        echo '<pre>';
        echo curl_error($ch);
    }
    else
    {
        $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $json = json_decode($response);
        $json_print = json_encode($json, JSON_PRETTY_PRINT);

		$t = new MyView();

        if (in_array($httpcode, array(400,500), true)){

			$t->reponse_status = "Error!";
       }
        else if ($httpcode == 200)
        {
			$t->reponse_status = "Successful!";
        }
		$t->access_token = $_SESSION['access_token'];
		$t->endpoint_path = "mycollections/$collection_id/content_list";
		$t->mycollections_id_contentlist_results = $json_print;
		$t->mycollections_id_contentlist_results_obj = $json;

		$t->render('mycollections-id-content_list.phtml');
    }
    curl_close($ch);   
}


try {

    if (get('action') == 'request_access_token'){
        request_access_token();
    }
    else if (get('action') == 'query_collection_myhuman'){
        query_collection_myhuman(get('access_token'));
    }
    else if (get('action') == 'query_collection_mycollections'){
        query_collection_mycollections(get('access_token'));
    }
    else if (get('action') == 'query_collection_mycollections_id'){
        query_collection_mycollections_id(get('access_token'), get('collection_id'));
    }
    else if (get('action') == 'query_collection_mycollections_id_content_list'){
        query_collection_mycollections_id_content_list(get('access_token'), get('collection_id'));
    }
    else {
         echo '<pre>';
         echo '<h3>Private Application Authentication</h3>';
         echo '<pre>';
         echo '<a href="?action=request_access_token">Request Access Token</a>';
     }

} catch(OAuthException $e) {
    echo '<pre>';
    print_r($e);
}

?>