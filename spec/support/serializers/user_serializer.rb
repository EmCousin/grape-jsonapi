# frozen_string_literal: true

class UserSerializer
  include FastJsonapi::ObjectSerializer

  has_many :blog_posts

  attributes :first_name, :last_name, :email
end
