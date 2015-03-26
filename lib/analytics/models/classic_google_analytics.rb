module Analytics
  module Models
    class ClassicGoogleAnalytics < GoogleAnalytics

      def initialize opts={}
        opts.symbolize_keys!
        script_src = if opts[:remarketing]
                       "('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js'"
                     else
                       "('https:'==document.location.protocol?'https://ssl':'http://www')+'.google-analytics.com/ga.js'"
                     end
        super opts.reverse_merge :script_src => script_src
      end

      def tracking_code *args
        puts args.inspect
        opts = args.extract_options!
        args << opts
        <<-TRACKING_CODE
        <script type="text/javascript">
        #{create_and_send if false != opts[:create]}
        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = #{script_src};
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
        </script>
        TRACKING_CODE
      end

      private
      def create_and_send opts={}
          code = ""
          if opts[:create] != false
            code << "var _gaq = _gaq || [];"
            code << "_gaq.push(['_setAccount', '#{web_property_id}']);"
            code << "_gaq.push(['_trackPageview']);"
          else
            ''
          end
      end

    end
  end
end


