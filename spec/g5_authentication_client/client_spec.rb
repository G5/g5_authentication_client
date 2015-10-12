require 'spec_helper'
require 'json'

describe G5AuthenticationClient::Client do
  subject(:client) { G5AuthenticationClient::Client.new(options) }

  after { G5AuthenticationClient.reset }

  let(:debug) { true }
  let(:logger) { double() }
  let(:username) {'username'}
  let(:password) {'password'}
  let(:client_id) {'client id'}
  let(:client_secret) {'client secret'}
  let(:redirect_uri) {'/stuff'}
  let(:endpoint){ 'http://endpoint.com' }
  let(:authorization_code){ 'code' }
  let(:allow_password_credentials){ 'false' }

  let(:options) do
    {
     debug: debug,
     logger: logger,
     endpoint: endpoint,
     username: username,
     password: password,
     client_id: client_id,
     client_secret: client_secret,
     redirect_uri: redirect_uri,
     authorization_code: authorization_code,
     access_token: access_token,
     allow_password_credentials: allow_password_credentials
    }
  end

  let(:access_token) { access_token_value }
  let(:access_token_value) { 'test_token' }
  let(:token_type) { 'Bearer' }

  let(:auth_header_value) { "#{token_type} #{access_token_value}" }

  let(:new_user_options) do
    {email: email,
     password: new_password,
     password_confirmation: new_password,
     id: user_id,
     first_name: first_name,
     last_name: last_name,
     organization_name: organization_name,
     phone_number: phone_number,
     title: title,
     roles: [{name: role_name, urn: role_urn, type: role_type}]}
  end

  let(:new_user_request) do
    {
      'email' => email,
      'first_name' => first_name,
      'last_name'=> last_name,
      'organization_name' => organization_name,
      'password' => new_password,
      'password_confirmation' => new_password,
      'phone_number' => phone_number,
      'title' => title,
      'roles' => [{'name' => role_name, 'urn'=> role_urn, 'type' => role_type}]
    }
  end

  let(:email) { 'foo@blah.com' }
  let(:password) { 'mybigtestpasswored' }
  let(:new_password) { "#{password}x" }
  let(:user_id) { 1 }
  let(:first_name) { 'Fred' }
  let(:last_name) { 'Rogers' }
  let(:organization_name) { 'The Neighborhood' }
  let(:phone_number) { '(555) 555-5555' }
  let(:title) { 'Neighbor' }
  let(:role_name) { 'my_role_1' }
  let(:role_type) { 'G5Updatable::Client1' }
  let(:role_urn) { 'someurn1' }
  let(:returned_user){{id: user_id,email: email,roles:[returned_role]}}
  let(:returned_role) { {'name' => role_name, 'type' => role_type, 'urn' => role_urn} }

  context 'with default configuration' do
    subject(:client) { G5AuthenticationClient::Client.new }

    it 'should not be debug' do
      expect(client.debug?).to_not be true
    end

    it 'should have a logger' do
      expect(client.logger).to be_an_instance_of(Logger)
    end

    it 'should not have a user name' do
      expect(client.username).to be_nil
    end

    it 'should not have a password' do
      expect(client.password).to be_nil
    end

    it 'should have default client id' do
      expect(client.client_id).to eq(G5AuthenticationClient::DEFAULT_CLIENT_ID)
    end

    it 'should have default client secret' do
      expect(client.client_secret).to eq(G5AuthenticationClient::DEFAULT_CLIENT_SECRET)
    end

    it 'should have default redirect uri' do
      expect(client.redirect_uri).to eq(G5AuthenticationClient::DEFAULT_REDIRECT_URI)
    end

    it 'should have default endpoint' do
      expect(client.endpoint).to eq(G5AuthenticationClient::DEFAULT_ENDPOINT)
    end

    it 'should have nil authorization code' do
      expect(client.authorization_code).to be_nil
    end

    it 'should have nil access token' do
      expect(client.access_token).to be_nil
    end

    it 'should have default allow_password_credentials' do
      expect(client.allow_password_credentials).to eq('true')
    end

    it 'username_pw_access_token raises error when password credentials not enabled' do
      expect { client.username_pw_access_token }.to raise_error('allow_password_credentials must be enabled for username/pw access')
    end
  end

  context 'with non-default configuration' do

    it 'should have debug' do
      expect(client.debug).to be true
    end

    describe '#debug=' do
      subject { client.debug = new_debug }

      context 'with nil debug' do
        let(:new_debug) { nil }

        context 'when there is a debug flag configured at the top-level module' do
          let(:configured_debug) { 'true' }
          before { G5AuthenticationClient.configure { |config| config.debug = configured_debug } }

          it 'should set the debug flag according to the configuration' do
            expect { subject }.to_not change { client.debug? }
          end
        end

        context 'when there is no debug flag configured at the top level' do
          it 'should set the debug flag to the default' do
            expect { subject }.to change { client.debug? }.to(false)
          end
        end
      end

      context 'with new setting' do
        let(:new_debug) { 'false' }

        it 'should change the value of the debug flag to match the new value' do
          expect { subject }.to change { client.debug? }.from(true).to(false)
        end
      end
    end

    describe '#logger=' do
      subject { client.logger = new_logger }

       context 'with nil logger' do
        let(:new_logger) { nil }

        context 'when there is a logger configured at the top-level module' do
          let(:configured_logger) { double() }
          before { G5AuthenticationClient.configure { |config| config.logger = configured_logger } }

          it 'should change the value of the logger to match the configuration' do
            expect { subject }.to change { client.logger }.from(logger).to(configured_logger)
          end
        end

        context 'when there is no logger configured at the top level' do
          it 'should change the value of the logger to the default' do
            expect { subject }.to change { client.logger }
            expect(client.logger).to be_an_instance_of(Logger)
          end
        end
      end

      context 'with new logger' do
        let(:new_logger) { double() }

        it 'should change the value of the logger to match the new value' do
          expect { subject }.to change { client.logger }.from(logger).to(new_logger)
        end
      end
    end

    it 'should have username' do
      expect(client.username).to eq(username)
    end

    it_should_behave_like 'a module configured attribute',:username, nil

    it 'should have password' do
      expect(client.password).to eq(password)
    end

    it_should_behave_like 'a module configured attribute', :password, nil

    it 'should have endpoint' do
      expect(client.endpoint).to eq(endpoint)
    end

    it_should_behave_like 'a module configured attribute', :endpoint,G5AuthenticationClient::DEFAULT_ENDPOINT

    it 'should have client_id' do
      expect(client.client_id).to eq(client_id)
    end

    it_should_behave_like 'a module configured attribute', :client_id, G5AuthenticationClient::DEFAULT_CLIENT_ID

    it 'should have client_secret' do
      expect(client.client_secret).to eq(client_secret)
    end

    it_should_behave_like 'a module configured attribute', :client_secret, G5AuthenticationClient::DEFAULT_CLIENT_SECRET

    it 'should have redirect_uri' do
      expect(client.redirect_uri).to eq(redirect_uri)
    end

    it_should_behave_like 'a module configured attribute', :redirect_uri, G5AuthenticationClient::DEFAULT_REDIRECT_URI

    it 'should have authorization_code' do
      expect(client.authorization_code).to eq(authorization_code)
    end

    it_should_behave_like 'a module configured attribute', :authorization_code, nil

    it 'should have access_token' do
      expect(client.access_token).to eq(access_token)
    end

    it_should_behave_like 'a module configured attribute', :access_token, nil

    it 'should have allow_password_credentials' do
      expect(client.allow_password_credentials).to eq(allow_password_credentials)
    end

    it_should_behave_like 'a module configured attribute', :allow_password_credentials, 'true'
  end

  describe '#allow_password_credentials??' do
    subject{ client.allow_password_credentials? }

    context 'when the allow_password_credentials is set to true' do
      let(:allow_password_credentials) {'true'}

      context 'with non-nil username and password' do

        it 'should be true' do
          expect(subject).to be true
        end
      end

      context 'when username is nil' do
        let(:username) {}

        it 'should be false' do
          expect(subject).to be false
        end
      end

      context 'when password is nil' do
        let(:password) {}

        it 'should be false' do
          expect(subject).to be false
        end
      end
    end

    context 'when the allow_password_credentials is set to false' do
      let(:allow_password_credentials) {'false'}

      it 'should be false' do
        expect(subject).to be false
      end
    end
  end

  describe '#get_access_token' do
    subject(:get_access_token) { client.get_access_token }

    it "should return the access token" do
      expect(subject).to eq(access_token)
    end
  end

  describe '#create_user' do
    subject(:create_user) { client.create_user(new_user_options) }

    before do
      stub_request(:post, "#{endpoint}/v1/users").
        to_return(status: 200,
                  body: returned_user.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::User

    it 'will have the appropriate body and Authorization header' do
      create_user
      expect(a_request(:post, "#{endpoint}/v1/users").
               with(body: Faraday::NestedParamsEncoder.encode({'user'=>new_user_request}), headers: {'Authorization' => auth_header_value})).
        to have_been_made.once
    end
  end

  describe '#update_user' do
    subject(:update_user) { client.update_user(new_user_options) }

    before do
      stub_request(:put, /#{endpoint}\/v1\/users\/#{user_id}/).
        to_return(status: 200,
                  body: returned_user.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::User

    context 'when all user options are populated' do
      it 'will have the appropriate body and Authorization header' do
        update_user
        expect(a_request(:put, /#{endpoint}\/v1\/users\/#{user_id}/).
               with(body: Faraday::NestedParamsEncoder.encode({'user'=>new_user_request}), headers: {'Authorization' => auth_header_value})).
        to have_been_made.once
      end
    end

    context 'when some user options are not populated' do
      let(:new_user_options) do
        {id: user_id,
         email: email,
         first_name: first_name}
      end

      let(:new_user_request) do
        {'email' => email,
         'first_name' => first_name}
      end

      it 'only sends the populated attributes and ignores the rest' do
        update_user
        expect(a_request(:put, /#{endpoint}\/v1\/users\/#{user_id}/).
               with(body: Faraday::NestedParamsEncoder.encode({'user'=>new_user_request}), headers: {'Authorization' => auth_header_value})).
               to have_been_made.once
      end
    end
  end

  describe '#find_user_by_email' do
    subject(:find_user_by_email) { client.find_user_by_email(email) }

    let(:response_body) { [returned_user].to_json}

    before do
      stub_request(:get, /#{endpoint}\/v1\/users/).
        with(query: {'email' => email}, headers: {'Authorization' => auth_header_value}).
        to_return(status: 200,
                  body: response_body,
                  headers: {'Content-Type' => 'application/json'})
    end

    context 'when there is no user' do
      let(:response_body) { [].to_json }

      it 'should return nil' do
        expect(find_user_by_email).to be_nil
      end
    end

    it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::User
  end

  describe '#get_user' do
    subject(:get_user) { client.get_user(user_id) }

    before do
      stub_request(:get, /#{endpoint}\/v1\/users\/#{user_id}/).
        with(headers: {'Authorization' => auth_header_value}).
        to_return(status: 200,
                  body: returned_user.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::User
  end

  describe '#delete_user' do
    subject(:delete_user) { client.delete_user(user_id) }

    before do
      stub_request(:delete, /#{endpoint}\/v1\/users\/#{user_id}/).
        with(headers: {'Authorization' => auth_header_value}).
        to_return(status: 200,
                  body: returned_user.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::User
  end

  describe '#me' do
    subject(:me) { client.me }

    before do
      stub_request(:get, /#{endpoint}\/v1\/me/).
        with(headers: {'Authorization' => auth_header_value}).
        to_return(status: 200,
                  body: returned_user.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::User
  end

  describe '#sign_out_url' do
    subject { sign_out_url }

    context 'without redirect_url' do
      let(:sign_out_url) { client.sign_out_url }

      it 'should add the sign out path to the configured endpoint' do
        expect(sign_out_url).to eq("#{endpoint}/users/sign_out")
      end
    end

    context 'with redirect_url' do
      let(:sign_out_url) { client.sign_out_url('https://test.host/home')}

      it 'should add the sign out path to the endpoint' do
        expect(sign_out_url).to match /^#{endpoint}\/users\/sign_out/
      end

      it 'should add the redirect_url as a query param' do
        expect(sign_out_url). to match /\?redirect_url=https%3A%2F%2Ftest.host%2Fhome$/
      end
    end
  end

  describe '#token_info' do
    subject(:token_info) { client.token_info }

    let(:returned_token_info) do
      {
        resource_owner_id: '42',
        scopes: [],
        expires_in_seconds: 3600,
        application: { uid: 'application-uid-abc123' }
      }
    end

    before do
      stub_request(:get, /#{endpoint}\/oauth\/token\/info/).
        with(headers: {'Authorization' => auth_header_value}).
        to_return(status: 200,
                  body: returned_token_info.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::TokenInfo
  end

  describe '#list_users' do
    subject(:list_users) { client.list_users }

    before do
      stub_request(:get, /#{endpoint}\/v1\/users/).
        with(headers: {'Authorization' => auth_header_value}).
        to_return(status: 200,
                  body: [returned_user].to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it 'should return one user' do
      expect(list_users.size).to eq(1)
    end

    describe 'the first user' do
      subject(:user) { list_users.first }

      it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::User
    end
  end

  describe '#list_roles' do
    subject(:list_roles) { client.list_roles }

    before do
      stub_request(:get, /#{endpoint}\/v1\/roles/).
        with(headers: {'Authorization' => auth_header_value}).
        to_return(status: 200,
                  body: [returned_role].to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it 'should return one role' do
      expect(list_roles.size).to eq(1)
    end

    describe 'the first role' do
      subject(:role) { list_roles.first }

      it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::Role
    end
  end

  context 'stubbed get token' do
    let(:token) {'asdf'}
    before do
      oauth_client = double(OAuth2::AccessToken, password: double(:pw, get_token: token))
      allow(client).to receive(:oauth_client).and_return(oauth_client)
    end

    describe '#username_pw_access_token' do
      let(:returned_token) { {access_token: 'asdf'} }
      before do
        client.allow_password_credentials = 'true'
      end

      it 'delegates token retrieval to oauth_client' do
        expect(client.username_pw_access_token).to eq(token)
      end
    end
  end
end
