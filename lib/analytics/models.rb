module Analytics
  module Models
    require_dependency 'analytics/models/base'
    require_dependency 'analytics/models/tokens'

    require_dependency 'analytics/models/google_analytics'
    require_dependency 'analytics/models/classic_google_analytics'
    require_dependency 'analytics/models/universal_google_analytics'
  end
end

