require 'spec_helper'
require 'timecop'

RSpec.describe Separatum::Processors::TimeMachine do
  before(:all) { Timecop.freeze(Time.parse('2019-01-05 00:00:00 +0300')) }
  after(:all) { Timecop.return }

  describe '#call' do
    let(:hash1) { { custom_field: '2019-01-10 00:00:00 +0300', _time_machine: '2019-01-01 00:00:00 +0300' } }
    let(:hash2) { { custom_field: '2019-01-10 00:00:00 +0300' } }

    it { expect(subject.(hash1)[0][:custom_field]).to eq('2019-01-14 00:00:00 +0300') }
    it { expect(subject.(hash2)[0][:custom_field]).to eq('2019-01-10 00:00:00 +0300') }
  end
end
