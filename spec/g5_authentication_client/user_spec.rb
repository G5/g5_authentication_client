require 'spec_helper'

describe G5AuthenticationClient::User do
  subject { user }
  let(:user){G5AuthenticationClient::User.new(attributes)}

  let(:attributes) do
    {:email => email,
    :password => password,
    :password_confirmation => password_confirmation,
    :id => id
    }
  end

  let(:email) { 'foo@blah.com' }
  let(:password) { 'foobarbaz' }
  let(:password_confirmation) { 'notamatch' }
  let(:id) {1}

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
