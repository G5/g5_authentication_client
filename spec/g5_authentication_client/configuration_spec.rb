require 'spec_helper'

describe G5AuthenticationClient::Configuration do
  let(:test_module) do
    module TestModule
      extend G5AuthenticationClient::Configuration
    end
  end

  subject { test_module }

  let(:logger) { mock() }
  let(:username) {'username'}
  let(:password) {'password'}
  let(:client_id) {'client id'}
  let(:client_secret) {'client secret'}
  let(:client_callback_url) {'/stuff'}
  let(:endpoint){ 'http://endpoint.com' }


  after { test_module.reset }

  it { should respond_to(:configure) }

  context 'with default configuration' do

    it { should_not be_debug }
    its(:logger) { should be_an_instance_of(Logger) }
    its(:username) {should be_nil}
    its(:password) {should be_nil}
    its(:client_id) {should == G5AuthenticationClient::DEFAULT_CLIENT_ID}
    its(:client_secret) {should == G5AuthenticationClient::DEFAULT_CLIENT_SECRET}
    its(:client_callback_url) {should == G5AuthenticationClient::DEFAULT_CLIENT_CALLBACK_URL}
    its(:endpoint){should == G5AuthenticationClient::DEFAULT_ENDPOINT}

    # TODO: test config options with defaults here, for example:
    # its(:special_prop) { should == G5AuthenticationClient::DEFAULT_SPECIAL_PROP }
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
          config.client_callback_url = client_callback_url
          config.endpoint = endpoint
          # TODO: add config options here, for example:
          # config.my_setting = 'value'
        end
      end

      it { should == test_module }

      it { should be_debug }
      its(:logger) { should == logger }
      its(:username){ should == username }
      its(:password){ should == password }
      its(:client_id){ should == client_id }
      its(:client_secret){ should == client_secret }
      its(:client_callback_url){ should == client_callback_url}
      its(:endpoint){ should == endpoint}
    end

    context 'with partial configuration' do
      let(:config_block) do
        lambda do |config|
          config.debug = true
          config.username = 'foo'
          config.password = 'bar'
          # TODO: add config options here, for example:
          # config.my_required_setting = 'value'
        end
      end

      it { should == test_module }

      it { should be_debug }
      its(:logger) { should be_an_instance_of(Logger) }
      its(:username) { should == 'foo' }
      its(:password) { should == 'bar' }
      its(:client_id){ should == G5AuthenticationClient::DEFAULT_CLIENT_ID }
      its(:client_secret){ should == G5AuthenticationClient::DEFAULT_CLIENT_SECRET }
      its(:client_callback_url){ should == G5AuthenticationClient::DEFAULT_CLIENT_CALLBACK_URL }
      its(:endpoint){ should == G5AuthenticationClient::DEFAULT_ENDPOINT}

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
        config.client_callback_url = 'blah'

        # TODO: configure the module, for example
        # config.my_option = true
      end
    end

    subject { test_module.reset }

    it "should ret the username" do
      expect{subject}.to change { test_module.username }.to(nil)
    end

    it "should reset the password" do
      expect{subject}.to change { test_module.password}.to(nil)
    end

    it "should reset the endpoint" do
      expect{subject}.to change { test_module.endpoint}.to(G5AuthenticationClient::DEFAULT_ENDPOINT)
    end

    it "should reset the client_id" do
      expect{subject}.to change { test_module.client_id}.to(G5AuthenticationClient::DEFAULT_CLIENT_ID)
    end

    it "should reset the client_secret" do
      expect{subject}.to change { test_module.client_secret}.to(G5AuthenticationClient::DEFAULT_CLIENT_SECRET)
    end

    it "should reset the client_callback_url" do
      expect{subject}.to change { test_module.client_callback_url}.to(G5AuthenticationClient::DEFAULT_CLIENT_CALLBACK_URL)
    end

    it 'should change the debug flag to the default value' do
      expect { subject }.to change { test_module.debug? }.to(false)
    end

    it 'should change the logger to the default value' do
      expect { subject }.to change { test_module.logger }
      test_module.logger.should be_an_instance_of(Logger)
    end

    # TODO: assert that all configuration options have been reset
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
        config.client_callback_url = client_callback_url

        # TODO: configure the module, for example
        # config.my_option = true
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
    its([:client_callback_url]) { should == client_callback_url}
  end
end
