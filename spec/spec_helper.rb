# frozen_string_literal: true

require 'active_model'
require 'grape_jsonapi'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }
