Dir[File.dirname(__FILE__) + '/wiwork/*.rb'].each do |file|
  require file
end

Dir[File.dirname(__FILE__) + '/wiwork/methods/*.rb'].each do |file|
  require file
end
