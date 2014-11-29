require 'minitest/autorun'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

if __FILE__ == $0
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/**/test*.rb') {|f| require f}
end