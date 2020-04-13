# frozen_string_literal: true

module Barman
  module Stage
    class Base
      attr_reader :name, :block, :deps, :targets

      def initialize(name = nil, &block)
        unless block_given?
          raise ArgumentError, "#{self.class} requires a block"
        end

        @name = name
        @block = block

        @deps = []
        @targets = []
      end

      def run(*args)
        block.call(*args)
      end

      def result
        inputs = @deps.map(&:result)

        run(*inputs)
      end

      def depend_on(*stages)
        @deps.concat(stages).uniq!

        stages.each { |s| s.provide_to(self) }
      end

      protected

      def provide_to(*stages)
        @targets.concat(stages).uniq!
      end
    end
  end
end
