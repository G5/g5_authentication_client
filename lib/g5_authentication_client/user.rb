require 'modelish'

module G5AuthenticationClient

  #A G5 Authentication User
  class User < Modelish::Base
    # @!attribute [rw] email
    #   @return [String]
    #   The user's email address.
    property :email, :type => String, :required => true

    # @!attribute [rw] password
    #   @return [String]
    #   The user's password.  Required to create a user.
    property :password, :type => String

    # @!attribute [rw] id
    #   @return [Integer]
    #   The user's id.  Not required to create a user.
    property :id, :type => Integer

    def validate_for_create!
      validate!
      raise ArgumentError.new("Password required for new user.") unless !password.nil?
    end
  end
end
