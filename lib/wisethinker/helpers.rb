module Wisethinker
  module Helpers

    def formatted_date date
      Date.parse(date).strftime("%B %e, %Y")
    end

    def titleize str
      str.split("-").collect(&:capitalize).join(" ")
    end

    def disqus_identifier document
      #handling my identifer one-offs
      case document.url_name
      when'installing-an-operating-system-on-a-zotac-nano-ad10'
        "/blog/installing-an-operating-system-on-a-zotac-nano-ad10"
      else
        "#{document.type}_#{document.url_name}"
      end
    end

    def disqus_config document
      <<-STR.gsub /^\s+/, ''
        var disqus_shortname = 'davidvallance'
        var disqus_identifier = '#{disqus_identifier(document)}';
        var disqus_title = '#{document.title.gsub("'",'')}';
        #{"var disqus_url  = '" + request.url.split("?").first + "';" unless settings.development?}
      STR
    end
  end
end
