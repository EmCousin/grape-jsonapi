# frozen_string_literal: true

module Grape
  module Formatter
    module FastJsonapi
      include Grape::Formatter::Jsonapi

      class << self
        def call(object, env)
          warn "
            WARNING: Grape::Formatter::FastJsonapi is deprecated
            and will be removed on version 1.1
            Use Grape::Formatter::Jsonapi instead
          "

          super(object, env)
        end

        def deprecated?
          true
        end
      end
    end
  end
end
