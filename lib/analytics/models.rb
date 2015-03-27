module Analytics
  module Models
    Dir.glob(File.dirname(__FILE__)+'/analytical/models/*.rb').each do |file|
      require_dependency file
    end
  end
end

