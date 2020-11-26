# frozen_string_literal: true

class AnotherBlogPostSerializer
  include JSONAPI::Serializer

  set_type :blog_post

  belongs_to :user
end
