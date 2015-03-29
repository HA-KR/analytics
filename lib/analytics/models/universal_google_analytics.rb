module Analytics
  module Models
    class UniversalGoogleAnalytics < GoogleAnalytics

      #Provides a single global object `ga`
      #Method reference https://developers.google.com/analytics/devguides/collection/analyticsjs/method-reference
      # 'ga' object methods
      #    ga('create', trackingId, opt_configObject)
      #    ga.getByName(name)
      #    ga.getAll()
      #
      #  'tracker' Object methods
      #     ga('send', hitType, opt_fieldObject)
      #     ga('set', fieldName, value)
      #     tracker.get(fieldName)
      #
      #   Calling Syntax - changes for sync/ async/ named/ sync-function

      attr_writer :tracker

      def initialize opts={}
        super opts.reverse_merge :script_src =>'//www.google-analytics.com/analytics.js'
        self.tracker =opts[:tracker].presence || 'ga'
      end

      # @param {Window}      i The global context object.
      # @param {Document}    s The DOM document object.
      # @param {string}      o Must be 'script'.
      # @param {string}      g URL of the analytics.js script. Inherits protocol from page.
      # @param {string}      r Global name of analytics object.  Defaults to 'ga'.
      # @param {DOMElement?} a Async script tag.
      # @param {DOMElement?} m First script tag in document.
      def canonical_tracking_code *args
        defaults = ["window", "document", "'script'","'#{script_src}'", "'#{tracker}'"]
        defaults.shift args.length
        args = args << defaults
        debug_trace
        self << <<-CANONICAL_TRACKING
          (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
          })(#{args.join(',')});
        CANONICAL_TRACKING
        self
      end
      def canonical_tracking_code_with_pagetrack *args
        canonical_tracking_code_without_pagetrack.create_and_track
      end
      alias_method_chain :canonical_tracking_code, :pagetrack
      alias_method :tracking_code, :canonical_tracking_code

      def tracker
        @tracker ||= 'ga'
      end

      def ga *args
        self << "#{tracker}(#{args.collect(&:to_json).join(',')});"
        self
      end

      def async_tracking_code *args
        self << <<-ASYNC_TRACKING
          <script async src='#{script_src}'></script>
          <script>
          window.#{tracker}=window.#{tracker}||function(){(#{tracker}.q=#{tracker}.q||[]).push(arguments)};#{tracker}.l=+new Date;
          </script>
        ASYNC_TRACKING
        self
      end

      def async_tracking_code_with_pagetrack *args
        async_tracking_code_without_pagetrack
        self << '<script>'
        create_and_track
        self << '</script>'
      end
      alias_method_chain :async_tracking_code, :pagetrack

      def create_and_track
        ga('create', web_property_id, 'auto')
        ga('require', 'displayfeatures') if remarketing
        ga('send', 'pageview')
      end

      def debug_trace
        if 'trace' == debug
          self << 'window.ga_debug = {trace: true};'
        end
        self
      end

    end
  end
end

