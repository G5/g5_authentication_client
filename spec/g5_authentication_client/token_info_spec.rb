require 'spec_helper'

describe G5AuthenticationClient::TokenInfo do
  subject(:token) { token_info }
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

    it 'should have nil resource_owner_id' do
      expect(token.resource_owner_id).to be_nil
    end

    it 'should have nil scopes' do
      expect(token.scopes).to be_empty
    end

    it 'should have nil expires_in_seconds' do
      expect(token.expires_in_seconds).to be_nil
    end

    it 'should have nil application_uid' do
      expect(token.application_uid).to be_nil
    end
  end

  context 'with full initialization' do
    it 'should have resource_owner_id' do
      expect(token.resource_owner_id).to eq(resource_owner_id.to_s)
    end

    it 'should have scopes' do
      expect(token.scopes).to eq(scopes)
    end

    it 'should have expires_in_seconds' do
      expect(token.expires_in_seconds).to eq(expires_in_seconds.to_i)
    end

    it 'should have application_uid' do
      expect(token.application_uid).to eq(application_uid)
    end
  end
end
