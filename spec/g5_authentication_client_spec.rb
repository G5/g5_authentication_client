require 'spec_helper'

describe G5AuthenticationClient do
  it "should have a version" do
    subject::VERSION.should be
  end

  it { should respond_to(:configure) }
  it { should respond_to(:reset) }
  it { should respond_to(:options) }
end
