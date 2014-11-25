require 'minitest/autorun'

if __FILE__ == $0
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/**/test*.rb') {|f| require f}
end