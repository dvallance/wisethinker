require 'json_object'
require "wisethinker/version"
require 'wisethinker/document'
require 'wisethinker/storage_accessor/storage_accessor'
require 'wisethinker/storage_accessor/mongo'
require 'wisethinker/storage_accessor/rethink'
require 'wisethinker/document_accessor'
require 'date'
require 'redcarpet'

environment = ENV['RACK_ENV']
if environment == 'development' || environment == 'test'
  require 'byebug'
end
