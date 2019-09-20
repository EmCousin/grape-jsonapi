# frozen_string_literal: true

class BlogPost
  include ActiveModel::Serialization

  attr_accessor :id, :title, :body

  def initialize(params = {})
    params.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def user_id
    nil
  end
end
