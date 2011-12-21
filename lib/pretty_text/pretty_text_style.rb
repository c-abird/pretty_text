module PrettyText# :nodoc:
  # This class represents a style used by the <tt>PrettyText</tt> class to generate
  # an image. This style includes font properties like the font-file and the font-size,
  # colors and text transformation like upcase.
  #
  # Possible style attributes are:
  # [<tt>format</tt>]
  #   Can either be <tt>:png</tt> or <tt>:gif</tt>, defaults to <tt>:png</tt>.
  #   If <tt>:gif</tt> is used set the <tt>bg_color</tt> attribute to get proper
  #   antialiasing.
  # [<tt>color</tt>]
  #   The color of the rendered text. Use HTML/CSS style color definitions (eg.:
  #   ##fff, ##d2d2d2). Defaults to ##fff.
  # [<tt>bg_color</tt>]
  #   If you choose <tt>:gif</tt> as format the text will be rendered against the given
  #   <tt>bg_color</tt> and the areas of the background which are not effected by the
  #   antialiasing are cut out. This way you get proper antialiasing, although the gif
  #   format does not support alpha channels.
  # [<tt>size</tt>]
  #   The size of the rendered font in points
  # [<tt>font</tt>]
  #   The font file to use relative to the font root directory, which is fonts by default
  # [<tt>upcase</tt>]
  #   This flag defines if the text is transformed to uppercase before rendering.
  #   This boolean defaults to false.
  # [<tt>extra_width</tt>]
  #   Sometimes Imagemagick will calculate the wrong width for the image. You can add
  #   some extra space by setting this value. Defaults to 0. This might be obsolete due
  #   to an former error in the implementation.
  #
  # You can set the atrributes via the constructor:
  #   style = Cabird::PrettyTextStyle.new({:format => :png, :color => '#f00'})
  # or via the setter methods:
  #   style.color = '#000'
  class Style
    #require 'RMagick'

#    require 'digest/md5'
    require 'unicode'
    
    @@default = {:format => :png,
                 :color => '#000',
                 :additional_colors => [],
                 :bg_color => '#fff',
                 :size => 12,
                 :font => nil,
                 :upcase => false,
                 :downcase => false,
                 :extra_width => 0,
                 :xextra => 0,
                 :xoffset => 0,
                 :yextra => 0,
                 :yoffset => 0,
                 :kerning => 0,
                 :interline_spacing => 0,
                 :html_font => nil,
                 :upscale => false}

    # define getters and setters with default
    @@default.keys.each do |key|
      # getter method
      define_method key do
        return @attributes[key] || @@default[key]
      end

      # setter method
      define_method key.to_s + '=' do |value|
        @attributes[key] = value
      end
    end

    # Sets up a new <tt>PrettyTextStyle</tt> object. All of the above mentioned attributes
    # can be set here.
    def initialize(attributes = nil)
      @attributes = attributes || Hash.new
    end

    # This method overrides the default getter method for the <tt>bg_color</tt> method.
    def bg_color
      return "transparent" if self.format == :png
      return @attributes[:bg_color] || @@default[:bg_color]
    end

    # Applies all text transformations to a given text, which includes only the
    # <tt>upcase</tt> option at the moment. Returns the transformed text.
    def process_text(text)
      text = Unicode::upcase(text)   if self.upcase
      text = Unicode::downcase(text) if self.downcase
      return text
    end

    # Generates a hash string of all attributes and a given string. This method is used
    # by the <tt>generate_filename</tt> method to retrieve the filename for a combilnation
    # of style attributes and a certain text.
    def generate_hash(str = "")
      omit = [:html_font]
      to_hash = str
      (@@default.keys - omit).each do |key|
        to_hash += self.send(key).to_s
      end
      return  Digest::MD5.hexdigest(to_hash)
    end

    # This method generates a hashed filename of the style attributes and a given text
    def generate_filename(str)
      fragments = self.generate_hash(str).scan(/(..)/).flatten
      return File.join(fragments) + "." + self.format.to_s
    end

    # Clones this <tt>PrettyTextStyle</tt> object and returns an altered version of the clone.
    # You can override attributes with the argument.
    def alter(attributes = Hash.new)
      result = @@default.merge(@attributes).merge(attributes)
      return self.class.new(result)
    end
  end
end
