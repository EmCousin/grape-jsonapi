# frozen_string_literal: true

class Foo
  include ActiveModel::Serialization

  attr_accessor :id, :bar_id

  # belongs_to :bar
  # has_one :fizz
  # has_many :buzzes

  def initialize(params = {})
    params.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def attributes
    {
      'id' => nil,
      'bar_id' => nil
    }
  end

  def buzz_ids
    []
  end
end
