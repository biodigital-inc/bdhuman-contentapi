<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Client.aspx.cs" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
                  <h3>Query Content API with Access Token</h3>  
                <asp:LinkButton ID="api_request_collection_myhuman_lb" runat="server" OnClick="query_collection_myhuman_Click">Query Collection: myhuman</asp:LinkButton> 
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
