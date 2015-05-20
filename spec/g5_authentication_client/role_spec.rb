require 'spec_helper'

describe G5AuthenticationClient::Role do
  subject(:role) { G5AuthenticationClient::Role.new(attributes) }

  let(:attributes) do {
    name: name,
    type: type,
    urn: urn,
  }
  end

  let(:name) { 'awesome_role' }
  let(:type) { 'SomeClass' }
  let(:urn)  { 'some_urn' }

  context 'with default initialization' do
    let(:attributes) {}

    it 'should have a nil name' do
      expect(role.name).to be_nil
    end
    it 'has a nil type' do
      expect(role.type).to be_nil
    end
    it 'has a nil urn' do
      expect(role.urn).to be_nil
    end
  end

  context 'with full initialization' do
    it 'should have the correct name' do
      expect(role.name).to eq(name)
    end
    it 'should have the correct name' do
      expect(role.type).to eq(type)
    end
    it 'should have the correct name' do
      expect(role.urn).to eq(urn)
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

  describe '#validate_for_create!' do
    subject(:validate_for_create) {role.validate_for_create!}

    context 'when type not GLOBAL and no urn' do

      let(:type) { 'not_global' }
      let(:urn) {  }

      it 'will raise an error' do
        expect { validate_for_create }.to raise_error
      end
    end

    context 'when type GLOBAL and no urn' do

      let(:type) { 'GLOBAL' }
      let(:urn) {  }

      it 'will raise an error' do
        expect { validate_for_create }.to_not raise_error
      end
    end

    context 'when type not GLOBAL and existing urn' do

      let(:type) { 'NOT_GLOBAL' }
      let(:urn) { 'some_urn' }

      it 'will raise an error' do
        expect { validate_for_create }.to_not raise_error
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
