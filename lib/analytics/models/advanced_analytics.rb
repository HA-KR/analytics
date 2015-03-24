module Analytics
  module Models
    class AdvancedAnalytics < Analytics
      #Advanced token based analytics like GTM
      #changes TRACKING CODE according to the page
      def tracking_code
        raise "sub class should implement this method"
      end
    end
  end
end
