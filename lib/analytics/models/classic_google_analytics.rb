module Analytics
  module Models
    class ClassicGoogleAnalytics < GoogleAnalytics

      def initialize opts={}
        super opts.reverse_merge :script_src => 'google-analytics.com/ga.js'
      end

      def tracking_code *args
        puts args.inspect
        opts = args.extract_options!
        args << opts
        <<-TRACKING_CODE.gsub(/^\s+/, '')
        #{create_and_send if false != opts[:create]}
        <script type="text/javascript">
        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.#{script_src}';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
        </script>
        TRACKING_CODE
      end

      private
      def create_and_send
        <<-CREATE.gsub(/^\s+/, '')
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '#{web_property_id}']);
        _gaq.push(['_trackPageview']);
        CREATE
      end

    end
  end
end


