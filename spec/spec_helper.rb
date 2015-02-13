ENV['RACK_ENV'] = 'test'
require_relative '../lib/wisethinker'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/benchmark'
require 'json'

class SpecHelper
  class << self
    def json_from_file file_name
      JSON.parse(File.read(file_name))
    end
  end

end
