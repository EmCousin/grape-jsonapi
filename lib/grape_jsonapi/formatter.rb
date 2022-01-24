# frozen_string_literal: true

module Grape
  module Formatter
    module Jsonapi
      class << self
        def call(object, env)
          response = serializable?(object) ? serialize(object, env) : { data: object }
          ::Grape::Json.dump(
            response.merge(env.slice('meta', 'links'))
          )
        end

        private

        def serializable?(object)
          return false if object.nil?
          return true if object.respond_to?(:serializable_hash)
          return true if object.is_a?(Hash)

          serializable_collection?(object)
        end

        def serialize(object, env)
          if object.respond_to?(:serializable_hash)
            serializable_object(object, jsonapi_options(env)).serializable_hash
          elsif serializable_collection?(object)
            serializable_collection(object, env)
          elsif object.is_a?(Hash)
            serialize_each_pair(object, env)
          else
            object
          end
        end

        def serializable_collection?(object)
          object.respond_to?(:to_a) && object.any? && object.all? do |o|
            o.respond_to?(:serializable_hash)
          end
        end

        def serializable_object(object, options)
          jsonapi_serializable(object, options) || object
        end

        def jsonapi_serializable(object, options)
          serializable_class(object, options)&.new(object, options)
        end

        def serializable_collection(collection, env)
          if heterogeneous_collection?(collection)
            collection.each_with_object({ data: [] }) do |o, hash|
              hash[:data].push(serialize_resource(o, env)[:data])
            end
          else
            serialize_resource(collection, env)
          end
        end

        def heterogeneous_collection?(collection)
          collection.map { |item| item.class.name }.uniq.many?
        end

        def serialize_resource(resource, env)
          jsonapi_serializable(resource, jsonapi_options(env))&.serializable_hash || resource.map do |item|
            serialize(item, env)
          end
        end

        def serializable_class(object, options)
          klass_name = options['serializer'] || options[:serializer]
          klass_name ||= begin
            object = object.first if object.is_a?(Array)

            "#{(object.try(:model_name) || object.class).name}Serializer"
          end

          klass_name&.safe_constantize
        end

        def serialize_each_pair(object, env)
          h = { data: {} }
          object.each_pair do |k, v|
            serialized_value = serialize(v, env)
            h[:data][k] = if serialized_value.is_a?(Hash) && serialized_value[:data]
                            serialized_value[:data]
                          else
                            serialized_value
                          end
          end
          h
        end

        def jsonapi_options(env)
          env['jsonapi_serializer_options'] || {}
        end
      end
    end
  end
end
