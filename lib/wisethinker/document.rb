module Wisethinker

  class Document < JsonObject::Base

    def self.class_from_type type
      klass_name = type.split("-").map{|str| str.capitalize}.join
      begin
          Object.const_get(json_hash['type'])
      rescue
          #default to Article if the type doesn't have a defined class
          Article
      end
    end

    def self.load json
      class_from_type(json['type']).init_from_json_hash(json)
    end

    def markdown_renderer
      return @markdown_renderer if defined? @markdown_renderer
      @markdown_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    end

    def render template_engine, value
      case template_engine.to_s
      when "markdown"
        markdown_renderer.render(value)
      when "textile"
        #TODO
      else
        value
      end
    end
  end

  class Section < Document
    json_value_accessors :title
    json_value_accessor :body
    json_value_accessor :body, name: :rendered_body, proc: Proc.new {|json_object,value|
      json_object.render json_object.json_parent.template_engine, value
    }
  end

  class Update < Document
    json_value_accessors :date,[:body, name: :rendered_body,  proc: Proc.new {|json_object,value| json_object.render json_object.json_parent.template_engine, value}]
  end

  class Article < Document
    json_value_accessors :type,:url_name,:title,:date,[:by, default: 'David Vallance'],:author,[:template_engine, default: "markdown"],[:code_examples, default: false]
    json_object_accessor :update, class: Update
    json_object_accessor :sections, class: Section
  end

  class BookReview < Article
    json_value_accessors :author
  end

end
