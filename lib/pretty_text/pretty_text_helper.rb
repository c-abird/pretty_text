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
  def pretty_text(str, pstyle = nil, tag="span", html_options = {}, options = {})
    html_options[:class] = [html_options[:class]].push("pretty_text").compact.join(" ")
    tag_options = tag_options(html_options)
    style =  pretty_inline_style(str, pstyle)

    ret =  "<#{tag} style=\"#{style}\"#{tag_options}>"
    ret << h(str).gsub(/\n/, '<br>') unless options[:only_image]
    ret << "</#{tag}>"

    raw(ret)
  end

  def pretty_paragraph(html, styles)
    frag = Nokogiri::HTML::DocumentFragment.parse(html)
    styles.each do |element, pstyle|
      frag.xpath(element.to_s).each do |div|
        div.set_attribute("class" , "pretty_text #{div.get_attribute("class")}")
        style = pretty_inline_style(div.inner_html, pstyle)
        div.set_attribute("style", style)
      end 
    end 
    raw(frag)
  end 

  def pretty_inline_style(str, pstyle = nil)
    text = PrettyText::Text.create(str, pstyle)
    style  = "width:#{text.width}px;height:#{text.height}px;"
    style << "background-image: url('#{image_path(text.path)}');"
    style
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
