module Analytics
  module Models
    module Position
      #position constants
      TOP     = -1
      BOTTOM  = 1
      HEAD    = 1
      BODY    = 2
      DISABLE = 0

      def position
        @position ||= HEAD
      end

      #Sets the position of the analytics script
      #The available positions are
      # OPTIONS       = POSITION
      #----------------------------------------
      # TOP           = begining of <head>
      # BOTTOM        = end of <head>
      # HEAD          = end of <head>
      # BODY          = end of <body>
      # HEAD | TOP    = begining of <head>
      # HEAD | BOTTOM = end of <head>
      # BODY | TOP    = begining of <body>
      # BODY | BOTTOM = end of <body>
      # DISABLE       = nowhere, disable the script
      def position= pos
        @position = ((-2..2) === pos)? pos : HEAD
      end
    end

    # should be aware of the position of the script
    # and the buffer '_' content of the script
    # _ << ""
    module ContextAware
      include Position

      # The _ buffer is an inplace Array of Objects to be appended to the markup
      # the odd position contains the type of data and
      # the even position contains the actual data
      # [:html, "<script src='../'>/script<>", :js, 'ga("_trackPageview")']
      #
      # Example:
      #     ua = UniversalGoogleAnalytics.new
      #     #=> _ = [] -> Initially Empty
      #
      #     ua << " <script src='..'> </script> "
      #     #=> _ = [:html, "<script src='..'> </script>"]
      #
      #     ua << " <script type='application/ld+json'>..</script> "
      #     #=> _ = [:html, "<script src='..'> </script> <script type='application/ld+json'>..</script>"]
      #     #i.e., if the type of newly appended data is similar to last appended data,
      #            no new entry is created instead the data is appended to existing data
      #
      #     ua << "ga('_trackPageview');"
      #     #=> _ = [:html, "<script src='..'> </script> <script type='application/ld+json'>..</script>",
      #               :js, "ga('_trackPageview');"]
      #
      def _
        @_ ||= []
      end

      def _=(content)
        content.strip!
        category = categorize(content)
        if self._[-2] == category
          self._[-1] << content
        else
          self._.push category, content
        end
      end

      def <<(content)
        self._= content
      end

      def flush
        _ = []
      end

      def to_s
        value = _.each_slice(2).collect{|type, data| buffer_to_string(type, data)}.join("\n")
        flush
        value
      end
      alias_method :to_html, :to_s

      private
      # assumes all strings that starts with '<' as HTML and categorizes
      # the availables categories as for now is :html and :js
      def categorize content
        if content.first ==  '<'
          :html
        else
          :js
        end
      end

      def buffer_to_string type, data
        case type
        when :html
          data
        when :js
          %{
          <script type='text/javascript'>
            #{data}
          </script>
          }
        else
          data
        end
      end

    end

  end
end

