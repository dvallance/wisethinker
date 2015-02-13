require_relative '../spec_helper'

include Wisethinker

describe StorageAccessor::Rethink do

  subject { StorageAccessor::Rethink.new(database: 'wisethinker_test', table: 'testing_documents', host: ENV['STORAGE_ACCESSOR_HOST'])}

  let(:book_review) do
    {"type" => "book-review", "url_name" => "my-book-review", "sections" => [{"title" => "My Book Review", "body" => "h1 My Book Review"}]}
  end

  let(:book_review_key) {{"type" => "book-review", "url_name" => "my-book-review"}}

  after do
    subject.connection do |conn|
      subject.table.delete.run(conn)
    end
  end

  describe '#upsert' do

    it 'will insert' do
      subject.upsert(book_review_key, book_review)
      subject.connection do |conn|
        subject.table.filter(url_name: 'my-book-review').run(conn).first["url_name"].must_equal('my-book-review')
      end
    end

    it 'will not result in duplicates' do
      subject.upsert(book_review_key, book_review)
      subject.upsert(book_review_key, book_review)
      subject.connection do |conn|
        subject.table.run(conn).to_a.count.must_equal 1
      end
    end

    it 'will properly update an existing document' do
      subject.upsert(book_review_key, book_review)
      subject.upsert(book_review_key, book_review.merge(added: true))
      subject.connection do |conn|
        subject.table.filter(url_name: 'my-book-review').run(conn).first["added"].must_equal(true)
      end
    end
  end

  describe '#find_by_type_and_url_name' do

    it 'finds a document' do
      subject.upsert(book_review_key, book_review)
      subject.find_by_type_and_url_name('book-review', 'my-book-review')['url_name'].must_equal('my-book-review')
    end

  end

  describe '#find_all_by_type' do

    it 'finds all documents of type' do
      subject.upsert({type: 'A', key: 'A1'}, {type: 'A', key: 'A1'})
      subject.upsert({type: 'B', key: 'B1'}, {type: 'B', key: 'B1'})
      subject.upsert({type: 'A', key: 'A2'}, {type: 'A', key: 'A2'})
      subject.upsert({type: 'B', key: 'B2'}, {type: 'B', key: 'B2'})
      subject.find_all_by_type(:A).count.must_equal(2)
      subject.find_all_by_type(:A).each do |doc|
        doc['type'].must_equal "A"
      end
    end
  end

  describe '#delete' do

    it 'deletes a document' do
      subject.upsert(book_review_key, book_review)
      another_book_review_key = {type: 'book-review', url_name: 'another-book-review'}
      subject.upsert(book_review_key, book_review_key.merge(data: true))
      subject.upsert(another_book_review_key, another_book_review_key.merge(data: true))

      subject.delete('book-review', 'my-book-review')
      subject.find_by_type_and_url_name('book-review', 'my-book-review').must_be_nil
      subject.find_by_type_and_url_name('book-review', 'another-book-review').wont_be_nil
    end

  end
end

#Lets clear out the test database after all tests are run.
Minitest.after_run do
  sa = StorageAccessor::Rethink.new(database: 'wisethinker_test', table: 'testing_documents', host: ENV['STORAGE_ACCESSOR_HOST'])
  sa.drop_database
end
