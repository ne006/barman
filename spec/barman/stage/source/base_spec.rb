# frozen_string_literal: true

require 'barman/stage/source/base'

RSpec.describe Barman::Stage::Source::Base do
  subject { described_class.new(:src) { [1, 2, 3] } }

  describe '#depend_on' do
    let(:dep) { Barman::Stage::Base.new(:stg) { 'stage' } }

    it 'raises ArgumentError' do
      expect { subject.depend_on(dep) }.to raise_error(ArgumentError)
    end
  end
end
