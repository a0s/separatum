require 'spec_helper'

RSpec.describe Separatum::Processors::FieldChanger do
  CustomClass = Class.new
  Processor = Class.new do
    def processor(_)
      'bbb'
    end
  end

  describe '#call' do
    let(:hash1) { { _klass: 'CustomClass', custom_field: 'aaa' } }

    let(:fc1) do
      Separatum::Processors::FieldChanger.new 'CustomClass#custom_field' do |_|
        'bbb'
      end
    end
    let(:fc2) do
      Separatum::Processors::FieldChanger.new CustomClass, :custom_field do |_|
        'bbb'
      end
    end
    let(:fc3) { Separatum::Processors::FieldChanger.new 'CustomClass#custom_field', -> (_) { 'bbb' } }
    let(:fc4) { Separatum::Processors::FieldChanger.new CustomClass, :custom_field, -> (_) { 'bbb' } }
    let(:fc5) { Separatum::Processors::FieldChanger.new 'CustomClass#custom_field', 'Processor#processor' }
    let(:fc6) { Separatum::Processors::FieldChanger.new 'CustomClass#custom_field', Processor, :processor }
    let(:fc7) { Separatum::Processors::FieldChanger.new CustomClass, :custom_field, 'Processor#processor' }
    let(:fc8) { Separatum::Processors::FieldChanger.new CustomClass, :custom_field, Processor, :processor }

    it { expect(fc1.([hash1])[0][:custom_field]).to eq 'bbb' }
    it { expect(fc2.([hash1])[0][:custom_field]).to eq 'bbb' }
    it { expect(fc3.([hash1])[0][:custom_field]).to eq 'bbb' }
    it { expect(fc4.([hash1])[0][:custom_field]).to eq 'bbb' }
    it { expect(fc5.([hash1])[0][:custom_field]).to eq 'bbb' }
    it { expect(fc6.([hash1])[0][:custom_field]).to eq 'bbb' }
    it { expect(fc7.([hash1])[0][:custom_field]).to eq 'bbb' }
    it { expect(fc8.([hash1])[0][:custom_field]).to eq 'bbb' }
  end
end
