# frozen_string_literal: true

require 'barman/stage/base'

module Barman
  module Stage
    module Source
      class Base < Stage::Base
        def depend_on(*_stages)
          raise ArgumentError, "#{self.class} can't have dependencies"
        end
      end
    end
  end
end
