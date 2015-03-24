module Analytics
  module Models
    class GoogleAnalytics < SimpleAnalytics
      include ActionView::Helpers::TagHelper

      attr_writer :ga
      attr_accessor :debug
      attr_writer :script_src
      attr_accessor :web_property_id

      def initialize opts={}
        opts.symbolize_keys!
        self.ga = escape_once( opts[:ga].presence || 'ga' )
        self.web_property_id = escape_once( opts[:web_property_id].presence || 'UA-XXXX-Y' )
        self.debug =opts[:debug].presence || false
      end

      def ga *args
        if block_given?
          yield
        else
          @ga
        end
      end

      def script_src
        if false == debug
          '//www.google-analytics.com/analytics.js'
        else
          '//www.google-analytics.com/analytics_debug.js'
        end
      end

      #
      # @param {Window}      i The global context object.
      # @param {Document}    s The DOM document object.
      # @param {string}      o Must be 'script'.
      # @param {string}      g URL of the analytics.js script. Inherits protocol from page.
      # @param {string}      r Global name of analytics object.  Defaults to 'ga'.
      # @param {DOMElement?} a Async script tag.
      # @param {DOMElement?} m First script tag in document.
      def tracking_code *args
        puts args.inspect
        opts = args.extract_options!
        args << opts
        <<-TRACKING_CODE.gsub(/^\s+/, '')
        #{debug_trace}
        #{opts[:modern_async]? async_tracking_code(*args): canonical_tracking_code(*args)}
        TRACKING_CODE
      end

      def canonical_tracking_code *args
        puts args.inspect
        opts = args.extract_options!
        defaults = ["window", "document", "'script'","'#{script_src}'", "'ga'"]
        defaults.shift args.length
        args = args << defaults
        <<-CANONICAL_TRACKING.gsub(/^\s+/, '')
        <script type='text/javascript'>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(#{args.join(',')});
        #{create_and_send unless false == opts[:create]}
        </script>
        CANONICAL_TRACKING
      end

      def async_tracking_code *args
        puts args.inspect
        opts = args.extract_options!
        <<-ASYNC_TRACKING.gsub(/^\s+/, '')
        <script async src='#{script_src}'></script>
        <script>
        window.#{ga}=window.#{ga}||function(){(#{ga}.q=#{ga}.q||[]).push(arguments)};#{ga}.l=+new Date;
        #{create_and_send unless false == opts[:create]}
        </script>
        ASYNC_TRACKING
      end

      def create_and_send
        <<-CREATE.gsub(/^\s+/, '')
        #{ga}('create', '#{web_property_id}', 'auto');
        #{ga}('send', 'pageview');
        CREATE
      end

      def debug_trace
        ('trace' == debug)? 'window.ga_debug = {trace: true};' : ''
      end

    end
  end
end
