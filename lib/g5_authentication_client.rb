# frozen_string_literal: true

require 'oauth2'
require 'g5_authentication_client/version'
require 'g5_authentication_client/configuration'
require 'g5_authentication_client/user'
require 'g5_authentication_client/token_info'
require 'g5_authentication_client/role'
require 'g5_authentication_client/auth_token_helper'
require 'g5_authentication_client/error'

module G5AuthenticationClient
  extend Configuration

  require 'g5_authentication_client/client'
end
