require 'rubygems'

SPEC = Gem::Specification.new do |s|
  s.name = 'pretty_text'
  s.version = '0.1'
  s.date = '2010-08-08'
  s.author = 'Claas Abert'
  s.email = 'claas@cabird.de'
  s.homepage = 'http://cabird.de'
  s.summary = 'A TTF font rendering plugin for rails.'
  s.description = 'pretty_text uses RMagick to render text and provides helpers for the integration in your views'
  
  s.platform = Gem::Platform::RUBY

  s.files        = Dir['README', 'Rakefile', '{lib,rails}/**/*.rb']
  s.require_path = 'lib'

  s.has_rdoc = true
  s.add_dependency('rmagick')
end
