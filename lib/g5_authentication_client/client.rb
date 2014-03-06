require 'addressable/uri'

module G5AuthenticationClient
  # G5AuthenticationClient::Client can be used to authenticate with the G5 OAuth 2
  # authorization server.  It can also be used to create G5 users.
  class Client
    # Mutators for configuration options
    attr_writer *G5AuthenticationClient::VALID_CONFIG_OPTIONS
    # Accessors for configuration options
    G5AuthenticationClient::VALID_CONFIG_OPTIONS.each do |opt|
      define_method(opt) { get_value(opt) }
    end

    # @!attribute [rw] endpoint
    #   @return [String] the g5-authentication service endpoint URL

    # @!attribute [rw] username
    #   @return [String] the username for authentication

    # @!attribute [rw] password
    #   @return [String] the password for authentication

    # @!attribute [rw] debug
    #   @return [String] 'true' if debug logging is enabled

    # @!attribute [rw] logger
    #   @return [Logger] custom logger instance

    # @!attribute [rw] client_id
    #   @return [String] client id for this application

    # @!attribute [rw] client_secret
    #   @return [String] client secret for this application

    # @!attribute [rw] redirect_uri
    #   @return [String] callback url for application

    # @!attribute [rw] authorization_code
    #   @return [String] code provided by authorization server

    # @!attribute [rw] access_token
    #   @return [String] access token value provided by authorization server

    def debug?
      self.debug.to_s == 'true'
    end

    # Initializes the client.
    #
    # @param [Hash] options
    # @option options [true,false] :debug true enabled debug logging (defaults to false)
    # @option options [Logger] :logger a custom logger instance (defaults to STDOUT)
    # @option options [String] :username The username for authenticating
    # @option options [String] :password The password for authenticating
    # @option options [String] :endpoint The authentication endpoint
    # @option options [String] :client_id The client id for this application
    # @option options [String] :client_secret The client secret for this application
    # @option options [String] :redirect_uri The client callback url for this application.
    # @option options [String] :authorization_code The authentication code from the authorization server.
    def initialize(options={})
      options.each { |k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=") }
    end

    # Retrieves the access token as a string
    # @return [String] the access token value
    def get_access_token
      oauth_access_token.token
    end

    # Retrieves an attribute's value. If the attribute has not been set
    # on this object, it is retrieved from the global configuration.
    #
    # @see G5AuthenticationClient.configure
    # 
    # @param [Symbol] attribute the name of the attribute
    # @return [String] the value of the attribute
    def get_value(attribute)
      instance_variable_get("@#{attribute}") || G5AuthenticationClient.send(attribute)
    end

    # Create a user from the options
    # @param [Hash] options
    # #option options [String] :username The new user's username.
    # #option options [String] :password The new user's password.
    # @return [G5AuthenticationClient::User]
    def create_user(options={})
      user=User.new(options)
      user.validate_for_create!
      response=oauth_access_token.post('/v1/users', params: {user: user.to_hash})
      User.new(response.parsed)
    end

    # Update an existing user
    # @param [Hash] options
    # #option options [String] :username The user's username.
    # #option options [String] :password The user's password.
    # @return [G5AuthenticationClient::User]
    def update_user(options={})
      user=User.new(options)
      user.validate!
      response=oauth_access_token.put("/v1/users/#{user.id}", params: {user: user.to_hash})
      User.new(response.parsed)
    end

    # Get a user
    # @param [Integer] id the user ID in the remote service
    # @return [G5AuthenticationClient::User]
    def get_user(id)
      response=oauth_access_token.get("/v1/users/#{id}")
      User.new(response.parsed)
    end

    # Delete a user
    # @param [Integer] id the user ID in the remote service
    # @return [G5AuthenticationClient::User]
    def delete_user(id)
      response=oauth_access_token.delete("/v1/users/#{id}")
      User.new(response.parsed)
    end

    # Get the current user based on configured credentials
    # @return [G5AuthenticationClient::User]
    def me
      response = oauth_access_token.get('/v1/me')
      User.new(response.parsed)
    end

    # Get the access token info for the currently active token
    # @return [G5AuthenticationClient::TokenInfo]
    def token_info
      response = oauth_access_token.get('/oauth/token/info')
      TokenInfo.new(response.parsed)
    end

    # Return the URL for signing out of the auth server.
    # Clients should redirect to this URL to globally sign out.
    #
    # @param [String] redirect_url the URL that the auth server should redirect back to after sign out
    # @return [String] the auth server endpoint for signing out
    def sign_out_url(redirect_url=nil)
      auth_server_url = Addressable::URI.parse(endpoint)
      auth_server_url.path = '/users/sign_out'
      auth_server_url.query_values = {redirect_url: redirect_url} if redirect_url
      auth_server_url.to_s
    end

    private
    def oauth_client
      OAuth2::Client.new(client_id, client_secret, site: endpoint)
    end

    def oauth_access_token
      @oauth_access_token ||= if access_token
        OAuth2::AccessToken.new(oauth_client, access_token)
      elsif authorization_code
        oauth_client.auth_code.get_token(authorization_code, redirect_uri: redirect_uri)
      elsif username && password
        oauth_client.password.get_token(username,password)
      else
        raise "Insufficient credentials for access token.  Supply a username/password or authentication code"
      end
    end
  end
end
