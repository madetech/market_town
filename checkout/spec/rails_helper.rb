Dir[File.dirname(__FILE__) + '/support/rails/*.rb'].sort.each do |support_file|
  require support_file
end
