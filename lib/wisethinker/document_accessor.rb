module Wisethinker
  class DocumentAccessor
    extend Forwardable

    attr_reader :storage_accessor

    def initialize storage_accessor
      @storage_accessor = storage_accessor
    end

    def document(url_name: , type:)
      json = storage_accessor.find_by_type_and_url_name(type, url_name)
      puts "JSON: #{json}"
      json.nil? ? nil : Document.load(json)
    end

=begin
    def book_review name
      json = storage_accessor.find_by_type_and_url_name('book-review', name)
      json.nil? ? nil : BookReview.new(json)
    end

    def book_reviews opts = {}
      array = storage_accessor.find_all_by_type('book-review', opts)
      array.inject([]) do |values, hash|
        values << Document.load(hash)
      end
    end

    def article name
      json = storage_accessor.find_by_type_and_url_name('article', name)
      json.nil? ? nil : Article.new(json)
    end
=end

    def listing type, opts = {}
      array = storage_accessor.find_all_by_type type, opts
      array.inject([]) do |values, hash|
        values << Document.load(hash)
      end
    end

    def upsert_document document
      storage_accessor.upsert({type: document.type, url_name: document.url_name }, document.json_object_hash)
    end

  end
end
