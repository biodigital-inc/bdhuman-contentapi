///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
// BioDigital Content API OAuth using .NET Visual C# Web Application 
// .NET Framework 4.5 
//
// Author: BioDigital Inc.
// Email: developers@biodigital.com
//
// This example uses the Newtonsoft.Json package for .NET Framework 4.5.2 
// found here:  http://www.newtonsoft.com/json
//             
//
// For more information about the OAuth process for web applications
// accessing BioDigital APIs, please visit:
// https://developer.biodigital.com
//
//////////////////////////////////////////////////////////////////////

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.Script.Serialization;
using System.Configuration;
using System.Diagnostics;
using System.Text;
using System.Net;
using Newtonsoft.Json;

using WebApplication1.App_Code;
using System.IO;
using Newtonsoft.Json.Linq;


namespace WebApplication1
{
    public partial class WebForm1 : Token
    {
        // BioDigital OAuth endpoint for requesting an access token
        string oauth_token_url = ConfigurationManager.AppSettings["OAUTH_TOKEN_URL"];

        // BioDigital Content API endpoint for collection requests
        string content_service_url = ConfigurationManager.AppSettings["CONTENTAPI_COLLECTIONS_URL"];

        // Your API / Developer key you received when you registered your
        // application at https://developer.biodigital.com
        string client_id = ConfigurationManager.AppSettings["CLIENT_ID"];

        // Your API / Developer secret you received when you registered your
        // application at https://developer.biodigital.com
        string client_secret = ConfigurationManager.AppSettings["CLIENT_SECRET"];

        // The type of authorization being requested
        string grant_type = ConfigurationManager.AppSettings["GRANT_TYPE"];

        // The service scope in which your authorization will be used
        string scope = ConfigurationManager.AppSettings["SCOPE_CONTENTAPI"];

        struct OAUTH_VIEW
        {
            public static int request_access_token = 0;
            public static int query_collection_myhuman = 1;
            public static int success = 2;
            public static int known_error = 3;
            public static int unknown_error = 4;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;
                initialize();
            }
        }

        protected void request_access_token_Click(object sender, EventArgs e)
        {
            // ***********************************************************
            // Exchanges basic client credentials for an access token
            // ***********************************************************

            // Construct authentication string:
            //  1. Concatenate the client id, a colon character ":", and the client secret into a single string
            //  2. URL encode the string from step 1
            //  3. Base64 encode the string from step 2     
            string auth_str = String.Concat(client_id, ":", client_secret);
            byte[] utf8_bytes = Encoding.Default.GetBytes(auth_str);
            auth_str = Encoding.UTF8.GetString(utf8_bytes);
            utf8_bytes = Encoding.Default.GetBytes(auth_str);
            auth_str = System.Convert.ToBase64String(utf8_bytes);

            // For Private application authentication, you must specifiy
            // grant_type=client_credentials and the service scope.  For the 
            // Content API, scope=contentapi
            Token.RequestObject post_data = new Token.RequestObject
            {
                grant_type = grant_type,
                scope = scope
            };
            string post_data_json = JsonConvert.SerializeObject(post_data);

            try
            {
                var url = oauth_token_url;
                HttpWebRequest webRequest = HttpWebRequest.Create(url) as HttpWebRequest;
                webRequest.Method = WebRequestMethods.Http.Post;
                //  Construct an Authorization header with the value of 'Basic <base64 encoded auth string>'
                webRequest.Headers.Add("Authorization", "Basic " + auth_str);
                webRequest.ContentType = "application/json;charset=UTF-8";
                webRequest.Accept = "application/json";

                using (var streamWriter = new StreamWriter(webRequest.GetRequestStream()))
                {
                    streamWriter.Write(post_data_json);
                }

                string redirect = "";

                using (HttpWebResponse response = webRequest.GetResponse() as HttpWebResponse)
                {
                    string result;
                    using (var stream = response.GetResponseStream())
                    using (var reader = new StreamReader(stream))
                    {
                        result = reader.ReadToEnd();
                    }

                    if (response.StatusCode == HttpStatusCode.OK)
                    {
                        ResponseObject token_obj = JsonConvert.DeserializeObject<Token.ResponseObject>(result);
                        Session["token_obj"] = token_obj;
                        token_type_ltl.Text = token_obj.token_type;
                        access_token_ltl.Text = token_obj.access_token;
                        expires_in_ltl.Text = token_obj.expires_in;
                        timestamp_ltl.Text = token_obj.timestamp;    

                        oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.query_collection_myhuman;
                    }
                    else
                    {
                        // Handle unknown error
                        unknown_error_lbl.Text = String.Concat(response.StatusCode, ", ", response.StatusDescription, ", ", result) ;
                        oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.unknown_error;
                    }
                }

            }
            catch (WebException ex)
            {
                if (ex.Status == WebExceptionStatus.ProtocolError)
                {
                    if (((HttpWebResponse)ex.Response).StatusCode == HttpStatusCode.BadRequest ||
                    ((HttpWebResponse)ex.Response).StatusCode == HttpStatusCode.InternalServerError)
                    {
                        // Handle known error
                        using (var stream = ex.Response.GetResponseStream())
                        using (var reader = new StreamReader(stream))
                        {
                            string error = reader.ReadToEnd();
                            known_error_msg_lbl.Text = error;
                            oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.known_error;
                        }
                    }
                    else
                    {
                        // Handle unknown error
                        string error = ex.Status + ".  " + ex.Message + "  " + ex.InnerException;
                        unknown_error_lbl.Text = "WebException Error: " + error;
                        oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.unknown_error;
                    }
                }
            }

        }

