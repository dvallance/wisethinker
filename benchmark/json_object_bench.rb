require_relative '../spec/spec_helper'
require 'benchmark/ips'

json = SpecHelper.json_from_file('test/documents/docker.json')

book_review = Wisethinker::Documents::BookReview.new(json)

Benchmark.ips do |x|

  x.report("no caching") do
    book_review.sections[0].title
  end

  x.report("with caching") do
    book_review.sections[0].title
  end

  x.compare!

end

