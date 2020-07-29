<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Client.aspx.cs" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Content API Example</title>

    <style>
        .prettyprint {
            outline: 1px solid #ccc;
            padding: 5px;
            margin: 20px;
            max-height: 200px;
            line-height: 1.2;
            overflow-y: auto;
            overflow-x: auto;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
    <div>    
        <asp:MultiView ID="oauth_client_mv" runat="server" ActiveViewIndex="0">
            
            <asp:View ID="token_request_view" runat="server" >
                <h3>Private Application Authentication</h3> 
                <br />
                <asp:LinkButton ID="request_access_token_lb" runat="server" OnClick="request_access_token_Click" >Request Access Token</asp:LinkButton>
            </asp:View>

            <asp:View ID="api_request_view" runat="server">                 
                 <asp:LinkButton ID="api_request_start_over_lb" runat="server" OnClick="start_over_Click" >Start Over</asp:LinkButton>
                 <br /><br />
                 <h3>Successfully retrieved access token!</h3>  
                 <br />       
                 access_token : <asp:Literal ID="access_token_ltl" runat="server"></asp:Literal>
                 <br />       
                 token_type : <asp:Literal ID="token_type_ltl" runat="server"></asp:Literal>
                 <br />       
                 token_expiry : <asp:Literal ID="expires_in_ltl" runat="server"></asp:Literal> 
                 <br />       
                 timestamp : <asp:Literal ID="timestamp_ltl" runat="server"></asp:Literal>
                 <br />       
                 <br />       
                <p><asp:LinkButton ID="api_request_collection_myhuman_lb" runat="server" OnClick="query_collection_myhuman_Click">Query Content API /myhuman endpoint with Access Token</asp:LinkButton></p>
                <p><asp:LinkButton ID="api_request_collection_mycollections_lb" runat="server" OnClick="query_collection_mycollections_Click">Query Content API /mycollections endpoint with Access Token</asp:LinkButton></p> 
            </asp:View>

            <asp:View ID="api_myhuman_view" runat="server">                 
                 <asp:LinkButton ID="api_myhuman_start_over_lb" runat="server" OnClick="start_over_Click" >Start Over</asp:LinkButton>
                 <br /><br />
                 <h3>Successful!</h3>  
                 <p>Your <b><asp:Literal ID="api_myhuman_endpoint_path_ltl" runat="server"></asp:Literal></b>:</p>
                 <pre class="prettyprint"><asp:Literal ID="api_myhuman_success_results_ltl" runat="server"></asp:Literal></pre>

                 <br />       
                <p>Other endpoints:</p>
                <div>
                    <ul style="list-style: none;">
                        <li>Return a list of all my team collections:  <asp:LinkButton ID="api_myhuman_collection_mycollections_lb" runat="server" OnClick="query_collection_mycollections_Click">/mycollections</asp:LinkButton></li>
                    </ul>
                </div>
            </asp:View>

            <asp:View ID="api_mycollections_view" runat="server">                 
                 <asp:LinkButton ID="api_mycollections_start_over_lb" runat="server" OnClick="start_over_Click" >Start Over</asp:LinkButton>
                 <br />
                 <h3>Successful!</h3>  
                 <p>Your <b><asp:Literal ID="api_mycollections_endpoint_path_ltl" runat="server"></asp:Literal></b>:</p>
                 <pre class="prettyprint"><asp:Literal ID="api_mycollections_success_results_ltl" runat="server"></asp:Literal></pre>

                <p>Additional team collection endpoints:</p>
                <asp:Repeater ID="api_mycollections_rptr" runat="server">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div>
                            <ul style="list-style: none;">
                                <li>Team Collection:  <b><%# Eval("collection_name") %></b> [id: <%# Eval("collection_id") %>]</li>
                                <li>Return details for this team collection only:  <asp:LinkButton ID="api_mycollections_collection_mycollections_id_lb" runat="server" CommandName="mycollections_id" CommandArgument='<%# Eval("collection_id") %>' OnCommand="query_collection_mycollections_id_Click">/mycollections/<%# Eval("collection_id") %></asp:LinkButton></li>
                                <li>Return a list of all content for this team collection:  <asp:LinkButton ID="api_mycollections_collection_mycollections_id_contentlist_lb" runat="server" CommandName="mycollections_id_contentlist" CommandArgument='<%# Eval("collection_id") %>' OnCommand="query_collection_mycollections_id_contentlist_Click">/mycollections/<%# Eval("collection_id") %>/content_list</asp:LinkButton></li>
                            </ul>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                    </FooterTemplate>
                </asp:Repeater>
                
                <p>Other endpoints:</p>
                <div>
                    <ul style="list-style: none;">
                        <li>Return a list of all my dashboard content:  <asp:LinkButton ID="api_mycollections_collection_myhuman_lb" runat="server" OnClick="query_collection_myhuman_Click">/myhuman</asp:LinkButton></li>
                    </ul>
                </div>
            </asp:View>


            <asp:View ID="api_mycollections_id_view" runat="server">                 
                 <asp:LinkButton ID="api_mycollections_id_start_over_lb" runat="server" OnClick="start_over_Click" >Start Over</asp:LinkButton>
                 <br />
                 <h3>Successful!</h3>  
                 <p>Your <b><asp:Literal ID="api_mycollections_id_endpoint_path_ltl" runat="server"></asp:Literal></b>:</p>
                 <pre class="prettyprint"><asp:Literal ID="api_mycollections_id_success_results_ltl" runat="server"></asp:Literal></pre>

                <p>Additional team collection endpoints:</p>
                <asp:Repeater ID="api_mycollections_id_rptr" runat="server">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div>
                            <ul style="list-style: none;">
                                <li>Return a list of all my team collections:  <asp:LinkButton ID="api_mycollections_id_collection_mycollections_lb" runat="server" OnCommand="query_collection_mycollections_Click">/mycollections</asp:LinkButton></li>
                                <li>Return a list of all content for this team collection:  <asp:LinkButton ID="api_mycollections_id_collection_mycollections_id_contentlist_lb" runat="server" CommandName="mycollections_id_contentlist" CommandArgument='<%# Eval("collection_id") %>' OnCommand="query_collection_mycollections_id_contentlist_Click">/mycollections/<%# Eval("collection_id") %>/content_list</asp:LinkButton></li>
                            </ul>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                    </FooterTemplate>
                </asp:Repeater>
                
                <p>Other endpoints:</p>
                <div>
                    <ul style="list-style: none;">
                        <li>Return a list of all my dashboard content:  <asp:LinkButton ID="LinkButton2" runat="server" OnClick="query_collection_myhuman_Click">/myhuman</asp:LinkButton></li>
                    </ul>
                </div>
            </asp:View>


            <asp:View ID="api_mycollections_id_contentlist_view" runat="server">                 
                 <asp:LinkButton ID="api_mycollections_id_contentlist_start_over_lb" runat="server" OnClick="start_over_Click" >Start Over</asp:LinkButton>
                 <br />
                 <h3>Successful!</h3>  
                 <p>Your <b><asp:Literal ID="api_mycollections_id_contentlist_endpoint_path_ltl" runat="server"></asp:Literal></b>:</p>
                 <pre class="prettyprint"><asp:Literal ID="api_mycollections_id_contentlist_success_results_ltl" runat="server"></asp:Literal></pre>

                <p>Additional team collection endpoints:</p>
                <asp:Repeater ID="api_mycollections_id_contentlist_rptr" runat="server">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div>
                            <ul style="list-style: none;">
                                <li>Return a list of all my team collections:  <asp:LinkButton ID="api_mycollections_id_collection_mycollections_lb" runat="server" OnClick="query_collection_mycollections_Click">/mycollections</asp:LinkButton></li>
                                <li>Return details for this team collection only:  <asp:LinkButton ID="api_mycollections_id_collection_mycollections_id_lb" runat="server" CommandName="mycollections_id" CommandArgument='<%# Eval("collection_id") %>' OnCommand="query_collection_mycollections_id_Click">/mycollections/<%# Eval("collection_id") %></asp:LinkButton></li>
                            </ul>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                    </FooterTemplate>
                </asp:Repeater>
                
                <p>Other endpoints:</p>
                <div>
                    <ul style="list-style: none;">
                        <li>Return a list of all my dashboard content:  <asp:LinkButton ID="LinkButton3" runat="server" OnClick="query_collection_myhuman_Click">/myhuman</asp:LinkButton></li>
                    </ul>
                </div>
            </asp:View>


            <asp:View ID="success_view" runat="server">
               <asp:LinkButton ID="success_start_over_lb" runat="server" OnClick="start_over_Click" >Start Over</asp:LinkButton>
               <br /><br />
               <h3>Success:</h3>        
               <p><asp:Literal ID="success_results_ltl" runat="server"></asp:Literal></p>
            </asp:View>    

             <asp:View ID="known_error_view" runat="server">
                <asp:LinkButton ID="known_error_start_over_lb" runat="server" OnClick="start_over_Click" >Start Over</asp:LinkButton> 
                <br /><br />
                <h3>Known error:</h3>
                <p><asp:Label ID="known_error_msg_lbl" runat="server" Text=""></asp:Label></p>
            </asp:View>

             <asp:View ID="unknown_error_view" runat="server">
                <asp:LinkButton ID="unknown_erro_start_over_lb" runat="server" OnClick="start_over_Click" >Start Over</asp:LinkButton> 
                 <br /><br />
                <h3>Unknown error:</h3>
                <p><asp:Label ID="unknown_error_lbl" runat="server" Text=""></asp:Label></p>
            </asp:View>

        </asp:MultiView>

    </div>
    </form>
</body>
</html>
