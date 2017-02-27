using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Xml.Linq;

namespace WebApplication1.App_Code
{
    public class Token : System.Web.UI.Page
    {

        public class RequestObject
        {
            private string _grant_type = "";
            private string _scope = "";

            public RequestObject()
            {
            }

            public string grant_type
            {
                get { return _grant_type; }
                set { _grant_type = value; }
            }
            public string scope
            {
                get { return _scope; }
                set { _scope = value; }
            }
        }

        public class ResponseObject
        {

            private string _access_token = "";
            private string _token_type = "";
            private string _expires_in = "";
            private string _timestamp = "";

            private string _error = "";

            public ResponseObject()
            {
            }
            public string access_token
            {
                get { return _access_token; }
                set { _access_token = value; }
            }
            public string token_type
            {
                get { return _token_type; }
                set { _token_type = value; }
            }
            public string expires_in
            {
                get { return _expires_in; }
                set { _expires_in = value; }
            }
            public string timestamp
            {
                get { return _timestamp; }
                set { _timestamp = value; }
            }
            public string error
            {
                get { return _error; }
                set { _error = value; }

            }


        }
    }


    public class Utilities
    {

        public static String JsonToQueryString(string json)
        {
            var jObj = (JObject)JsonConvert.DeserializeObject(json);

            var query = String.Join("&",
                            jObj.Children().Cast<JProperty>()
                            .Select(jp => jp.Name + "=" + HttpUtility.UrlEncode(jp.Value.ToString())));
            return query;
        }
    }

}