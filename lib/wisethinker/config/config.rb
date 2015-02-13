module Wisethinker
  module Config

    storage_accessor_host = ENV['STORAGE_ACCESSOR_HOST']

    #Currently I have no plans to deviate from the default ports
    #storage_accessor_port = ENV['STORAGE_ACCESSOR_PORT']

    #I use docker containers even in development so I have no safe 'localhost'
    #fallback. Always demand a host!
    raise "Need to set environment variable [STORAGE_ACCESSOR_HOST]" unless ENV['STORAGE_ACCESSOR_HOST']


    case ENV['RACK_ENV']
    when 'production'

    when 'development'

    when 'test'

    end


    DOCUMENT_ACCESSOR = DocumentAccessor.new(
      StorageAccessor::Rethink.new(host: storage_accessor_host)
      #StorageAccessor::Mongo.new(host: storage_accessor_host)
    )

  end
end
