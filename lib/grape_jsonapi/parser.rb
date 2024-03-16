# frozen_string_literal: true

module GrapeSwagger
  module Jsonapi
    class Parser
      attr_reader :model, :endpoint

      def initialize(model, endpoint)
        @model = model
        @endpoint = endpoint
      end

      def call
        schema = default_schema
        schema = enrich_with_attributes(schema)
        schema = enrich_with_relationships(schema)
        schema.deep_merge!(model.additional_schema) if model.respond_to?(:additional_schema)

        schema
      end

      private

      def default_schema
        { data: {
          type: :object,
          properties: default_schema_propeties,
          example: {
            id: 1,
            type: model.record_type,
            attributes: {},
            relationships: {}
          }
        } }
      end

      def default_schema_propeties
        { id: { type: :integer },
          type: { type: :string },
          attributes: default_schema_object,
          relationships: default_schema_object }
      end

      def default_schema_object
        { type: :object, properties: {} }
      end

      def enrich_with_attributes(schema)
        attributes_hash.each do |attribute, type|
          schema[:data][:properties][:attributes][:properties][attribute] = { type: type }
          example_method = "#{type}_example"
          unless respond_to?(example_method, true)
            puts "WARN unexpected type encountered, missing #{example_method}  --use string example instead"
            example_method = 'string_example'
          end
          schema[:data][:example][:attributes][attribute] = send(example_method)
        end

        schema
      end

      def attributes_hash
        return map_model_attributes.symbolize_keys unless defined?(ActiveRecord)

        map_model_attributes.symbolize_keys.merge(
          map_active_record_columns_to_attributes.symbolize_keys
        )
      end

      def enrich_with_relationships(schema)
        relationships_hash.each do |model_type, relationship_data|
          relationships_attributes = relationship_data.instance_values.symbolize_keys
          schema[:data][:properties][:relationships][:properties][model_type] = {
            type: :object,
            properties: relationships_properties(relationships_attributes)
          }
          schema[:data][:example][:relationships][model_type] = relationships_example(relationships_attributes)
        end

        schema
      end

      def relationships_hash
        hash = model.relationships_to_serialize || []

        # If relationship has :key set different than association name, it should be rendered under that key

        hash.each_with_object({}) do |(_relationship_name, relationship), accu|
          accu[relationship.key] = relationship
        end
      end

      def map_active_record_columns_to_attributes
        return map_model_attributes unless activerecord_model && activerecord_model < ActiveRecord::Base

        activerecord_model.columns.each_with_object({}) do |column, attributes|
          next unless model.attributes_to_serialize.key?(column.name.to_sym)

          attributes[column.name] = column.type
        end
      end

      def activerecord_model
        model.record_type.to_s.camelize.safe_constantize
      end

      def map_model_attributes
        attributes = {}
        (model.attributes_to_serialize || []).each do |attribute, _| # rubocop:disable Style/HashEachMethods
          attributes[attribute] =
            if model.respond_to? :attribute_types
              model.attribute_types[attribute] || :string
            else
              :string
            end
        end
        attributes
      end

      def relationships_properties(relationship_data)
        return { data: RELATIONSHIP_DEFAULT_ITEM } unless relationship_data[:relationship_type] == :has_many

        { data: {
          type: :array,
          items: RELATIONSHIP_DEFAULT_ITEM
        } }
      end

      RELATIONSHIP_DEFAULT_ITEM = {
        type: :object,
        properties: {
          id: { type: :integer },
          type: { type: :string }
        }
      }.freeze

      def relationships_example(relationship_data)
        data = {
          id: 1,
          type: relationship_data[:record_type] ||
                relationship_data[:static_record_type] ||
                relationship_data[:object_method_name]
        }

        data = [data] if relationship_data[:relationship_type] == :has_many

        { data: data }
      end

      def integer_example
        defined?(Faker) ? Faker::Number.number.to_i : rand(1..9999)
      end

      def string_example
        defined?(Faker) ? Faker::Lorem.word : 'Example string'
      end

      def text_example
        defined?(Faker) ? Faker::Lorem.paragraph : 'Example string'
      end
      alias citext_example text_example

      def float_example
        rand * rand(1..100)
      end

      def date_example
        Date.today.to_s
      end

      def datetime_example
        Time.current.to_s
      end
      alias time_example datetime_example

      def object_example
        return { example: :object } unless defined?(Faker)

        { string_example.parameterize.underscore.to_sym => string_example.parameterize.underscore.to_sym }
      end

      def array_example
        [string_example]
      end

      def boolean_example
        [true, false].sample
      end

      def uuid_example
        SecureRandom.uuid
      end
    end
  end
end
