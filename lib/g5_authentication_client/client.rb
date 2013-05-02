

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
    #   @return [String] the RENTCafe service endpoint URL

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
    # TODO: document any other config options
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

  end
end
