require 'modelish'

module G5AuthenticationClient
  # G5 Authentication user role info
  class Role < Modelish::Base
    ignore_unknown_properties!

    # @!attribute [rw] name
    #   @return [String]
    #   The name associated with this user role
    property :name, type: String, required: true
  end
end
