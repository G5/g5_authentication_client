require 'spec_helper'

describe G5AuthenticationClient::Configuration do
  let(:test_module) do
    module TestModule
      extend G5AuthenticationClient::Configuration
    end
  end

  subject { test_module }

  let(:logger) { double() }
  let(:username) {'username'}
  let(:password) {'password'}
  let(:client_id) {'client id'}
  let(:client_secret) {'client secret'}
  let(:redirect_uri) {'/stuff'}
  let(:endpoint){ 'http://endpoint.com' }
  let(:authorization_code){ 'code' }
  let(:access_token) { 'access_token_test' }

  after { test_module.reset }

  it { should respond_to(:configure) }

  context 'with default configuration' do
    it { should_not be_debug }
    its(:logger) { should be_an_instance_of(Logger) }
    its(:username) {should be_nil}
    its(:password) {should be_nil}
    its(:client_id) {should == G5AuthenticationClient::DEFAULT_CLIENT_ID}
    its(:client_secret) {should == G5AuthenticationClient::DEFAULT_CLIENT_SECRET}
    its(:redirect_uri) {should == G5AuthenticationClient::DEFAULT_REDIRECT_URI}
    its(:endpoint){should == G5AuthenticationClient::DEFAULT_ENDPOINT}
    its(:authorization_code){ should be_nil }
    its(:access_token) { should be_nil }
  end

  describe '.configure' do
    subject { test_module.configure(&config_block) }

    context 'with full configuration' do
      let(:config_block) do
        lambda do |config|
          config.debug = true
          config.logger = logger
          config.username = username
          config.password = password
          config.client_id = client_id
          config.client_secret = client_secret
          config.redirect_uri = redirect_uri
          config.endpoint = endpoint
          config.authorization_code = authorization_code
          config.access_token = access_token
        end
      end

      it { should == test_module }
      it { should be_debug }
      its(:logger) { should == logger }
      its(:username){ should == username }
      its(:password){ should == password }
      its(:client_id){ should == client_id }
      its(:client_secret){ should == client_secret }
      its(:redirect_uri){ should == redirect_uri}
      its(:endpoint){ should == endpoint}
      its(:authorization_code){ should == authorization_code}
      its(:access_token) { should == access_token }
    end

    context 'with partial configuration' do
      let(:config_block) do
        lambda do |config|
          config.debug = true
          config.username = 'foo'
          config.password = 'bar'
        end
      end

      it { should == test_module }

      it { should be_debug }
      its(:logger) { should be_an_instance_of(Logger) }
      its(:username) { should == 'foo' }
      its(:password) { should == 'bar' }
      its(:client_id){ should == G5AuthenticationClient::DEFAULT_CLIENT_ID }
      its(:client_secret){ should == G5AuthenticationClient::DEFAULT_CLIENT_SECRET }
      its(:redirect_uri){ should == G5AuthenticationClient::DEFAULT_REDIRECT_URI }
      its(:endpoint){ should == G5AuthenticationClient::DEFAULT_ENDPOINT}
      its(:authorization_code){ should be_nil}
      its(:access_token) { should be_nil }
    end
  end

  it { should respond_to(:reset) }

  describe '.reset' do
    before do
      test_module.configure do |config|
        config.debug = true
        config.logger = logger
        config.username = 'foo'
        config.password = 'bar'
        config.endpoint = 'blah'
        config.client_id = 'blah'
        config.client_secret = 'blah'
        config.redirect_uri = 'blah'
        config.authorization_code = 'blah'
        config.access_token = 'blah'
      end
    end

    subject { test_module.reset;test_module }

    its(:username) {should be_nil}
    its(:password) {should be_nil}
    its(:endpoint) {should == G5AuthenticationClient::DEFAULT_ENDPOINT}
    its(:client_id) {should == G5AuthenticationClient::DEFAULT_CLIENT_ID}
    its(:client_secret) {should == G5AuthenticationClient::DEFAULT_CLIENT_SECRET}
    its(:redirect_uri) {should == G5AuthenticationClient::DEFAULT_REDIRECT_URI}
    its(:debug?){ should be_false }
    its(:logger){ should be_instance_of(Logger) }
    its(:access_token) { should be_nil }
  end

  describe '.options' do
    before do
      test_module.configure do |config|
        config.debug = true
        config.logger = logger
        config.username = username
        config.password = password
        config.endpoint = endpoint
        config.client_id = client_id
        config.client_secret = client_secret
        config.redirect_uri = redirect_uri
        config.authorization_code = authorization_code
        config.access_token = access_token
      end
    end

    subject { test_module.options }

    its([:debug]) { should be_true }
    its([:logger]) { should == logger }
    its([:username]) { should == username } 
    its([:password]) { should == password }
    its([:endpoint]) { should == endpoint }
    its([:client_id]) { should == client_id }
    its([:client_secret]) { should == client_secret }
    its([:redirect_uri]) { should == redirect_uri}
    its([:authorization_code]){ should == authorization_code }
    its([:access_token]) { should == access_token }
  end
end
