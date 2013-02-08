

module G5AuthenticationClient
  # TODO: document G5AuthenticationClient::Client
  class Client
    # Mutators for configuration options
    attr_writer *G5AuthenticationClient::VALID_CONFIG_OPTIONS

    # Accessors for configuration options
    G5AuthenticationClient::VALID_CONFIG_OPTIONS.each do |opt|
      define_method(opt) { get_value(opt) }
    end


    # @attr [true,false,String] debug set to true or 'true' to enable debug logging (defaults to false)
    # @attr [Logger] logger the custom logger instance for debug logging (defaults to STDOUT)
    # TODO: document any other configuration attributes

    def debug?
      self.debug.to_s == 'true'
    end

    # Initializes the client.
    #
    # @param [Hash] options
    # @option options [true,false] :debug true enabled debug logging (defaults to false)
    # @option options [Logger] :logger a custom logger instance (defaults to STDOUT)
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
