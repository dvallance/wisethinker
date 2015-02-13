require_relative '../spec_helper'

include Wisethinker

describe Wisethinker::StorageAccessor::Mongo do

  it 'has defined all required methods' do
    StorageAccessor::REQUIRED_METHODS.each do |method|
      StorageAccessor::Mongo.instance_methods(false).must_include method
    end
  end

  if ENV['TEST_MONGO_DB']

    Minitest.after_run do
      Wisethinker::StorageAccessor::Mongo.default_client.drop_database 'wisethinker_test'
      puts "Tests done and database removed"
    end

    subject { Wisethinker::StorageAccessor::Mongo.new(database: 'wisethinker_test', collection: 'testing_documents') }


    let(:book_review_json) {JSON.parse('{"type":"book-review","url_name":"book-review","date":"01-01-2015"}')}
    let(:another_book_review_json) {JSON.parse('{"type":"book-review","url_name":"another-book-review","date":"01-02-2015"}')}


    after do
      subject.collection.drop
      subject.collection.count.must_equal 0
    end

    it '#upsert_json' do
      subject.upsert_json({type: book_review_json['type'], url_name: book_review_json['url_name']}, book_review_json)
      subject.upsert_json({type: book_review_json['type'], url_name: book_review_json['url_name']}, book_review_json)
      subject.collection.count.must_equal 1
    end

    it '#find_by_type_and_url_name' do
      subject.upsert_json({type: book_review_json['type'], url_name: book_review_json['url_name']}, book_review_json)
      found = subject.find_by_type_and_url_name 'book-review', 'book-review'
      found['url_name'].must_equal book_review_json['url_name']
    end

    describe '#find_all_by_type' do

      before do
        #Adding 3 records. Two valid book-review and one arbitrary
        subject.upsert_json({type: another_book_review_json['type'], url_name: another_book_review_json['url_name']}, another_book_review_json)
        subject.upsert_json({type: 'unkown', url_name: 'unkown'}, {})
        subject.upsert_json({type: book_review_json['type'], url_name: book_review_json['url_name']}, book_review_json)
      end

      it 'has the correct number of book-review' do
        subject.find_all_by_type( 'book-review' ).count.must_equal 2
      end

      it 'the default order of decending is correct' do
        result = subject.find_all_by_type( 'book-review' )
        result.first['date'].must_be :>, result.last['date']
      end

      it 'we can supply an order correctly' do
        result = subject.find_all_by_type( 'book-review', direction:  :ascending )
        result.first['date'].must_be :<, result.last['date']
      end
    end
  end
end

