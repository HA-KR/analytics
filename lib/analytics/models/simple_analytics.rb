module Analytics
  module Models
    class SimpleAnalytics < Analytics
      #simple value based analytics like GA
      #Tracking Code remains static for all pages in the controller
      def tracking_code
        raise "sub class should implement this method"
      end
    end
  end
end
