# frozen_string_literal: true

require 'modelish'

module G5AuthenticationClient
  # G5 Authentication user role info
  class Role < Modelish::Base
    ignore_unknown_properties!

    GLOBAL = 'GLOBAL'

    # @!attribute [rw] name
    #   @return [String]
    #   The name associated with this user role
    property :name, type: String, required: true

    # @!attribute [rw] type
    #   @return [String]
    #   The role's type. If 'GLOBAL' then not role not associated with a resource
    property :type, type: String, required: true

    # @!attribute [rw] urn
    #   @return [String]
    #   The role's resource urn. Will be nil if type='GLOBAL'
    property :urn, type: String

    def validate_for_create!
      validate!
      raise ArgumentError.new("URN required when type != '#{GLOBAL}'") if urn.nil? && type != GLOBAL
    end
  end
end
