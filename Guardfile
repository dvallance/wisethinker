guard :minitest do
  watch(%r{^spec/(.*)_spec.rb$})
  watch(%r{^lib/(.+).rb$})         { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/spec_helper.rb$}) { 'spec' }
  watch(%r{^lib/*}) {'spec'}
end

module ::Guard

  class Documents < Plugin

    def run_all
      %x(bundle exec rake documents:upsert_dir[#{Dir.pwd}/documents])
    end

    def run_on_modifications(paths)
      %x(bundle exec rake documents:upsert[#{paths.first}])
    end
  end
end

guard :documents do
  watch(%r{documents/.+\.(yaml|json)})
end
