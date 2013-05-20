require 'spec_helper'

shared_examples_for 'a module configured attribute' do |attribute_name,default_value|

    describe "##{attribute_name.to_s}=" do
      subject do
        client.send "#{attribute_name.to_s}=", new_value
        client
      end

      context "with nil #{attribute_name.to_s}" do
        let(:new_value){nil}

        context "with module configured #{attribute_name}" do
          let(:configured_value){'other thing'}

          before do
            G5AuthenticationClient.configure do |t|
              t.send "#{attribute_name.to_s}=", configured_value
            end
          end

          its(attribute_name){ should == configured_value }
        end

        context 'without module configured #{attribute_name}' do
          its(attribute_name){ should == default_value }
        end
      end

      context 'with new #{attribute_name.to_s}' do
        let(:new_value){ 'userdude' }

        its(attribute_name){ should == new_value }
      end
    end
end
