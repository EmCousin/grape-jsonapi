# frozen_string_literal: true

module Grape
  module EndpointExtension
    def render(resources, options = {})
      env['fast_jsonapi_options'] = options
      resources
    end
  end

  Endpoint.send(:include, EndpointExtension)
end
