# frozen_string_literal: true

class BlogPostSerializer
  include JSONAPI::Serializer

  belongs_to :user

  attributes :title, :body
end
