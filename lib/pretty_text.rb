require 'pretty_text_text'
require 'pretty_text_helper'
require 'pretty_text_style'

module PrettyText
  def self.root
    File.dirname(__FILE__) + "/.."
  end

  def self.copy_asset(file)
    src = File.join(PrettyText.root, 'public', file)
    dst = File.join(Rails.root, 'public', file)

    FileUtils.cp(src, dst)
  end

  Rails::Application.initializer("pretty_text.install_assets") do
    PrettyText.copy_asset(File.join('stylesheets', 'pretty_text.css'))
  end
end
