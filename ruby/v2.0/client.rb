=begin
 ///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 // BioDigital Content API OAuth using Ruby 2.3
 //
 // Author: BioDigital Inc.
 // Email: developers@biodigital.com
 //
 // This example uses the WEBrick and Net/Http libraries for Ruby 2.3
 // found here:  http://ruby-doc.org/stdlib-1.9.3/libdoc/webrick/rdoc/WEBrick.html
 //
 // For more information about the OAuth process for web applications
 // accessing BioDigital APIs, please visit:
 // https://developer.biodigital.com
 //
 //////////////////////////////////////////////////////////////////////
=end

require "webrick"
require 'optparse'
require "net/http"
require 'net/https'
require 'openssl'
require "base64"
require 'json'
require 'date'
require 'erb'

require_relative 'view'

$options = { 
	:port => 5000, 
	:host => '127.0.0.1', 
	:sslverify => true,
	:root => '.' }

OptionParser.new do |opts|
  # banner and separator are the usage description showed with '--help' or '-h'
  opts.on('-h', '--help', 'Help') { usage() }
  opts.on("-p", "--port PORT", "Port") do |port|
    $options[:port] = port
  end
  opts.on("-h", "--host HOST", "Host") do |host|
    $options[:host] = host
  end
  opts.on("-s", "--sslverify SSLVERIFY", "Sslverify") do |sslverify|
    $options[:sslverify] = sslverify
  end
end.parse!


# // BioDigital OAuth endpoint for requesting an access token
$OAUTH_TOKEN_URL = 'https://apis.biodigital.com/oauth2/v2/token/'

# // BioDigital Content API endpoint for collection requests
$CONTENTAPI_COLLECTIONS_URL = 'https://apis.biodigital.com/services/v2/content/collections/'

# // Your API / Developer key you received when you registered your
# // application at https://developer.biodigital.com
$CLIENT_ID = '<DEVELOPER_KEY>'

# // Your API / Developer secret you received when you registered your
# // application at https://developer.biodigital.com
$CLIENT_SECRET = '<DEVELOPER_SECRET>'

# // The type of authorization being requested
$GRANT_TYPE = 'client_credentials'

# // The service scope in which your authorization will be used
$SCOPE = 'contentapi'


