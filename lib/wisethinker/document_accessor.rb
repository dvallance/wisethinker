module Wisethinker
  class DocumentAccessor
    extend Forwardable

    attr_reader :storage_accessor

    def initialize storage_accessor
      @storage_accessor = storage_accessor
    end

    def document(url_name: , type:)
      json = storage_accessor.find_by_type_and_url_name(type, url_name)
      json.nil? ? nil : Document.load(json)
    end

    def listing type, opts = {}
      array = storage_accessor.find_all_by_type type, opts
      array.inject([]) do |values, hash|
        values << Document.load(hash)
      end
    end

    def upsert_document document
      storage_accessor.upsert({type: document.type, url_name: document.url_name }, document.json_hash)
    end

  end
end
