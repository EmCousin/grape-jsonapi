# frozen_string_literal: true

module Grape
  module Formatter
    module FastJsonapi
      class << self
        def call(object, env)
          return object if object.is_a?(String)
          return ::Grape::Json.dump(serialize(object, env)) if serializable?(object)
          return object.to_json if object.respond_to?(:to_json)
          ::Grape::Json.dump(object)
        end

        private

        def serializable?(object)
          object.respond_to?(:serializable_hash) || object.respond_to?(:to_a) && object.all? { |o| o.respond_to? :serializable_hash } || object.is_a?(Hash)
        end

        def serialize(object, env)
          if object.respond_to? :serializable_hash
            serializable_object(object, fast_jsonapi_options(env)).serializable_hash
          elsif object.respond_to?(:to_a) && object.all? { |o| o.respond_to? :serializable_hash }
            fast_jsonapi_serializable(object, fast_jsonapi_options(env)).serializable_hash || object.map(&:serializable_hash)
          elsif object.is_a?(Hash)
            serialize_each_pair(object, env)
          else
            object
          end
        end

        def serializable_object(object, options)
          fast_jsonapi_serializable(object, options) || object
        end

        def fast_jsonapi_serializable(object, options)
          serializable_class(object)&.new(object, options)
        end

        def serializable_class(object)
          (object.model_name.name + 'Serializer').safe_constantize
        end

        def serialize_each_pair(object, env)
          h = {}
          object.each_pair { |k, v| h[k] = serialize(v, env) }
          h
        end

        def fast_jsonapi_options(env)
          env['fast_jsonapi_options'] || {}
        end
      end
    end
  end
end