class MyOAuthHandler
    def self.index ()
	    html = ""
		html.concat('<h3>Private Application Authentication</h3>')         
		html.concat('<p>')
		html.concat('<a href="/request-access-token">Request Access Token</a>')
		html.concat('</p>')
		return 200, html
    end

    def self.request_access_token ()
		# ***********************************************************
		# Exchange basic client credentials for an access token
		# ***********************************************************

		html = ""
		status = 200

		# Construct authentication string:
		#   1. Concatenate the client id, a colon character ":", and the client secret into a single string
		#   2. URL encode the string from step 1
		#   3. Base64 encode the string from step 2
		$authstr = "%s:%s" % [$CLIENT_ID, $CLIENT_SECRET]
		$authstr = $authstr.encode("utf-8")
		$authstr = Base64.strict_encode64($authstr)

		# For Private application authentication, you must specifiy
		# grant_type=client_credentials and the service scope.  For the 
		# Content API, scope=contentapi
		post_body = {
			'grant_type' => $GRANT_TYPE, 
			'scope' => $SCOPE
		}.to_json

		url = URI.parse($OAUTH_TOKEN_URL)
		req = Net::HTTP::Post.new(url.path)

		#  Construct an Authorization header with the value of 'Basic <base64 encoded auth string>'
		req['Authorization'] = "Basic #{$authstr}" 
		req['Content-Type'] = "application/json;charset=UTF-8"
		req['Accept'] = "application/json"
		req.body  = post_body

		sock = Net::HTTP.new(url.host, url.port)
		if $options[:sslverify] == true or $options[:sslverify] == "true"
			sock.use_ssl = true  
		else 
			sock.use_ssl = false  		
		end
		sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res = sock.start {|http| http.request(req) }		

		case res

			# status codes 400, 500
			when Net::HTTPBadRequest, Net::HTTPInternalServerError

				# Handle known error				
				json = JSON.parse(res.body)
				json_print = JSON.pretty_generate(json)

				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Known Error:</h3>")
				html.concat("<pre>")
				html.concat(json_print)

			# status code 200
			when Net::HTTPSuccess

				result_obj = JSON.parse(res.body)
				token_expiry = DateTime.strptime(result_obj['timestamp'], '%Y-%m-%dT%H:%M:%S')
				token_expiry = token_expiry + Rational(result_obj['expires_in'], 86400)
				
				# create and render the view
				data = {
					access_token: result_obj['access_token'],
					token_type: result_obj['token_type'], 
					expires_in: result_obj['expires_in'], 
					token_expiry: token_expiry.to_s, 
					timestamp: result_obj['timestamp'] 
				}

				view = View.new("access-token", data)
				html << view.render
			else
				# Handle unknown error
				status = res.code
				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Unknown Error:</h3>")
				html.concat("<pre>")
				html.concat("#{status}")
				html.concat("<pre>")
				html.concat("#{res.message}")
				html.concat("<pre>")
				html.concat("#{res.body}")
		end
		return status, html

    end
    
    def self.query_collection_myhuman (access_token)

    # ***********************************************************
    #  Query Content API Collection with access token.
    # ***********************************************************       

        html = ""
		status = 200

		uri = URI.parse($CONTENTAPI_COLLECTIONS_URL + "myhuman")
		req = Net::HTTP::Get.new(uri)
		puts "uri: #{uri}"
		# Construct an Authorization header with the value of 'Bearer <access token>'
		req['Authorization'] = "Bearer #{access_token}" 
		req['Accept'] = "application/json"

		sock = Net::HTTP.new(uri.host, uri.port)
		if $options[:sslverify] == true or $options[:sslverify] == "true"
			sock.use_ssl = true  
		else 
			sock.use_ssl = false  		
		end
		sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res = sock.start {|http| http.request(req) }
		results_obj = JSON.parse(res.body)

		case res
			# status codes 400, 500
			when Net::HTTPBadRequest, Net::HTTPInternalServerError

				# handle known error
				json = JSON.parse(res.body)
				json_print = JSON.pretty_generate(json)

				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Success:</h3>")
				html.concat("<pre>")
				html.concat(json_print)

			# status code 200
			when Net::HTTPSuccess

				json = JSON.parse(res.body)
				json_print = JSON.pretty_generate(json)

				puts json_print

				# create and render the view
				data = {
					access_token: access_token,
					endpoint_path: '/myhuman', 
					results: json_print, 
					results_obj: json 
				}

				view = View.new("myhuman", data)
				html << view.render

			else
				# Handle unknown error
				status = res.code
				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Unknown Error:</h3>")
				html.concat("<pre>")
				html.concat("#{status}")
				html.concat("<pre>")
				html.concat("#{res.message}")
				html.concat("<pre>")
				html.concat("#{res.body}")
		end

		return status, html
    end

    def self.query_collection_mycollections (access_token)

    # ***********************************************************
    #  Query Content API Collection with access token.
    # ***********************************************************       

        html = ""
		status = 200

		uri = URI.parse($CONTENTAPI_COLLECTIONS_URL + "mycollections")
		req = Net::HTTP::Get.new(uri)
		puts "uri: #{uri}"
		# Construct an Authorization header with the value of 'Bearer <access token>'
		req['Authorization'] = "Bearer #{access_token}" 
		req['Accept'] = "application/json"

		sock = Net::HTTP.new(uri.host, uri.port)
		if $options[:sslverify] == true or $options[:sslverify] == "true"
			sock.use_ssl = true  
		else 
			sock.use_ssl = false  		
		end
		sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res = sock.start {|http| http.request(req) }
		results_obj = JSON.parse(res.body)

		case res
			# status codes 400, 500
			when Net::HTTPBadRequest, Net::HTTPInternalServerError

				# handle known error
				json = JSON.parse(res.body)
				json_print = JSON.pretty_generate(json)

				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Success:</h3>")
				html.concat("<pre>")
				html.concat(json_print)

			# status code 200
			when Net::HTTPSuccess

				json = JSON.parse(res.body)
				json_print = JSON.pretty_generate(json)

				puts json_print

				# create and render the view
				data = {
					access_token: access_token,
					endpoint_path: '/mycollections', 
					results: json_print, 
					results_obj: json 
				}

				view = View.new("mycollections", data)
				html << view.render

			else
				# Handle unknown error
				status = res.code
				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Unknown Error:</h3>")
				html.concat("<pre>")
				html.concat("#{status}")
				html.concat("<pre>")
				html.concat("#{res.message}")
				html.concat("<pre>")
				html.concat("#{res.body}")
		end

		return status, html
    end


    def self.query_collection_mycollections_id (access_token, collection_id)

    # ***********************************************************
    #  Query Content API Collection with access token.
    # ***********************************************************       

        html = ""
		status = 200

		uri = URI.parse($CONTENTAPI_COLLECTIONS_URL + "mycollections/#{collection_id}")
		req = Net::HTTP::Get.new(uri)
		puts "uri: #{uri}"
		# Construct an Authorization header with the value of 'Bearer <access token>'
		req['Authorization'] = "Bearer #{access_token}" 
		req['Accept'] = "application/json"

		sock = Net::HTTP.new(uri.host, uri.port)
		if $options[:sslverify] == true or $options[:sslverify] == "true"
			sock.use_ssl = true  
		else 
			sock.use_ssl = false  		
		end
		sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res = sock.start {|http| http.request(req) }
		results_obj = JSON.parse(res.body)

		case res
			# status codes 400, 500
			when Net::HTTPBadRequest, Net::HTTPInternalServerError

				# handle known error
				json = JSON.parse(res.body)
				json_print = JSON.pretty_generate(json)

				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Success:</h3>")
				html.concat("<pre>")
				html.concat(json_print)

			# status code 200
			when Net::HTTPSuccess

				json = JSON.parse(res.body)
				json_print = JSON.pretty_generate(json)

				puts json_print

				# create and render the view
				data = {
					access_token: access_token,
					endpoint_path: "/mycollections/#{collection_id}", 
					results: json_print, 
					results_obj: json 
				}

				view = View.new("mycollections-id", data)
				html << view.render

			else
				# Handle unknown error
				status = res.code
				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Unknown Error:</h3>")
				html.concat("<pre>")
				html.concat("#{status}")
				html.concat("<pre>")
				html.concat("#{res.message}")
				html.concat("<pre>")
				html.concat("#{res.body}")
		end

		return status, html
    end

    def self.query_collection_mycollections_id_contentlist (access_token, collection_id)

    # ***********************************************************
    #  Query Content API Collection with access token.
    # ***********************************************************       

        html = ""
		status = 200

		uri = URI.parse($CONTENTAPI_COLLECTIONS_URL + "mycollections/#{collection_id}/content_list")
		req = Net::HTTP::Get.new(uri)
		puts "uri: #{uri}"
		# Construct an Authorization header with the value of 'Bearer <access token>'
		req['Authorization'] = "Bearer #{access_token}" 
		req['Accept'] = "application/json"

		sock = Net::HTTP.new(uri.host, uri.port)
		if $options[:sslverify] == true or $options[:sslverify] == "true"
			sock.use_ssl = true  
		else 
			sock.use_ssl = false  		
		end
		sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res = sock.start {|http| http.request(req) }
		results_obj = JSON.parse(res.body)

		case res
			# status codes 400, 500
			when Net::HTTPBadRequest, Net::HTTPInternalServerError

				# handle known error
				json = JSON.parse(res.body)
				json_print = JSON.pretty_generate(json)

				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Success:</h3>")
				html.concat("<pre>")
				html.concat(json_print)

			# status code 200
			when Net::HTTPSuccess

				json = JSON.parse(res.body)
				json_print = JSON.pretty_generate(json)

				puts json_print

				# create and render the view
				data = {
					access_token: access_token,
					collection_id: collection_id,
					endpoint_path: "/mycollections/#{collection_id}/content_list", 
					results: json_print, 
					results_obj: json 
				}

				view = View.new("mycollections-id-content_list", data)
				html << view.render

			else
				# Handle unknown error
				status = res.code
				html.concat("<pre>")
				html.concat('<p><a href="/">Start Over</a></p></body>')
				html.concat("<pre>")
				html.concat("<h3>Unknown Error:</h3>")
				html.concat("<pre>")
				html.concat("#{status}")
				html.concat("<pre>")
				html.concat("#{res.message}")
				html.concat("<pre>")
				html.concat("#{res.body}")
		end

		return status, html
    end
