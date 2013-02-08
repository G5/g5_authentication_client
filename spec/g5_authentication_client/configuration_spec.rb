require 'spec_helper'

describe G5AuthenticationClient::Configuration do
  let(:test_module) do
    module TestModule
      extend G5AuthenticationClient::Configuration
    end
  end

  subject { test_module }

  let(:logger) { mock() }

  after { test_module.reset }

  it { should respond_to(:configure) }

  context 'with default configuration' do

    it { should_not be_debug }
    its(:logger) { should be_an_instance_of(Logger) }

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
          # TODO: add config options here, for example:
          # config.my_setting = 'value'
        end
      end

      it { should == test_module }

      it { should be_debug }
      its(:logger) { should == logger }
    end

    context 'with partial configuration' do
      let(:config_block) do
        lambda do |config|
          
          config.debug = true
          # TODO: add config options here, for example:
          # config.my_required_setting = 'value'
        end
      end

      it { should == test_module }

      it { should be_debug }
      its(:logger) { should be_an_instance_of(Logger) }
    end
  end

  it { should respond_to(:reset) }

  describe '.reset' do
    before do
      test_module.configure do |config|
        
        config.debug = true
        config.logger = logger
        # TODO: configure the module, for example
        # config.my_option = true
      end
    end

    subject { test_module.reset }


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
        # TODO: configure the module, for example
        # config.my_option = true
      end
    end

    subject { test_module.options }

    its([:debug]) { should be_true }
    its([:logger]) { should == logger }
  end
end
