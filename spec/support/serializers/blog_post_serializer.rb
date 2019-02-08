# frozen_string_literal: true

class BlogPostSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :user

  attributes :title, :body
end
