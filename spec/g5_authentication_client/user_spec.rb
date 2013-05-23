require 'spec_helper'

describe G5AuthenticationClient::User do
  let(:user){G5AuthenticationClient::User.new(attributes)}

  let(:attributes) do
    {:email => email,
    :password => password,
    :id => id
    }
  end

  let(:email) { 'foo@blah.com' }
  let(:password) { 'foobarbaz' }
  let(:id) {1}

  context 'with default initialization' do
    subject{user}
    let(:attributes){}

    its(:email) { should be_nil}

    its(:password) { should be_nil}

    its(:id){ should be_nil}

    it "should be invalid" do
      expect{subject.validate!}.to raise_error
    end
  end

  context 'with full initialization' do
    subject{user}

    its(:email) { should == email }

    its(:password){ should == password }

    its(:id) { should == id}

    it "should be valid" do
      expect{subject.validate!}.to be_true
    end
  end

  context 'with partial initialization' do
    subject{user}

    context 'without email' do

      let(:email){}

      it "should be invalid" do
        expect{subject.validate!}.to raise_error
      end
    end

    context 'without password' do
      let(:password){}

      its(:validate!){should be_nil}
    end

    context 'without id' do
      let(:id){}

      its(:validate!){should be_nil}
    end
  end

  context '#validate_for_create' do
    subject{user.validate_for_create!}
    let(:password){}

    it "should be invalid" do
      expect{subject}.to raise_error
    end

    context 'with invalid email' do
      let(:email){}
      let(:password){'foo'}

      it "should be invalid" do
        expect{subject}.to raise_error
      end
    end
  end
end