        protected void query_collection_myhuman_Click(object sender, EventArgs e)
        {

            // ***********************************************************
            // Query Content API Collection with access token.
            // ***********************************************************       

            ResponseObject token_obj = (ResponseObject)Session["token_obj"];

            if (String.IsNullOrEmpty(token_obj.access_token))
            {
                known_error_msg_lbl.Text = "access_token not specified";
                oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.known_error;
            }
            else
            {
                //string parameters = @"{}";
                //var query_string = Utilities.JsonToQueryString(parameters);
                try
                {
                    var url = content_service_url + "myhuman";
                    HttpWebRequest webRequest = HttpWebRequest.Create(url) as HttpWebRequest;
                    webRequest.Method = WebRequestMethods.Http.Get;
                    // Construct an Authorization header with the value of 'Bearer <access token>'
                    webRequest.Headers.Add("Authorization", "Bearer " + token_obj.access_token);
                    webRequest.Accept = "application/json"; 

                    using (HttpWebResponse response = webRequest.GetResponse() as HttpWebResponse)
                    {
                        string result = "";
                        using (var stream = response.GetResponseStream())
                        using (var reader = new StreamReader(stream))
                        {
                            result = reader.ReadToEnd(); 
                        }    

                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            JToken jt = JToken.Parse(result);
                            string formatted = jt.ToString(Newtonsoft.Json.Formatting.Indented);
                            Debug.WriteLine("Success:");
                            Debug.WriteLine(formatted);
                            success_results_ltl.Text = formatted;
                            oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.success;
                        }
                        else
                        {
                            // Handle unknown error
                            unknown_error_lbl.Text = String.Concat(response.StatusCode, ", ", response.StatusDescription, ", ", result);
                            oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.unknown_error;
                        }

                    }
                }
                catch (WebException ex)
                {
                    if (ex.Status == WebExceptionStatus.ProtocolError)
                    {
                        if (((HttpWebResponse)ex.Response).StatusCode == HttpStatusCode.BadRequest ||
                        ((HttpWebResponse)ex.Response).StatusCode == HttpStatusCode.InternalServerError)
                        {
                            // Handle known error
                            using (var stream = ex.Response.GetResponseStream())
                            using (var reader = new StreamReader(stream))
                            {
                                string error = reader.ReadToEnd();
                                known_error_msg_lbl.Text = error;
                                oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.known_error;
                            }
                        }
                        else
                        {
                            // Handle unknown error
                            string error = ex.Status + ".  " + ex.Message + "  " + ex.InnerException;
                            unknown_error_lbl.Text = "WebException Error: " + error;
                            oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.unknown_error;
                        }
                    }
                }
            }

        }

        protected void start_over_Click(object sender, EventArgs e)
        {
            initialize();
        }

        protected void initialize()
        {
            token_type_ltl.Text = String.Empty;
            access_token_ltl.Text = String.Empty;
            expires_in_ltl.Text = String.Empty;
            timestamp_ltl.Text = String.Empty;
            success_results_ltl.Text = String.Empty;
            known_error_msg_lbl.Text = String.Empty;
            unknown_error_lbl.Text = String.Empty;
            Session.Remove("token_obj");
            oauth_client_mv.ActiveViewIndex = OAUTH_VIEW.request_access_token;
        }
    }
}