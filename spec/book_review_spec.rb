require_relative 'spec_helper'

include Wisethinker

describe BookReview do

  subject { Document.load(SpecHelper.json_from_file('test/documents/book-review.json')) }

  it 'correctly loads a book_review from our test json' do
    subject.type.must_equal "book-review"
    subject.title.must_equal "My Fake Book"
    subject.author.must_equal "John Smith"
    subject.by.must_equal "Dave Vallance"
    subject.date.must_equal "2015-01-01"
    subject.template_engine.must_equal "markdown"
    subject.update.date.must_equal "01-05-2015"
    subject.sections.first.title.must_equal "Content"
    subject.sections.first.body.must_match /First Sentence\W*Second Sentence/m

    subject.sections.last.title.must_equal "Target Audience"
    subject.sections.last.body.must_match /First Sentence\W*Second Sentence/m

    subject.sections.first.rendered_body.must_match /<p>First Sentence<\/p>\W*<p>Second Sentence<\/p>/m
    #subject.sections.first.rendered_body.must_equal "<p>First Sentence</p>\n\n<p>Second Sentence</p>"
  end

  it "has render" do
    #puts subject.sections.first.rendered_body
  end


end
