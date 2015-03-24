require 'active_support'
require 'action_pack'
require 'action_view'

require "analytics/version"
require "analytics/models"
module Analytics
  def self.included base
    base.class_eval do
      #add helpers for view
      #add controller methods
    end
  end
end
