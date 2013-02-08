require 'configlet'
require 'logger'

module G5AuthenticationClient
  # All valid configurations options
  VALID_CONFIG_OPTIONS = [:debug, :logger]

  module Configuration
    include Configlet
 
    def self.extended(base)
      # Default configuration - happens whether or not .configure is called
      base.config :g5_authentication_client do

        default :debug => 'false'
        # TODO - set default values here, for example:
        # default :my_opt => 'default value'
      end
    end

    # Mutators and accessors for configuration options
    VALID_CONFIG_OPTIONS.each do |config_opt|
      define_method(config_opt) do
        self[config_opt]
      end

      define_method("#{config_opt}=".to_sym) do |val|
        self[config_opt] = val.nil? ? nil : val.to_s
      end
    end


    # @attr [true,false,String] debug set to true or 'true' to enable debug logging (defaults to false)
    # TODO: document additional configuration attributes if necessary

    # @return [true,false] true if debug logging is enabled; false otherwie.
    def debug?
      self[:debug] == 'true'
    end

    # Sets the logger to use for debug messages
    attr_writer :logger

    # @return [Logger] the logger to use for debug messages (defaults to STDOUT)
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    # Configures this module through the given +block+.
    # Default configuration options will be applied unless 
    # they are explicitly overridden in the +block+.
    #
    # @yield [_self] configures service connection options
    # @yieldparam [G5AuthenticationClient] _self the object on which the configure method was called
    # @example Typical case utilizing defaults
    #   G5AuthenticationClient.configure do |config|
    #     config.username = 'my_user'
    #     config.password = 'my_pass'
    #   end
    # @example Overriding defaults
    #   G5AuthenticationClient.configure do |config|
    #     config.username = 'my_user'
    #     config.password = 'my_pass'
    #     config.endpoint = 'http://my.endpoint.com'
    #   end
    # @return [G5AuthenticationClient] _self
    # @see VALID_CONFIG_OPTIONS
    def configure
      config :g5_authentication_client do
        yield self
      end

      self
    end

    # Create a hash of configuration options and their
    # values.
    #
    # @return [Hash<Symbol,Object>] the options hash
    def options
      VALID_CONFIG_OPTIONS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Resets this module's configuration.
    # Configuration options will be set to default values
    # if they exist; otherwise, they will be set to nil.
    #
    # @see VALID_CONFIG_OPTIONS

    def reset
      VALID_CONFIG_OPTIONS.each { |opt| self.send("#{opt}=", nil) } 
    end
  end
end
