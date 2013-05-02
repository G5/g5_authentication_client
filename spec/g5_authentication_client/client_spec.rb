require 'spec_helper'

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


  let(:options) do
    {
     :debug => debug,
     :logger => logger,
     :endpoint => endpoint,
     :username => username,
     :password => password,
     :client_id => client_id,
     :client_secret => client_secret,
     :client_callback_url => client_callback_url
    }
  end

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


    # TODO: test for config options with default values. For example,
    # its(:required_setting) { should == G5AuthenticationClient::DEFAULT_REQUIRED_SETTING }
    # its(:optional_setting) { should be_nil }

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

  end
end
