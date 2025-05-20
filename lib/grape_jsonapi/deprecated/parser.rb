# frozen_string_literal: true

module GrapeSwagger
  module FastJsonapi
    class Parser < GrapeSwagger::Jsonapi::Parser
      def initialize(model, endpoint)
        warn "
          WARNING: Grape::FastJsonapi::Parser is deprecated
          and will be removed on version 1.1
          Use Grape::Jsonapi::Parser instead
        "

        super
      end

      def self.deprecated?
        true
      end
    end
  end
end
