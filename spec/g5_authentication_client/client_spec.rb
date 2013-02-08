require 'spec_helper'

describe G5AuthenticationClient::Client do
  subject { client }

  after { G5AuthenticationClient.reset }

  let(:client) { G5AuthenticationClient::Client.new(options) }

  let(:debug) { true }
  let(:logger) { mock() }

  let(:options) do
    {
     :debug => debug,
     :logger => logger
    }
  end

  context 'with default configuration' do
    let(:client) { G5AuthenticationClient::Client.new }

    it { should_not be_debug }
    its(:logger) { should be_an_instance_of(Logger) }

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

    # TODO: test for all config options. For example,
    # its(:setting) { should == 'value' }

    # TODO: test writers for config options. For example,
    # describe "#my_setting" do
    #   subject { client.my_setting = new_val }
    #   let(:new_val) { 'new value' }
    #   it 'should change the value of my_setting' do
    #     expect { subject }.to change { client.my_setting }.from(nil).to(new_val)
    #   end
    # end
  end
end
