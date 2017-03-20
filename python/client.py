# ///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
# // BioDigital Content API OAuth using Python 3
# //
# // Author: BioDigital Inc.
# // Email: developers@biodigital.com
# //
# // This example uses the Flask and requests libraries for Python 3
# // found here:  http://flask.pocoo.org/
# //              http://docs.python-requests.org/
# //
# // For more information about the OAuth process for web applications
# // accessing BioDigital APIs, please visit:
# // https://developer.biodigital.com
# //
# //////////////////////////////////////////////////////////////////////

from flask import Flask, redirect, request, jsonify
from flaskrun import flaskrun
import requests
from requests.adapters import HTTPAdapter
from requests.utils import to_native_string
import urllib.parse
import datetime
from base64 import b64encode
import json

app = Flask(__name__)

s = requests.Session()
s.mount('https://', HTTPAdapter(max_retries=0))

APP_CONFIG = {
    # BioDigital OAuth endpoint for requesting an access token
    'OAUTH_TOKEN_URL': "https://apis-qa.biodigital.com/oauth2/v1/token/",

    # BioDigital Content API endpoint for collection requests
    'CONTENTAPI_COLLECTIONS_URL': "https://apis-qa.biodigital.com/services/v1/content/collections/",

    # Your API / Developer key you received when you registered your
    # application at https://developer.biodigital.com
    "CLIENT_ID": "d55cf20916f2068f874267a91b15252d58bec804",

    # Your API / Developer secret you received when you registered your
    # application at https://developer.biodigital.com
    "CLIENT_SECRET": "984358f6cf63afc39ac986f25bb464c204e09a5c",

    # The type of authorization being requested
    'GRANT_TYPE': "client_credentials",

    # The service scope in which your authorization will be used
    'SCOPE': "contentapi"

    }

@app.route("/")
def index():

    html = '<pre>'
    html += '<h3>Private Application Authentication</h3>'         
    html += '<pre>'
    html += '<a href="/request-access-token">Request Access Token</a>'
    return html

@app.route("/request-access-token")
def request_access_token():
    """
        Exchanges basic client credentials for an access token.
    """

    # For Private application authentication, you must specifiy
    # grant_type=client_credentials and the service scope.  For the 
    # Content API, scope=contentapi
    post_data = {"grant_type": APP_CONFIG['GRANT_TYPE'],
                 "scope": APP_CONFIG['SCOPE']}
    post_data_string = json.dumps(post_data)

    # Construct authentication string:
    #  1. Concatenate the client id, a colon character ":", and the client secret into a single string
    #  2. URL encode the string from step 1
    #  3. Base64 encode the string from step 2
    authstr = to_native_string(
        b64encode(('%s:%s' % (APP_CONFIG['CLIENT_ID'], APP_CONFIG['CLIENT_SECRET'])).encode('utf-8'))).strip()

    # Construct an Authorization header with the value of 'Basic <base64 encoded auth string>'
    headers = {
        "Content-Type": "application/json;charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Basic " + authstr
    }

    r = s.post(APP_CONFIG['OAUTH_TOKEN_URL'], data=post_data_string, headers=headers, verify=(app.config['SSLVERIFY'] == 'True'))

    if r.status_code in (400,500):

        # Handle known error
        result = r.json() 
        return jsonify(result)

    elif r.status_code == 200:

        result = r.json()         
        access_token = result['access_token']
        token_type = result['token_type']
        timestamp = result.get('timestamp', None)
        expires_in = result.get('expires_in', None)
        token_expiry = None
        if expires_in is not None:
            token_expiry = datetime.datetime.strptime(timestamp, '%Y-%m-%dT%H:%M:%S')
            token_expiry = token_expiry + datetime.timedelta(seconds=expires_in)
            token_expiry = token_expiry.isoformat()

        html = '<pre>';
        html += '<h3>Successfully retrieved access token!</h3>'         
        html += '<pre>';
        html += 'access_token : ' + access_token
        html += '<pre>';
        html += 'token_type : ' + token_type
        html += '<pre>';
        html += 'expires_in (sec) : ' + str(expires_in)
        html += '<pre>';
        html += 'token_expiry : ' + token_expiry
        html += '<pre>';
        html += 'timestamp : ' + timestamp

        html += '<pre>';
        html += '<h3>Query Content API with Access Token</h3>'
        html += '<pre>';
        html += '<a href="/query-collection-myhuman?access_token='+access_token+'">Query Collection: myhuman</a>'

        return html

    else:
        # Handle unknown error
        return (r.text, r.status_code, r.headers.items())



@app.route("/query-collection-myhuman")
def query_collection_myhuman():
    """
        Query Content API Collection with access token.
    """

    access_token = request.args.get("access_token", None)

    if access_token is not None and access_token != '':

        # Construct an Authorization header with the value of 'Bearer <access token>'
        headers = {
            "Accept": "application/json",
            "Authorization": "Bearer " + access_token
        }
        url = APP_CONFIG['CONTENTAPI_COLLECTIONS_URL'] + 'myhuman'
        r = s.get(url, headers=headers, verify=(app.config['SSLVERIFY'] == 'True'))
        
        if r.status_code in (200, 400, 500):

            # Handle known errors
            result = r.json()
            return jsonify(result)

        elif r.status_code == 200:

            result = r.json()
            return jsonify(result)

        else:                 
          # Handle unknown error
          return (r.text, r.status_code, r.headers.items())

    else:
        return "access_token not specified"

 

flaskrun(app)