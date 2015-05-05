require 'spec_helper'

describe G5AuthenticationClient::Role do
  subject(:role) { G5AuthenticationClient::Role.new(attributes) }

  let(:attributes) { {name: name} }
  let(:name) { 'awesome_role' }

  context 'with default initialization' do
    let(:attributes) {}

    it 'should have a nil name' do
      expect(role.name).to be_nil
    end
  end

  context 'with full initialization' do
    it 'should have the correct name' do
      expect(role.name).to eq(name)
    end
  end

  context 'when attributes include unknown properties' do
    let(:attributes) { {name: name, resource: 'Application'} }

    it 'should not raise an error' do
      expect { role }.to_not raise_error
    end

    it 'should have the correct name' do
      expect(role.name).to eq(name)
    end

    it 'should ignore the unknown attribute' do
      expect(role).to_not respond_to(:resource)
    end
  end

  describe '#validate!' do
    subject(:validate!) { role.validate! }

    context 'when all attributes are set' do
      it 'should not raise an error' do
        expect { validate! }.to_not raise_error
      end
    end

    context 'when name is not set' do
      let(:name) {}

      it 'should raise an error' do
        expect { validate! }.to raise_error
      end
    end
  end

  describe '#to_hash' do
    subject(:hash) { role.to_hash }

    it 'should have the correct name' do
      expect(hash['name']).to eq(name)
    end
  end
end
