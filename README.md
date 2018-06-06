# Grape::FastJsonapi

Use [fast_jsonapi](https://github.com/Netflix/fast_jsonapi) with [Grape](https://github.com/ruby-grape/grape).

## Installation

Add the `grape` and `grape_fast_jsonapi` gems to Gemfile.

```ruby
gem 'grape'
gem 'grape_fast_jsonapi'
```

## Usage

### Require grape_fast_jsonapi

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

## Credit

Code adapted from [grape-jsonapi-resources](https://github.com/cdunn/grape-jsonapi-resources)
