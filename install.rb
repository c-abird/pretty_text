require 'fileutils'

# setup the font path
font_path = File.join(RAILS_ROOT, 'fonts')
FileUtils.mkpath(font_path)

# show the README file
puts IO.read(File.join(File.dirname(__FILE__), 'README'))
