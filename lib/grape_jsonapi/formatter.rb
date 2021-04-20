# frozen_string_literal: true

module Grape
  module Formatter
    module Jsonapi
      class << self
        def call(object, env)
          return object if object.is_a?(String)
          return ::Grape::Json.dump(serialize(object, env)) if serializable?(object)
          return object.to_json if object.respond_to?(:to_json)

          ::Grape::Json.dump(object)
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
          elsif object.is_a?(Hash)
            serialize_each_pair(object, env)
          elsif serializable_collection?(object)
            serializable_collection(object, jsonapi_options(env))
          else
            object
          end
        end

        def serializable_collection?(object)
          object.respond_to?(:to_a) && object.all? do |o|
            o.respond_to?(:serializable_hash)
          end
        end

        def serializable_object(object, options)
          jsonapi_serializable(object, options) || object
        end

        def jsonapi_serializable(object, options)
          serializable_class(object, options)&.new(object, options)
        end

        def serializable_collection(collection, options)
          if heterogeneous_collection?(collection)
            collection.map do |o|
              serialize_resource(o, options)
            end
          else
            serialize_resource(collection, options)
          end
        end

        def heterogeneous_collection?(collection)
          collection.map { |item| item.class.name }.uniq.many?
        end

        def serialize_resource(resource, options)
          jsonapi_serializable(resource, options)&.serializable_hash || resource.map(&:serializable_hash)
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
          h = {}
          object.each_pair { |k, v| h[k] = serialize(v, env) }
          h
        end

        def jsonapi_options(env)
          env['jsonapi_serializer_options'] || {}
        end
      end
    end
  end
end