end

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET (request, response)

        response.status = 200
        response.content_type = "text/html"
        result = nil
          
        case request.path

			when "/"
				response.status, result = MyOAuthHandler.index() 
            when "/request-access-token"
                response.status, result = MyOAuthHandler.request_access_token()
            when "/query-collection-myhuman"
				if request.query["access_token"]
					access_token = request.query["access_token"]
					response.status, result = MyOAuthHandler.query_collection_myhuman(access_token)
				else
					response.status = 400
					result = "You did not provide the access_token parameter"
				end
            when "/query-collection-mycollections"
				if request.query["access_token"]
					access_token = request.query["access_token"]
					response.status, result = MyOAuthHandler.query_collection_mycollections(access_token)
				else
					response.status = 400
					result = "You did not provide the access_token parameter"
				end
            when "/query-collection-mycollections-id"
				if request.query["access_token"] && request.query["collection_id"] 
					access_token = request.query["access_token"]
					collection_id = request.query["collection_id"]
					response.status, result = MyOAuthHandler.query_collection_mycollections_id(access_token, collection_id)
				else
					response.status = 400
					result = "You did not provide both the access_token and collection_id parameters"
				end
            when "/query-collection-mycollections-id-contentlist"
				if request.query["access_token"] && request.query["collection_id"] 
					access_token = request.query["access_token"]
					collection_id = request.query["collection_id"]
					response.status, result = MyOAuthHandler.query_collection_mycollections_id_contentlist(access_token, collection_id)
				else
					response.status = 400
					result = "You did not provide both the access_token and collection_id parameters"
				end
            else
				response.status = 401
                result = "No such method"
        end       

        response.body = result.to_s + "\n"
    end
end

server = WEBrick::HTTPServer.new(:Port => $options[:port], :Host => $options[:host], :DocumentRoot => $options[:root])

server.mount "/", MyServlet

trap("INT") {
    server.shutdown
}

server.start

