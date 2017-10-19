# frozen_string_literal: true

require 'spec_helper'

describe G5AuthenticationClient::TokenInfo do
  subject(:token) { token_info }
  let(:token_info) { described_class.new(attributes) }

  let(:attributes) do
    {
      resource_owner_id: resource_owner_id,
      scopes: scopes,
      expires_in_seconds: expires_in_seconds,
      application: { uid: application_uid },
      created_at: created_at,
      extra_attribute: 'some value'
    }
  end

  let(:resource_owner_id) { 42 }
  let(:scopes) { %w[leads calls] }
  let(:expires_in_seconds) { '3600' }
  let(:application_uid) { 'application-uid-42' }
  let(:created_at) { Time.now.to_i }

  context 'with default initialization' do
    let(:attributes) {}

    its(:resource_owner_id) { is_expected.to be_nil }
    its(:scopes) { are_expected.to be_empty }
    its(:expires_in_seconds) { is_expected.to be_nil }
    its(:application_uid) { is_expected.to be_nil }
    its(:created_at) { is_expected.to be_nil }
    it { is_expected.to_not respond_to(:extra_attributes) }
  end

  context 'with full initialization' do
    its(:resource_owner_id) { is_expected.to eq(resource_owner_id.to_s) }
    its(:scopes) { are_expected.to eq(scopes) }
    its(:expires_in_seconds) { is_expected.to eq(expires_in_seconds.to_i) }
    its(:application_uid) { is_expected.to eq(application_uid) }
    its(:created_at) { is_expected.to eq(Time.at(created_at)) }
    it { is_expected.to_not respond_to(:extra_attribute) }
  end

  context 'with string key initialization' do
    let(:attributes) do
      {
        'resource_owner_id' => resource_owner_id,
        'application_uid' => application_uid
      }
    end

    its(:resource_owner_id) { is_expected.to eq(resource_owner_id.to_s) }
    its(:application_uid) { is_expected.to eq(application_uid) }
  end
end
