# frozen_string_literal: true
require 'active_record'

class DbRecord < ActiveRecord::Base
  def self.columns
    [
      # adhering to the ActiveRecord::ConnectionAdapters::Column contract
      OpenStruct.new(name: 'id', sql_type: 'integer', type: :integer),
      OpenStruct.new(name: 'string_attribute', sql_type: 'character varying(255)', type: :string),
      OpenStruct.new(name: 'uuid_attribute', sql_type: 'uuid', type: :uuid),
      OpenStruct.new(name: 'integer_attribute', sql_type: 'integer', type: :integer),
      OpenStruct.new(name: 'text_attribute', sql_type: 'text', type: :text),
      OpenStruct.new(name: 'datetime_attribute', sql_type: 'timestamp without time zone', type: :datetime),
      OpenStruct.new(name: 'date_attribute', sql_type: 'date', type: :date),
      OpenStruct.new(name: 'boolean_attribute', sql_type: 'boolean', type: :boolean),
      OpenStruct.new(name: 'array_attribute', sql_type: 'integer[]', type: :array)
    ]
  end
end
