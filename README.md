[![CircleCI](https://circleci.com/gh/EmCousin/grape-jsonapi/tree/master.svg?style=svg)](https://circleci.com/gh/EmCousin/grape-jsonapi/tree/master)

# Grape::Jsonapi

Use [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer) with [Grape](https://github.com/ruby-grape/grape).

## Installation

Add `grape-jsonapi` to your Gemfile.

```ruby
gem 'grape-jsonapi', require: "grape_jsonapi"
```

## Usage

### Tell your API to use Grape::Formatter::Jsonapi

```ruby
class API < Grape::API
  content_type :jsonapi, "application/vnd.api+json"
  formatter :json, Grape::Formatter::Jsonapi
  formatter :jsonapi, Grape::Formatter::Jsonapi
end
```

### Use `render` to specify JSONAPI options

```ruby
get "/" do
  user = User.find("123")
  render user, include: [:account]
end
```

### Use a custom serializer

```ruby
get "/" do
  user = User.find("123")
  render user, serializer: 'CustomUserSerializer'
end
```

Or

```ruby
get "/" do
  user = User.find("123")
  render CustomUserSerializer.new(user).serialized_json
end
```

### Override `meta`and `links` properties

`meta` and `links` properties are usually defined per resource within your serializer ([here](https://github.com/jsonapi-serializer/jsonapi-serializer#meta-per-resource) and [here](https://github.com/jsonapi-serializer/jsonapi-serializer#links-per-object))

However, you may need to override those properties by passing them as option when rendering your response:
```ruby
user = User.find("123")
render user, meta: { pagination: { page: 1, total: 42 } }, links: { self: 'https://my-awesome.app.com/users/1' }
```

### Model parser for response documentation

When using Grape with Swagger via [grape-swagger](https://github.com/ruby-grape/grape-swagger), you can generate response documentation automatically via the provided following model parser:

```ruby
# FastJsonapi serializer example

# app/serializers/base_serializer.rb
class BaseSerializer; end
# app/serializers/user_serializer.rb
class UserSerializer < BaseSerializer
  include JSONAPI::Serializer

  set_type :user
  has_many :orders

  attributes :name, :email
end

# config/initializers/grape_swagger.rb
GrapeSwagger.model_parsers.register(GrapeSwagger::Jsonapi::Parser, BaseSerializer)

# Your grape API endpoint
desc 'Get current user' do
  success code: 200, model: UserSerializer, message: 'The current user'
# [...]
end
```

Note that you **need** the `grape-swagger` gem for this to work, otherwise it will throw an error.

## Credit

Code adapted from [grape-jsonapi-resources](https://github.com/cdunn/grape-jsonapi-resources)
