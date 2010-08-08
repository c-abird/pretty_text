# Include hook code here
require 'pretty_text'
require 'pretty_text_style'
require 'pretty_text_helper'

# load configuration
Cabird::PrettyText.config = PRETTY_TEXT if Object.const_defined?(:PRETTY_TEXT)

# include helpers
ActionView::Base.send(:include, Cabird::PrettyTextHelper)
