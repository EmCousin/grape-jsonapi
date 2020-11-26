# frozen_string_literal: true

module Grape
  module EndpointExtension
    def render(resources, options = {})
      env['jsonapi_serializer_options'] = options
      resources
    end
  end

  Endpoint.include EndpointExtension
end
