require 'spec_helper'

describe G5AuthenticationClient::User do
  subject(:user) { G5AuthenticationClient::User.new(attributes) }

  let(:attributes) do
    { email: email,
      password: password,
      password_confirmation: password_confirmation,
      id: id,
      first_name: first_name,
      last_name: last_name,
      title: title,
      organization_name: organization_name,
      phone_number: phone_number
    }
  end

  let(:email) { 'foo@blah.com' }
  let(:password) { 'foobarbaz' }
  let(:password_confirmation) { 'notamatch' }
  let(:id) {1}
  let(:first_name) { 'Joe' }
  let(:last_name) { 'Person' }
  let(:organization_name) { 'Things, Inc.' }
  let(:phone_number) { '8675309123' }
  let(:title) { 'Developer' }

  context 'with default initialization' do
    let(:attributes){}

    it 'should have nil email' do
      expect(user.email).to be_nil
    end

    it 'should have nil password' do
      expect(user.password).to be_nil
    end

    it 'should have nil id ' do
      expect(user.id).to be_nil
    end

    it 'should have nil password_confirmation' do
      expect(user.password_confirmation).to be_nil
    end
  end

  context 'with full initialization' do

    it 'should have correct email' do
      expect(user.email).to eq(email)
    end

    it 'should have correct password' do
      expect(user.password).to eq(password)
    end

    it 'should have correct password_confirmation' do
      expect(user.password_confirmation).to eq(password_confirmation)
    end

    it 'should have correct id' do
      expect(user.id).to eq(id)
    end

    it 'should have correct first_name' do
      expect(user.first_name).to eq(first_name)
    end

    it 'should have correct last_name' do
      expect(user.last_name).to eq(last_name)
    end

    it 'should have correct title' do
      expect(user.title).to eq(title)
    end

    it 'should have correct phone_number' do
      expect(user.phone_number).to eq(phone_number)
    end

    it 'should have correct organization_name' do
      expect(user.organization_name).to eq(organization_name)
    end
  end

  describe '#validate!' do
    subject(:validate!) { user.validate! }

    context 'without email' do
      let(:email){}

      it 'should raise an error' do
        expect { validate! }.to raise_error
      end
    end

    context 'without password' do
      let(:password){}

      it 'should not raise an error' do
        expect { validate! }.to_not raise_error
      end
    end

    context 'without id' do
      let(:id){}

      it 'should not raise an error' do
        expect { validate! }.to_not raise_error
      end
    end

    context 'without password_confirmation' do
      let(:password_confirmation) {}

      it 'should not raise an error' do
        expect { validate! }.to_not raise_error
      end
    end

    context 'without first_name' do
      let(:first_name) {}

      it 'should not raise an error' do
        expect { validate! }.to_not raise_error
      end
    end

    context 'without last_name' do
      let(:last_name) {}

      it 'should not raise an error' do
        expect { validate! }.to_not raise_error
      end
    end

    context 'without title' do
      let(:title) {}

      it 'should not raise an error' do
        expect { validate! }.to_not raise_error
      end
    end

    context 'without phone_number' do
      let(:phone_number) {}

      it 'should not raise an error' do
        expect { validate! }.to_not raise_error
      end
    end

    context 'without organization_name' do
      let(:organization_name) {}

      it 'should not raise an error' do
        expect { validate! }.to_not raise_error
      end
    end
  end

  describe '#validate_for_create!' do
    subject(:validate_for_create) {user.validate_for_create!}

    context 'without a password' do
      let(:password){}

      it 'should be invalid' do
        expect { validate_for_create }.to raise_error
      end
    end

    context 'without an email' do
      let(:email){}
      let(:password){'foo'}

      it 'should be invalid' do
        expect { validate_for_create }.to raise_error
      end
    end
  end

  describe '#to_hash' do
    subject(:to_hash) { user.to_hash }

    it 'should have a first name' do
      expect(to_hash['first_name']).to eq(first_name)
    end

    it 'should have a last name' do
      expect(to_hash['last_name']).to eq(last_name)
    end

    it 'should have an email' do
      expect(to_hash['email']).to eq(email)
    end

    it 'should have a title ' do
      expect(to_hash['title']).to eq(title)
    end

    it 'should have an organization name' do
      expect(to_hash['organization_name']).to eq(organization_name)
    end

    it 'should have an phone_number' do
      expect(to_hash['phone_number']).to eq(phone_number)
    end

    it 'should not have an id' do
      expect(to_hash).to_not include('id')
    end
  end
end
