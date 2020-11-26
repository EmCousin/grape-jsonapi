# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  has_many :blog_posts

  attributes :first_name, :last_name, :email
end
