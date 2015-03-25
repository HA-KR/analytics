require 'active_support'
require 'action_pack'
require 'action_view'

require "analytics/version"
require "analytics/models"
require "analytics/helpers"

module Analytics
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
    base.class_eval do
      #add helpers for view
      helper Analytics::Helpers
      #add controller methods
      include Analytics::Models
      before_filter :analytics_init
    end
  end

  module ClassMethods
    def analytics method_name
      alias_method :analytics_init, method_name
    end
  end

  module InstanceMethods
    def analytics_init
      #to be overridden in controller
    end
  end
end
