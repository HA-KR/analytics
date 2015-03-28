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

    module ContextAware
      include Position

      def _
        @_ ||= ''
      end

      def _=(context)
        @_ = context
      end

      def flush
        _ = ''
      end

      def to_s
        value = _
        flush
        value
      end
      alias_method :to_html, :to_s
    end

  end
end

