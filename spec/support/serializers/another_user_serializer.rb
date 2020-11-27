# frozen_string_literal: true

class AnotherUserSerializer
  include JSONAPI::Serializer

  attributes :email
end
