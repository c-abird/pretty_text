module ApplicationHelper
  # This helper creates a <tt>PrettyText</tt> object and shows the generated text as
  # background image of a HTML-tag.
  # You can set the style of the rendered text by a <tt>PrettyTextStyle</tt> object
  # or by a hash:
  #
  #   <% @style = Cabird::PrettyTextStyle.new(:color => '#666666', :size => 30) %>
  #   <%= pretty_text("the text", @style, 'h1')
  #
  # or
  #
  #   <%= pretty_text("the text", {:color => '#666666', :size => 30}, 'h1')
  #
  # which will result in the same output:
  #
  #   <h1 style="... background: url('...'); ...">the text</h1>
  #
  # Using the <tt>PrettyTextStyle</tt> class gives you the opportunity to use a kind of
  # style inheritance:
  #
  #   <% @style = Cabird::PrettyTextStyle.new(:color => '#666666', :size => 30) %>
  #   <%= pretty_text("a headline", @style, 'h1')
  #   <%= pretty_text("normal text", @style.alter(:size => 12), 'p')
  #
  # Use the html_options to append HTML options to the tag:
  #   <%= pretty_text("the text", @style, 'h1', {:class => "myclass"})
  def pretty_text(str, style = nil, tag="span", html_options = {}, options = {})
    text = PrettyText::Text.create(str, style);

    html_options[:class] = [html_options[:class]].push("pretty_text").compact.join(" ")
    #convert_options_to_javascript!(html_options)
    tag_options = tag_options(html_options)

    style  = "width:#{text.width}px;padding-top:#{text.height}px;"
    style << "background-image: url('#{image_path(text.path)}');"

    ret =  "<#{tag} style=\"#{style}\"#{tag_options}>"
    ret << h(text.content) unless options[:only_image]
    ret << "</#{tag}>"

    raw(ret)
  end

  # This method returns the public path to the rendered text. The parameters are the same
  # as the two first parameters of the pretty_text method.
  def pretty_text_path(str, style = nil)
    text = PrettyText::Text.create(str, style);
    return text.path
  end

  def pretty_text_includes
    stylesheet_link_tag('pretty_text')
  end
end
