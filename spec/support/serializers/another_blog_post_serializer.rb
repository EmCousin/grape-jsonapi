# frozen_string_literal: true

class AnotherBlogPostSerializer
  include FastJsonapi::ObjectSerializer

  set_type :blog_post

  belongs_to :user
end
