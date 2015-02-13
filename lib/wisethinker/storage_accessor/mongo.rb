require 'mongo'

module Wisethinker
  module StorageAccessor
    class Mongo

      extend Forwardable

      attr_reader :client
      def_delegator :@collection, :remove, :empty

      def initialize database: 'wisethinker', collection: 'documents', host: 'localhost', port: ::MongoClient::DEFAULT_PORT
        @client = ::Mongo::MongoClient.new(host: host, port: port)
        @db = client.db(database)
        @collection = @db.collection(collection)
      end

      def find_by_type_and_url_name type, url_name
        @collection.find_one(type: type, url_name: url_name)
      end

      def find_all_by_type type, direction: :descending
        type = Array(type)
        @collection.find(type: { :$in => type}).sort(date: direction).to_a
      end

      def delete query
        @collection.remove query
      end

      def upsert query, json
        @collection.update(query, json, {upsert: true, w: 1})
      end

    end
  end
end
