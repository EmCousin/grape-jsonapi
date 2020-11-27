# frozen_string_literal: true

require 'active_record'

class DbRecordSerializer
  include JSONAPI::Serializer

  attributes(
    :string_attribute,
    :uuid_attribute,
    :integer_attribute,
    :text_attribute,
    :datetime_attribute,
    :date_attribute,
    :boolean_attribute,
    :array_attribute
  )
end
