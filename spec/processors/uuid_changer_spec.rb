require 'spec_helper'

RSpec.describe Separatum::Processors::UuidChanger do
  let(:hash1) { { a: 1, b: 'g534gq23g', c: '2874ab2d-5617-4ddd-bb69-0325d8f75be5' } }
  let(:hash2) { { a: '0a6a51fa-5f4f-467a-939b-ffe90f8373ab', b: '2874ab2d-5617-4ddd-bb69-0325d8f75be5' } }

  describe '#transform' do
    it { expect(subject.transform(hash1)[:a]).to eq hash1[:a] }
    it { expect(subject.transform(hash1)[:b]).to eq hash1[:b] }
    it { expect(subject.transform(hash1)[:c]).to_not eq hash1[:c] }
  end

  describe '#call' do
    subject { described_class.new.([hash1, hash2]) }
    it { expect(subject[0][:c]).to eq subject[1][:b] }
    it { expect(subject[0][:c]).to_not eq subject[1][:a] }
  end
end
