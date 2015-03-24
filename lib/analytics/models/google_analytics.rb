module Analytics
  module Models
    class GoogleAnalytics < SimpleAnalytics
      include ActionView::Helpers::TagHelper

      attr_accessor :debug
      attr_accessor :script_src
      attr_accessor :web_property_id

      def initialize opts={}
        opts.symbolize_keys!
        self.web_property_id = escape_once(opts[:web_property_id].presence || 'UA-XXXX-Y')
        self.debug = opts[:debug].presence || false
        self.script_src = (opts.has_key? :script_src)? opts[:script_src] :'#'
      end

      def script_src_with_debug
        (false == debug)?  script_src_without_debug : @script_src.gsub(/([a-zA-Z0-9_-]+)\.js$/, '\1_debug.js')
      end

      alias_method_chain :script_src, :debug
    end
  end
end
