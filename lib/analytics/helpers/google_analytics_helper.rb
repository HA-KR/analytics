require 'action_view/helpers/text_helper'

module Analytics
  module Helpers
    module GoogleAnalyticsHelper

      def analytics handle, *args, &block
        opts = args.extract_options!
        code = ""
        code << handle.tracking_code(*args) if opts.delete(:init)
        if block_given?
          code << %{<script type='text/javascript'>
          #{capture(&block)}
          </script>
          }
        end
        if block_called_from_erb?(block)
          concat(code)
        else
          code
        end
      end

    end
  end
end

