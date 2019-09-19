# frozen_string_literal: true

class AnotherUserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :email
end
