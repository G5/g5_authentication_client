# frozen_string_literal: true

require 'spec_helper'

describe G5AuthenticationClient do
  it "should have a version" do
    expect(subject::VERSION).to be
  end

  it { is_expected.to respond_to(:configure) }
  it { is_expected.to respond_to(:reset) }
  it { is_expected.to respond_to(:options) }
end
