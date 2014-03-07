require 'spec_helper'

# Requires the following to be defined in the surrounding context
# access_token_value
# token_type
# client_id
# client_secret
# authorization_code
# redirect_uri
# username
# password
shared_examples_for 'an oauth protected resource' do |resource_type|
  let(:oauth_access_token) do
    {
      'access_token' => access_token_value,
      'token_type' => token_type,
      'expires_in' => 7200,
      'refresh_token' => 'refresh_token'
    }
  end

  context 'when there is an access token' do
    let(:authorization_code) { nil }
    let(:username) { nil }
    let(:password) { nil }

    it { should be_an_instance_of resource_type }
  end

  context 'when there is an authorization code' do
    let(:access_token) { nil }
    let(:username) { nil }
    let(:password) { nil }

    let(:token_request_by_auth_code) do
      {
        'client_id' => client_id,
        'client_secret' => client_secret,
        'code' => authorization_code,
        'grant_type' => 'authorization_code',
        'redirect_uri' => redirect_uri
      }
    end

    before do
      stub_request(:post, "#{endpoint}/oauth/token").
        with(body: token_request_by_auth_code).
        to_return(status: 200,
                  body: oauth_access_token.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it { should be_an_instance_of resource_type }
  end

  context 'when there is a username and password' do
    let(:access_token) { nil }
    let(:authorization_code) { nil }
    let(:allow_password_credentials) {'true'}

    let(:token_request_by_password) do
      {
        'client_id' => client_id,
        'client_secret' => client_secret,
        'grant_type' => 'password',
        'username' => username,
        'password' => password
      }
    end

    before do
      stub_request(:post, "#{endpoint}/oauth/token").
        with(body: token_request_by_password).
        to_return(status: 200,
                  body: oauth_access_token.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it { should be_an_instance_of resource_type }
  end
end
