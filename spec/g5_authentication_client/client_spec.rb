require 'spec_helper'
require 'json'

describe G5AuthenticationClient::Client do
  subject { client }

  after { G5AuthenticationClient.reset }

  let(:client) { G5AuthenticationClient::Client.new(options) }

  let(:debug) { true }
  let(:logger) { mock() }
  let(:username) {'username'}
  let(:password) {'password'}
  let(:client_id) {'client id'}
  let(:client_secret) {'client secret'}
  let(:client_callback_url) {'/stuff'}
  let(:endpoint){ 'http://endpoint.com' }
  let(:authorization_code){ 'code' }

  let(:options) do
    {
     :debug => debug,
     :logger => logger,
     :endpoint => endpoint,
     :username => username,
     :password => password,
     :client_id => client_id,
     :client_secret => client_secret,
     :client_callback_url => client_callback_url,
     :authorization_code => authorization_code,
     :access_token => access_token
    }
  end

  let(:access_token) { access_token_value }
  let(:access_token_value) { 'test_token' }
  let(:token_type) { 'Bearer' }

  let(:auth_header_value) { "#{token_type} #{access_token_value}" }

  let(:new_user_options) do
    {:email=>email,
    :password=>"#{password}x",
    :id=>user_id}
  end

  let(:email){'foo@blah.com'}
  let(:password){'mybigtestpasswored'}
  let(:user_id){1}
  let(:returned_user){{:id=>user_id,:email=>email}}

  context 'with default configuration' do
    let(:client) { G5AuthenticationClient::Client.new }

    it { should_not be_debug }
    its(:logger) { should be_an_instance_of(Logger) }
    its(:username) { should be_nil }
    its(:password) { should be_nil }
    its(:client_id) { should == G5AuthenticationClient::DEFAULT_CLIENT_ID }
    its(:client_secret) { should == G5AuthenticationClient::DEFAULT_CLIENT_SECRET }
    its(:client_callback_url) { should == G5AuthenticationClient::DEFAULT_CLIENT_CALLBACK_URL }
    its(:endpoint){ should == G5AuthenticationClient::DEFAULT_ENDPOINT}
    its(:authorization_code){ should be_nil}
    its(:access_token) { should be_nil }
  end

  context 'with non-default configuration' do
    it { should be_debug }
    its(:logger) { should == logger }

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
          let(:configured_logger) { mock() }
          before { G5AuthenticationClient.configure { |config| config.logger = configured_logger } }

          it 'should change the value of the logger to match the configuration' do
            expect { subject }.to change { client.logger }.from(logger).to(configured_logger)
          end
        end

        context 'when there is no logger configured at the top level' do
          it 'should change the value of the logger to the default' do
            expect { subject }.to change { client.logger }
            client.logger.should be_an_instance_of(Logger)
          end
        end
      end

      context 'with new logger' do
        let(:new_logger) { mock() }

        it 'should change the value of the logger to match the new value' do
          expect { subject }.to change { client.logger }.from(logger).to(new_logger)
        end
      end
    end

    its(:username) { should == username }

    it_should_behave_like 'a module configured attribute',:username, nil

    its(:password) { should == password }

    it_should_behave_like 'a module configured attribute', :password, nil

    its(:endpoint){ should == endpoint}

    it_should_behave_like 'a module configured attribute', :endpoint,G5AuthenticationClient::DEFAULT_ENDPOINT

    its(:client_id) { should == client_id}

    it_should_behave_like 'a module configured attribute', :client_id, G5AuthenticationClient::DEFAULT_CLIENT_ID

    its(:client_secret) {should ==client_secret}

    it_should_behave_like 'a module configured attribute', :client_secret, G5AuthenticationClient::DEFAULT_CLIENT_SECRET

    its(:client_callback_url) {should ==client_callback_url}

    it_should_behave_like 'a module configured attribute', :client_callback_url, G5AuthenticationClient::DEFAULT_CLIENT_CALLBACK_URL

    its(:authorization_code) { should == authorization_code}
    it_should_behave_like 'a module configured attribute', :authorization_code, nil

    its(:access_token) { should == access_token_value }
    it_should_behave_like 'a module configured attribute', :access_token, nil
  end

  context '#create_user' do
    subject(:create_user) { client.create_user(new_user_options) }

    before do
      stub_request(:post, /#{endpoint}\/v1\/users/).
        with(headers: {'Authorization' => auth_header_value}).
        to_return(status: 200,
                  body: returned_user.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::User
  end

  context '#update_user' do
    subject(:update_user) { client.update_user(new_user_options) }

    before do
      stub_request(:put, /#{endpoint}\/v1\/users\/#{user_id}/).
        with(headers: {'Authorization' => auth_header_value}).
        to_return(status: 200,
                  body: returned_user.to_json,
                  headers: {'Content-Type' => 'application/json'})
    end

    it_should_behave_like 'an oauth protected resource', G5AuthenticationClient::User
  end

  context '#get_user' do
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

  context '#delete_user' do
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
end
