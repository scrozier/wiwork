# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'wiwork'
  spec.version       = '0.0.2'
  spec.authors       = ['Steve Crozier']
  spec.email         = ['steve@crozier.com']
  spec.summary       = %q{Robust wrapper for the WhenIWork API.}
  spec.description   = %q{Vision for wiwork is to wrap all the API endpoints and provide rich, plain old Ruby objects for all the WhenIWork entities (shifts, users, positions, etc.)}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = ['lib/wiwork.rb',
                        'lib/wiwork/user.rb',
                        'lib/wiwork/position.rb',
                        'lib/wiwork/location.rb',
                        'lib/wiwork/shift.rb',
                        'lib/wiwork/availability.rb',
                        'lib/wiwork/availability_item.rb',
                        'lib/wiwork/utility_classes.rb',
                        'lib/wiwork/methods/availabilities.rb',
                        'lib/wiwork/methods/locations.rb',
                        'lib/wiwork/methods/positions.rb',
                        'lib/wiwork/methods/shifts.rb',
                        'lib/wiwork/methods/users.rb',
                        'lib/wiwork/connection.rb']

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~>  1.6'
  spec.add_development_dependency 'rake',    '~> 10.4'
  spec.add_development_dependency 'webmock', '~>  1.20'
  spec.add_development_dependency 'vcr',     '~>  2.9'

  spec.add_dependency 'httparty', '~> 0.13'
end
