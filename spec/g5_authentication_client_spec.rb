require 'spec_helper'

describe G5AuthenticationClient do
  it "should have a version" do
    expect(subject::VERSION). to be
  end

  it "should respond to configure" do
    expect(subject).to respond_to(:configure)
  end

  it "should respond to reset" do
    expect(subject).to respond_to(:reset)
  end

  it "should respond to options" do
    expect(subject).to respond_to(:options)
  end
end
