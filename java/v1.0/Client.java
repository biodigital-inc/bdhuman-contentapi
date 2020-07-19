 
/** 
 ///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 // BioDigital Content API OAuth using Java SE Development Kit 8
 //
 // Author: BioDigital Inc.
 // Email: developers@biodigital.com
 //
 // This example uses the Common Cli 1.3.1, Google-Gson libraries, and references 
 // found here:  https://commons.apache.org/proper/commons-cli/
 //              https://github.com/google/gson
 //              https://docs.oracle.com/javase/tutorial/
 //
 // For more information about the OAuth process for web applications
 // accessing BioDigital APIs, please visit:
 // https://developer.biodigital.com
 //
 //////////////////////////////////////////////////////////////////////
 */

import java.io.*;
import java.util.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.net.URL;
import java.net.URLEncoder;
import java.net.HttpURLConnection;
import org.apache.commons.cli.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

 class Globals {

	// BioDigital OAuth endpoint for requesting an access token
	public static String OAUTH_TOKEN_URL = "https://apis.biodigital.com/oauth2/v1/token/";

	// BioDigital Content API endpoint for collection requests
	public static String CONTENTAPI_COLLECTIONS_URL = "https://apis.biodigital.com/services/v1/content/collections/";

	// Your API / Developer key you received when you registered your
	// application at https://developer.biodigital.com
	public static String CLIENT_ID = "<DEVELOPER_KEY>";

	// Your API / Developer secret you received when you registered your
	// application at https://developer.biodigital.com
	public static String CLIENT_SECRET = "<DEVELOPER_SECRET>";

	// The type of authorization being requested
	public static String GRANT_TYPE = "client_credentials";

	// The service scope in which your authorization will be used
	public static String SCOPE = "contentapi";

}

class RequestObject {
	public String grant_type ;
	public String scope;
}

class ResponseTokenObject {
	public String token_type;
	public String access_token;
	public String timestamp;
	public String expires_in;
	public Object error;
}

public class Client {

	private static Scanner s=new Scanner(System.in);
	private static Gson gson = new Gson();

	private static HttpURLConnection build_get_request(String url, HashMap<String, String> params, String access_token) throws IOException { 
		
		int count = 0; 
        StringBuilder urlParametersBuilder = new StringBuilder(); 
 
        for (Map.Entry<String, String> entry : params.entrySet()) { 
            String key = entry.getKey(); 
            String value = entry.getValue(); 
            if (count > 0) { 
                urlParametersBuilder.append("&"); 
            } 
			else{			
                urlParametersBuilder.append("?"); 
			}
            urlParametersBuilder.append(key).append("=").append(value); 
            count++; 
        } 
 
        url = url + urlParametersBuilder.toString();  
        URL requestURL = new URL(url); 
        HttpURLConnection connection = (HttpURLConnection) requestURL.openConnection(); 
        connection.setDoInput(true); 
        connection.setRequestMethod("GET"); 
		// Construct an Authorization header with the value of 'Bearer <access token>'
		connection.setRequestProperty ("Authorization", "Bearer " + access_token);
		connection.setRequestProperty("Accept", "application/json"); 
        connection.setUseCaches(false); 

        return connection; 
    } 

	private static HttpURLConnection build_post_request(String url, String content, String auth_str) throws IOException { 
			URL requestURL = new URL(url); 
			HttpURLConnection connection = (HttpURLConnection) requestURL.openConnection(); 
			connection.setDoInput(true); 
			connection.setDoOutput(true); 
			connection.setRequestMethod("POST"); 
			// Construct an Authorization header with the value of 'Basic <base64 encoded auth string>'
			connection.setRequestProperty ("Authorization", "Basic " + auth_str);
			connection.setRequestProperty("Content-Type", "application/json;charset=UTF-8"); 
			connection.setRequestProperty("Accept", "application/json"); 
 
			connection.setRequestProperty("Content-Length", "" + content.getBytes().length); 
			connection.setUseCaches (false); 
			OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream()); 
			writer.write(content); 
			writer.flush(); 
			writer.close(); 
 
