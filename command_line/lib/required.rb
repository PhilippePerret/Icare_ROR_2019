# encoding: UTF-8
# puts "--> required.rb"

# Note : nom avec CLI pour ne pas confondre avec le site lui-même
APPCLIFOLDER = APPFOLDER = File.expand_path('..', __dir__)

ICARE_FOLDER = File.dirname(APPCLIFOLDER)

# puts "-- APPCLIFOLDER: #{APPCLIFOLDER}"

['required_first', 'required_then'].each do |relpath|
  Dir["#{APPCLIFOLDER}/lib/#{relpath}/**/*.rb"].each{|m|require m}
end

# puts "<-- required.rb"
