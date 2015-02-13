require_relative 'spec_helper'

include Wisethinker

#    book_review = Wisethinker::BookReview.new(JSON.parse(File.read('test/documents/docker.json')))

describe DocumentAccessor do
=begin

  describe "#book_review" do

    it "returns nil if the document can't be found" do
      mock = MiniTest::Mock.new.expect(:find_by_type_and_url_name, nil, [String, String])
      document_accessor = DocumentAccessor.new(mock)
      retrieved = document_accessor.book_review('my-first-book-review')
      retrieved.must_be_nil
      mock.verify
    end

    it "#book_review finds and returns a document" do
      mock = MiniTest::Mock.new.expect(:find_by_type_and_url_name, SpecHelper.json_from_file('test/documents/book-review.json'), [String, String])
      document_accessor = DocumentAccessor.new(mock)
      retrieved = document_accessor.book_review('my-first-book-review')
      retrieved.must_be_instance_of BookReview
      mock.verify
    end

  end

  describe '#upsert' do

    it 'properly wraps the upsert_json' do
      document = BookReview.new(SpecHelper.json_from_file('test/documents/book-review.json'))
      mock = MiniTest::Mock.new.expect(:upsert_json, true, [{type: document.type, url_name: document.url_name }, document.json_object_hash])
      document_accessor = DocumentAccessor.new(mock)
      document_accessor.upsert_document document
      mock.verify
    end

  end

  describe '#book-reviews' do

    let :mock do
      book_review = {"type"=>"book-review", "url_name"=>"another-book-review", "date"=>"01-02-2015"}
      another_book_review = {"type"=>"book-review", "url_name"=>"book-review", "date"=>"01-01-2015"}
      MiniTest::Mock.new.expect(:find_all_by_type, [book_review, another_book_review], ['book-review', direction: :ascending])

    end

    it 'properly wraps find_all_by_type' do
      document_accessor = DocumentAccessor.new(mock)
      document_accessor.book_reviews direction: :ascending
      mock.verify
    end
    it 'has book review objects' do
      document_accessor = DocumentAccessor.new(mock)
      result = document_accessor.book_reviews direction: :ascending
      result.must_be_instance_of Array
      result.first.must_be_instance_of BookReview
      result.last.must_be_instance_of BookReview
    end
  end

=end
end
