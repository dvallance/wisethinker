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
      class_from_type(json['type']).create(json)
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
    value_accessors :title
    value_accessor :body
    value_accessor :body, name: :rendered_body, proc: Proc.new {|json_object,value|
      json_object.render json_object.parent.template_engine, value
    }
  end

  class Update < Document
    value_accessors :date,[:body, name: :rendered_body,  proc: Proc.new {|json_object,value| json_object.render json_object.parent.template_engine, value}]
  end

  class Article < Document
    value_accessors :type,:url_name,:title,:date,[:by, default: 'David Vallance'],:author,[:template_engine, default: "markdown"],[:code_examples, default: false]
    object_accessor :update, class: Update
    object_accessor :sections, class: Section
  end

  class BookReview < Article
    value_accessors :author
  end

end
