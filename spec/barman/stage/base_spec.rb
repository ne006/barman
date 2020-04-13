# frozen_string_literal: true

require 'barman/stage/base'

RSpec.describe Barman::Stage::Base do
  subject { described_class.new(:five) { '5' } }

  describe '#new' do
    it 'assigns passed block' do
      expect(subject.block).not_to be_nil
    end

    context 'without block' do
      subject { described_class.new }

      it 'raises ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    it 'assigns passed name' do
      expect(subject.name).to eq(:five)
    end
  end

  describe '#depend_on' do
    let(:one) { described_class.new(:one) { 'one' } }
    let(:two) { described_class.new(:two) { 'two' } }

    before(:each) { subject.depend_on(one, two) }

    it 'adds passed stages to dependencies' do
      expect(subject.deps).to include(one)
      expect(subject.deps).to include(two)
    end

    it 'adds self to targets of passed stages' do
      expect(one.targets).to include(subject)
      expect(two.targets).to include(subject)
    end
  end

  describe 'run' do
    let(:args) { [1, Object.new, 'three', :four] }

    it 'runs the block' do
      expect(subject.block).to receive(:call).with(*args)

      subject.run(*args)
    end
  end

  describe 'result' do
    it 'calls run' do
      expect(subject).to receive(:run)

      subject.result
    end

    context 'with dependencies' do
      let(:one) { described_class.new(:one) { 'one' } }
      let(:two) { described_class.new(:two) { 'two' } }

      before(:each) { subject.depend_on(one, two) }

      it 'requests the dependencies\' result' do
        subject.deps.each do |dep|
          expect(dep).to receive(:result)
        end

        subject.result
      end

      it 'calls run with dependencies\' result' do
        expect(subject).to receive(:run).with('one', 'two')

        subject.result
      end
    end
  end
end
