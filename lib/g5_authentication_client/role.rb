require 'modelish'

module G5AuthenticationClient
  # G5 Authentication user role info
  class Role < Modelish::Base
    ignore_unknown_properties!

    # @!attribute [rw] id
    #   @return [Integer]
    #   The ID of the user role
    property :id, type: Integer, required: true

    # @!attribute [rw] name
    #   @return [String]
    #   The name associated with this user role
    property :name, type: String, required: true
  end
end
