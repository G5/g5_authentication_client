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

    # @!attribute [rw] client_callback_url
    #   @return [String] callback url for application

    # @!attribute [rw] authorization_code
    #   @return [String] code provided by authorization server

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
    # @option options [String] :client_callback_url The client callback url for this application.
    # @option options [String] :authorization_code The authentication code from the authorization server.
    def initialize(options={})
      options.each { |k,v| self.send("#{k}=", v) if self.respond_to?("#{k}=") }
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
      response=access_token.post('/v1/users', :params=>{:user=>user.to_hash})
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
      response=access_token.put("/v1/users/#{user.id}", :params=>{:user=>user.to_hash})
      User.new(response.parsed)
    end

    # Get a user
    # @param [Integer] id the user ID in the remote service
    # @return [G5AuthenticationClient::User]
    def get_user(id)
      response=access_token.get("/v1/users/#{id}")
      User.new(response.parsed)
    end

    # Delete a user
    # @param [Integer] id the user ID in the remote service
    # @return [G5AuthenticationClient::User]
    def delete_user(id)
      response=access_token.delete("/v1/users/#{id}")
      User.new(response.parsed)
    end

    private

    def oauth_client
      OAuth2::Client.new(client_id, client_secret, :site => endpoint)
    end

    def access_token
      @access_token ||= if authorization_code
        oauth_client.auth_code.get_token(authorization_code,:redirect_uri=>client_callback_url)
      elsif username && password
        oauth_client.password.get_token(username,password)
      else
        raise "Insufficient credentials for access token.  Supply a username/password or authentication code"
      end
    end

  end
end
