require 'spec_helper'

describe G5AuthenticationClient::TokenInfo do
  subject { token_info }
  let(:token_info) { described_class.new(attributes) }

  let(:attributes) do
    {
      resource_owner_id: resource_owner_id,
      scopes: scopes,
      expires_in_seconds: expires_in_seconds,
      application: { uid: application_uid }
    }
  end

  let(:resource_owner_id) { 42 }
  let(:scopes) { ['leads','calls'] }
  let(:expires_in_seconds) { '3600' }
  let(:application_uid) { 'application-uid-42' }

  context 'with default initialization' do
    let(:attributes) {}

    its(:resource_owner_id) { should be_nil }
    its(:scopes) { should be_empty }
    its(:expires_in_seconds) { should be_nil }
    its(:application_uid) { should be_nil }
  end

  context 'with full initialization' do
    its(:resource_owner_id) { should == resource_owner_id.to_s }
    its(:scopes) { should == scopes }
    its(:expires_in_seconds) { should == expires_in_seconds.to_i }
    its(:application_uid) { should == application_uid }
  end
end
