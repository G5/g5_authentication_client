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

    its(:email) { should be_nil}
    its(:password) { should be_nil}
    its(:id){ should be_nil}
    its(:password_confirmation) { should be_nil }
  end

  context 'with full initialization' do
    its(:email) { should == email }
    its(:password){ should == password }
    its(:password_confirmation) { should == password_confirmation }
    its(:id) { should == id}
    its(:first_name) { should eq(first_name) }
    its(:last_name) { should eq(last_name) }
    its(:organization_name) { should eq(organization_name) }
    its(:phone_number) { should eq(phone_number) }
    its(:title) { should eq(title) }
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
end
