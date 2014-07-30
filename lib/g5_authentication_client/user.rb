require 'modelish'

module G5AuthenticationClient

  #A G5 Authentication User
  class User < Modelish::Base
    ignore_unknown_properties!
    # @!attribute [rw] email
    #   @return [String]
    #   The user's email address.
    property :email, type: String, required: true

    # @!attribute [rw] password
    #   @return [String]
    #   The user's password.  Required to create a user.
    property :password, type: String

    # @!attribute [rw] password_confirmation
    #   @return [String]
    #   The user's password_confirmation.
    property :password_confirmation, type: String

    # @!attribute [rw] id
    #   @return [Integer]
    #   The user's id.  Not required to create a user.
    property :id, type: Integer

    # @!attribute [rw] first_name
    #   @return [String]
    #   The user's first name.  Not required to create a user.
    property :first_name, type: String

    # @!attribute [rw] last_name
    #   @return [String]
    #   The user's last name.  Not required to create a user.
    property :last_name, type: String

    # @!attribute [rw] title
    #   @return [String]
    #   The user's title.  Not required to create a user.
    property :title, type: String

    # @!attribute [rw] organization_name
    #   @return [String]
    #   The user's organization name.  Not required to create a user.
    property :organization_name, type: String

    # @!attribute [rw] phone_number
    #   @return [String]
    #   The user's phone number.  Not required to create a user.
    property :phone_number, type: String

    def validate_for_create!
      validate!
      raise ArgumentError.new("Password required for new user.") unless !password.nil?
    end

  end
end
