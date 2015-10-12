require 'spec_helper'

describe G5AuthenticationClient::AuthTokenHelper do
  class TestDummy
    include G5AuthenticationClient::AuthTokenHelper
  end
  subject { TestDummy.new }
  describe '#do_with_username_pw_access_token' do
    let(:response) { double(:response, code: code) }
    let(:token) { double(:token, token: 'asdf') }
    before do
      allow(G5AuthenticationClient::Client).to receive(:new).and_return(double(:client, username_pw_access_token: token))
    end
    let(:call) do
      subject.do_with_username_pw_access_token do |token|
        response
      end
    end

    context '200' do
      let(:code) { '200' }
      it 'responds with the yielded response' do
        expect(call).to eq(response)
      end

      context 'subsequent calls' do
        before do
          call
          call
        end
        it 'responds with the yieleded response' do
          expect(call).to eq(response)
        end
        it 'calls username_pw_access_token once' do
          expect(G5AuthenticationClient::Client).to have_received(:new).once
        end
      end
    end

    context '401' do
      let(:code) { '401' }
      before do
        allow(G5AuthenticationClient::Client).to receive(:new).and_return(double(:client, username_pw_access_token: token))
        call
      end
      it 'responds with the yielded response' do
        expect(call).to eq(response)
      end
      it 'calls username_pw_access_token once' do
        expect(G5AuthenticationClient::Client).to have_received(:new).twice
      end
    end
  end
end