			return connection; 
	} 

    private static String build_response(HttpURLConnection connection) throws IOException { 
        int responseCode = connection.getResponseCode(); 
        if (responseCode == 200 || responseCode == 201 || responseCode >= 400) { 
            BufferedReader in; 
            if (responseCode >= 400) { 
                in = new BufferedReader(new InputStreamReader(connection.getErrorStream())); 
            } 
            else { 
                in = new BufferedReader(new InputStreamReader(connection.getInputStream())); 
            } 
            String inputLine; 
            StringBuilder response = new StringBuilder(); 
            response.append(responseCode); 
            response.append(":"); 
 
            while((inputLine = in.readLine()) != null) { 
                response.append(inputLine); 
            } 
            in.close(); 
            return response.toString(); 
        } 
        else { 
            throw new IOException("Received bad response from server."); 
        } 
    } 

	private static String request_access_token() throws IOException {
	
	    // ***********************************************************
        // Exchanges basic client credentials for an access token
        // ***********************************************************

		String access_token = "";
		String auth_str = "";
		try {

			// Construct authentication string:
			//  1. Concatenate the client id, a colon character ":", and the client secret into a single string
			//  2. URL encode the string from step 1
			//  3. Base64 encode the string from step 2     
			auth_str = Globals.CLIENT_ID + ":" + Globals.CLIENT_SECRET;
			auth_str = Globals.CLIENT_ID + ":" + Globals.CLIENT_SECRET;
			byte[] utf8_bytes = auth_str.getBytes("UTF8");
			auth_str = new String(utf8_bytes, "UTF8");
			auth_str = Base64.getEncoder().encodeToString(auth_str.getBytes("utf-8"));

		  } catch (UnsupportedEncodingException e) {
			  e.printStackTrace();
		  }

		if (auth_str != ""){
		
			// For Private application authentication, you must specifiy
			// grant_type=client_credentials and the service scope.  For the 
			// Content API, scope=contentapi
   		    RequestObject post_data_obj = new RequestObject();
			post_data_obj.grant_type = Globals.GRANT_TYPE;
			post_data_obj.scope = Globals.SCOPE;
			String post_data_json = gson.toJson(post_data_obj);

			HttpURLConnection connection = build_post_request(Globals.OAUTH_TOKEN_URL,post_data_json,auth_str);
			String[] response_parts = build_response(connection).split(":",2);
			int response_code = Integer.parseInt(response_parts[0]);
			String response_body = response_parts[1];
			
	
			if ((response_code == HttpURLConnection.HTTP_BAD_REQUEST) || (response_code == HttpURLConnection.HTTP_INTERNAL_ERROR)){
			
				// Handle known error
				System.out.println("****************");
				System.out.println("****************");
				System.out.println("* Known Error  *"); 
				System.out.println("****************");
				System.out.println("****************");
				System.out.println("");
				System.out.println(response_body.toString());
				System.out.println("");

			}
			else if (response_code == HttpURLConnection.HTTP_OK) { 

				ResponseTokenObject response_obj = gson.fromJson(response_body.toString(), ResponseTokenObject.class);
				String token_expiry = "";
				try {
					SimpleDateFormat df = new SimpleDateFormat( "yyyy-MM-dd'T'HH:mm:ss" );
					String input = response_obj.timestamp;
					Calendar cal=Calendar.getInstance();
					cal.setTime(df.parse( input ));
					int seconds = Integer.parseInt(response_obj.expires_in);
					cal.set(Calendar.SECOND,(cal.get(Calendar.SECOND)+seconds));
					token_expiry = df.format(cal.getTime());
				} catch (ParseException e) {
				  e.printStackTrace();
				}

				System.out.println("****************************************");
				System.out.println("****************************************");
				System.out.println("* Successfully retrieved access token! *"); 
				System.out.println("****************************************");
				System.out.println("****************************************");
				System.out.println("");
				System.out.println("token_type: " + response_obj.token_type); 
				System.out.println("access_token: " + response_obj.access_token); 
				System.out.println("expires_in (sec): " + response_obj.expires_in); 
				System.out.println("token_expiry: " + token_expiry); 
				System.out.println("timestamp: " + response_obj.timestamp); 
				System.out.println("");
				access_token = response_obj.access_token;	
				System.out.println("");			

			} else {

				// Handle unknown error
				System.out.println("*****************");
				System.out.println("*****************");
				System.out.println("* Unknown Error *"); 
				System.out.println("*****************");
				System.out.println("*****************");
				System.out.println("");
				System.out.println(response_code);
				System.out.println(response_body);
				System.out.println("");

			}	
		}
		else {
			System.out.println("Error generating authentication string.");
		}
		return access_token;	
	}


	private static void query_collection_myhuman(String access_token) throws IOException {
	
	// ***********************************************************
	//  Query Content API with access token.
	// ***********************************************************

		HashMap<String, String> params = new HashMap<String, String>();
		params.clear();
		String url = Globals.CONTENTAPI_COLLECTIONS_URL + "myhuman";
		HttpURLConnection connection = build_get_request(url,params,access_token);
		String[] response_parts = build_response(connection).split(":",2);
		int response_code = Integer.parseInt(response_parts[0]);
		String response_body = response_parts[1];
		
		
		if ((response_code == HttpURLConnection.HTTP_BAD_REQUEST) || (response_code == HttpURLConnection.HTTP_INTERNAL_ERROR)){
			
			// Handle known error
			System.out.println("****************");
			System.out.println("****************");
			System.out.println("* Known Error *"); 
			System.out.println("****************");
			System.out.println("****************");
			System.out.println("");
			System.out.println(response_body.toString());
			System.out.println("");

		}
		else if (response_code == HttpURLConnection.HTTP_OK) { 

			System.out.println("***********");
			System.out.println("***********");
			System.out.println("* Success *"); 
			System.out.println("***********");
			System.out.println("***********");
			System.out.println("");
			System.out.println(response_body.toString());
			System.out.println("");

		} else {

			// Handle unknown error
			System.out.println("*****************");
			System.out.println("*****************");
			System.out.println("* Unknown Error *"); 
			System.out.println("*****************");
			System.out.println("*****************");
			System.out.println("");
			System.out.println(response_code);
			System.out.println(response_body);
			System.out.println("");

		}	

	}

    private static void pause (String msg) {
		System.out.println("");
		System.out.println(msg);
		System.out.println("");
        s.nextLine();	
	}

    public static void main(String[] args) throws Exception {

		new Cli(args).parse();
		System.out.println("");
		System.out.println("**************************************");
		System.out.println("**************************************");
        System.out.println("* Private Application Authentication *"); 
		System.out.println("**************************************");
		System.out.println("**************************************");
		System.out.println("");
		pause("Press enter to Request an Access Token");
		String access_token = request_access_token();

		if (access_token.equals("")){
			System.out.println("access token not retrieved");
		}
		else {

			System.out.println("***************************************");
			System.out.println("***************************************");
			System.out.println("* Query Content API with Access Token *"); 
			System.out.println("***************************************");
			System.out.println("***************************************");
			System.out.println("");
			pause("Press enter to Query Collection: myhuman");
			query_collection_myhuman(access_token);
			pause("Press enter to exit ...");

		} 
    }
}