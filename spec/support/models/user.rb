# frozen_string_literal: true

class User
  extend ActiveModel::Naming
  include ActiveModel::Serialization

  attr_accessor :id, :first_name, :last_name, :password, :email

  def initialize(params = {})
    params.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def attributes
    {
      'id' => nil,
      'first_name' => nil,
      'last_name' => nil,
      'password' => nil,
      'email' => nil
    }
  end

  def blog_post_ids
    []
  end
end
