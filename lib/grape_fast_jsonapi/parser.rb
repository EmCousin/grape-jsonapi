# frozen_string_literal: true

module GrapeSwagger
  module FastJsonapi
    class Parser
      attr_reader :model
      attr_reader :endpoint

      def initialize(model, endpoint)
        @model = model
        @endpoint = endpoint
      end

      def call
        schema = default_schema

        attributes_hash = if (defined? ActiveRecord)
                      map_model_attributes.symbolize_keys.merge(map_active_record_columns_to_attributes.symbolize_keys)
                    else
                      map_model_attributes.symbolize_keys
                    end

        attributes_hash.each do |attribute, type|
          schema[:data][:properties][:attributes][:properties][attribute] = { type: type }
          example_method = "#{type}_example"
          unless self.respond_to?(example_method, true)
            puts "WARN unexpected type encountered, missing #{example_method}  --use string example instead"
            example_method = "string_example"
          end
          schema[:data][:example][:attributes][attribute] = send example_method
        end

        relationships_hash = model.relationships_to_serialize || []

        # If relationship has :key set different than association name, it should be rendered under that key
        relationships_hash =
          relationships_hash.each_with_object({}) { |(_relationship_name, relationship), accu| accu[relationship.key] = relationship }

        relationships_hash.each do |model_type, relationship_data|
          relationships_attributes = relationship_data.instance_values.symbolize_keys
          schema[:data][:properties][:relationships][:properties][model_type] = {
            type: :object,
            properties: relationships_properties(relationships_attributes)
          }
          schema[:data][:example][:relationships][model_type] = relationships_example(relationships_attributes)
        end

        schema.deep_merge!(model.additional_schema) if model.respond_to? :additional_schema

        schema
      end

      private

      def default_schema
        {
          data: {
            type: :object,
            properties: {
              id: { type: :integer },
              type: { type: :string },
              attributes: default_schema_object,
              relationships: default_schema_object
            },
            example: {
              id: 1,
              type: model.record_type,
              attributes: {},
              relationships: {}
            }
          }
        }
      end

      def default_schema_object
        { type: :object, properties: {} }
      end

      def map_active_record_columns_to_attributes
        activerecord_model = model.record_type.to_s.camelize.safe_constantize
        return map_model_attributes unless activerecord_model && activerecord_model < ActiveRecord::Base

        columns = activerecord_model.columns.select do |c|
          model.attributes_to_serialize.keys.include?(c.name.to_sym)
        end

        attributes = {}
        columns.each do |column|
          attributes[column.name] = column.type
        end

        attributes
      end

      def map_model_attributes
        attributes = {}
        (model.attributes_to_serialize || []).each do |attribute, _|
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
        if relationship_data[:relationship_type] == :has_many
          {
            data: {
              type: :array,
              items: relationship_default_item
            }
          }
        else
          {
            data: relationship_default_item
          }
        end
      end

      def relationship_default_item
        {
          type: :object,
          properties: {
            id: { type: :integer },
            type: { type: :string }
          }
        }
      end

      def relationships_example(relationship_data)
        data = { id: 1, type: relationship_data[:record_type] }
        if relationship_data[:relationship_type] == :has_many
          { data: [data] }
        else
          { data: data }
        end
      end

      def integer_example
        if defined? Faker
          Faker::Number.number.to_i
        else
          rand(1..9999)
        end
      end

      def string_example
        if defined? Faker
          Faker::Lorem.word
        else
          "Example string"
        end
      end

      def text_example
        if defined? Faker
          Faker::Lorem.paragraph
        else
          "Example string"
        end
      end

      def citext_example
        text_example
      end

      def float_example
        rand() * rand(1..100)
      end

      def date_example
        Date.today.to_s
      end

      def datetime_example
        Time.current.to_s
      end
      alias :time_example :datetime_example

      def object_example
        if defined? Faker
          {
            string_example.parameterize.underscore.to_sym => string_example.parameterize.underscore.to_sym
          }
        else
          { example: :object }
        end
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
