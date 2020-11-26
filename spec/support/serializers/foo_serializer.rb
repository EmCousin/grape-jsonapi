# frozen_string_literal: true

class FooSerializer
  include JSONAPI::Serializer

  belongs_to :bar, key: :foo_bar
  has_one :fizz, key: :foo_fizz
  has_many :buzzes, key: :foo_buzzes

  attribute :xyz

  def self.additional_schema
    {
      data: {
        example: {
          attributes: {
            xyz: 'foobar'
          }
        }
      }
    }
  end
end
