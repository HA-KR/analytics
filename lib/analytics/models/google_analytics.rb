module Analytics
  module Models
    class GoogleAnalytics < Base

      attr_accessor :debug
      attr_accessor :script_src
      attr_accessor :remarketing
      attr_accessor :web_property_id

      def initialize opts={}
        super
        self.debug = opts[:debug].presence || false
        self.script_src = (opts.has_key? :script_src)? opts[:script_src] :'#'
        self.remarketing = opts[:remarketing].presence || false
        self.web_property_id = opts[:web_property_id].presence || 'UA-XXXX-Y'
      end

      def script_src_with_debug
        (debug)? script_src_without_debug.gsub(/([a-zA-Z0-9_-]+)\.js/, '\1_debug.js') : script_src_without_debug
      end
      alias_method_chain :script_src, :debug

    end
  end
end
