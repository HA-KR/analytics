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
    class Base
      include Position
      #add support for position of the script
      def initialize opts={}
        opts.symbolize_keys!
        position = opts[:position]
      end

      def tracking_code
        raise "sub class should implement this method"
      end

      #def readonly
        #self.dup
      #end
    end

  end
end
