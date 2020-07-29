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

    public class MyCollections : System.Web.UI.Page
    {

        public class ResponseObject
        {
            public string service_version { get; set; }
            public List<Collection> mycollections { get; set; }
        }

        public class Collection
        {           
            public string team_id { get; set; }
            public string team_name { get; set; }
            public string collection_id { get; set; }
            public string collection_accessibility { get; set; }
            public string collection_name { get; set; }
            public string collection_description { get; set; }
            public string collection_created_date { get; set; }
            public string collection_updated_date { get; set; } 
        }

    }

    public class MyCollections_Content : System.Web.UI.Page
    {

        public class ResponseObject
        {
            public string service_version { get; set; }
            public List<Content> content_list { get; set; }
        }

        public class Content
        {
            public string collection_id { get; set; }
            public string collection_created_date { get; set; }
            public string content_id { get; set; }
            public string content_type { get; set; }
            public string [] content_accessibility { get; set; }
            public string content_title { get; set; }
            public string content_url { get; set; }
            public string content_thumbnail_url { get; set; }
            public List<Team> content_teams { get; set; }
            public string content_gender { get; set; }
            public string content_authored_date { get; set; }
        }

        public class Team
        {
            public string team_id { get; set; }
            public string team_name { get; set; }
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