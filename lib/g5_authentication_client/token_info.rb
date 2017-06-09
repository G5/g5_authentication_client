# frozen_string_literal: true

require 'modelish'

module G5AuthenticationClient
  # G5 Authentication access token info
  class TokenInfo < Modelish::Base
    ignore_unknown_properties!

    # @!attribute [rw] resource_owner_id
    #   @return [String]
    #   The ID of the user that owns the resource
    property :resource_owner_id, type: String

    # @!attribute [rw] scopes
    #   @return [Array]
    #   The OAuth scopes associated with this token
    property :scopes, type: Array, default: []

    # @!attribute [rw] expires_in_seconds
    #   @return [Integer]
    #   The amount of time until the token expires
    property :expires_in_seconds, type: Integer

    # @!attribute [rw] application_uid
    #   @return [String]
    #   The UID of the OAuth application that requested this token
    property :application_uid, from: :application,
                               type: lambda { |val| (val[:uid] || val['uid']).to_s }

    # @!attribute [rw] created_at
    #   @return [Time]
    #   The token creation timestamp
    property :created_at, type: lambda { |val| Time.at(val.to_i) }
  end
end
