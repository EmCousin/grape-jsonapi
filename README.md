# Grape::FastJsonapi

Use [fast_jsonapi](https://github.com/Netflix/fast_jsonapi) with [Grape](https://github.com/ruby-grape/grape).

## Installation

Add the `grape` and `grape_fast_jsonapi` gems to Gemfile.

```ruby
gem 'grape'
gem 'grape_fast_jsonapi'
```

## Usage

### Tell your API to use Grape::Formatter::FastJsonapi

```ruby
class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::FastJsonapi
end
```

### Use `render` to specify JSONAPI options

```ruby
get "/" do
  user = User.find("123")
  render user, include: [:account]
end
```

### Model parser for response documentation

When using Grape with Swagger via [grape-swagger](https://github.com/ruby-grape/grape-swagger), you can generate response documentation automatically via the provided following model parser:

```ruby
# FastJsonapi serializer example

# app/serializers/base_serializer.rb
class BaseSerializer; end
# app/serializers/user_serializer.rb
class UserSerializer < BaseSerializer
  include FastJsonapi::ObjectSerializer

  set_type :user
  has_many :orders

  attributes :name, :email
end

# config/initializers/grape_swagger.rb
GrapeSwagger.model_parsers.register(GrapeSwagger::FastJsonapi::Parser, BaseSerializer)

# Your grape API endpoint
desc 'Get current user' do
  success code: 200, model: UserSerializer, message: 'The current user'
# [...]
```

Note that you **need** the `grape-swagger` gem for this to work, otherwise it will throw an error.

## Credit

Code adapted from [grape-jsonapi-resources](https://github.com/cdunn/grape-jsonapi-resources)
