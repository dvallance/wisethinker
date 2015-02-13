require "bundler/gem_tasks"
require 'wisethinker'
require 'wisethinker/config/config'
require 'yaml'
require 'rake/testtask'

module RakeHelper
  def self.load_json path
    case File.extname(path)
    when '.yaml'
      YAML.load_file(path)
    when '.json'
      JSON.parse(File.read(path))
    else
      raise 'Unkown file type.'
    end
  end
end

Rake::TestTask.new do |t|
    t.pattern = "spec/**/*_spec.rb"
end

namespace :documents do
  desc 'When given a path to a json file the contents will be loaded into the configured DOCUMENT_ACCESSOR store.'
  task :upsert, [:path] do |task, args|
    Wisethinker::Config::DOCUMENT_ACCESSOR.upsert_document(Wisethinker::Document.load(RakeHelper.load_json args[:path]))
  end

  desc 'When given a dir path, any yaml or json files will be loaded into the configured DOCUMENT_ACCESSOR store.'
  task :upsert_dir, [:path] do |task, args|
    puts "Loading json from files..."
    Dir.glob("#{args[:path]}/**/*.{yaml,json}").each do |path|
      file = File.absolute_path(path)
      puts file
      Wisethinker::Config::DOCUMENT_ACCESSOR.upsert_document(Wisethinker::Document.load(RakeHelper.load_json(file)))
    end
  end
end
