# frozen_string_literal: true

RSpec.describe Rdown do
  describe '.parse' do
    subject do
      described_class.parse(source)
    end

    let(:source) do
      <<~RD
        = class Array < Object
      RD
    end

    it 'returns a Rdown::Nodes::Base' do
      is_expected.to be_a(Rdown::Nodes::Base)
    end
  end
end
