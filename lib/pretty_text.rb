module Cabird # :nodoc:
  # This class represents a rendered text. It provides methods to get the path and
  # the geometry to the generated image.
  # Some parameters of the rendering process can be set using the global Hash
  # <tt>PRETTY_TEXT</tt>. These are the configuration keys for <tt>PRETTY_TEXT</tt>:
  # [<tt>:image_path</tt>]
  #   The public path where the plugin stores the rendered images relative to the
  #   public path. Defaults to 'images/pretty_text'
  # [<tt>:scale_threshold</tt>]
  #   Some fonts might look a little bit ugly at smaller sizes. <tt>PrettyText</tt>
  #   tries to fix that by rendering small fonts 5 times bigger and scaling the
  #   result down to the original size. You can set a threshold for the font size
  #   in pts. All fonts smaller than this threshold will be rendered using this
  #   scale hack.
  # [<tt>:scale_filter</tt>]
  #   The ImageMagick filter which is used for resizing. Defaults to
  #   <tt>Magick::GaussianFilter</tt>.
  # [<tt>:scale_support</tt>]
  #   The support argument used by the ImageMagick <tt>resize</tt> method. Defaults
  #   to 0.5.
  class  PrettyText
    require 'RMagick'
    require 'fileutils'

    @@config = Hash.new
    mattr_writer :config
    SCALE_FACTOR = 5

    attr_reader :content

    # This class method is used to set up a new <tt>PrettyText</tt> object. If the requested
    # image is not yet created, it generates the image and returns the approprate
    # <tt>PrettyText</tt> object.
    def self.create(text, style = nil)
      text = text.to_s
      if (style.class.to_s != "Cabird::PrettyTextStyle")
        style = Cabird::PrettyTextStyle.new(style)
      end

      # set up paths
      public_image_path = @@config[:image_path] || File.join('system' , 'pretty_text')
      public_path = File.join(public_image_path, style.generate_filename(text))
      absolute_path = File.join(RAILS_ROOT, 'public', public_path)

      # render small fonts bigger and scale down later
      size = style.size
      scale_hack = size <= (@@config[:scale_threshold] || 12)
      size *= SCALE_FACTOR if scale_hack
      
      if (!File.exist?(absolute_path))
        # create directory
        FileUtils.mkpath(File.dirname(absolute_path)) unless File.exists?(File.dirname(absolute_path))

        gc = Magick::Draw.new
        gc.font = File.join(RAILS_ROOT, 'fonts', style.font) if style.font
        gc.pointsize = size
        #gc.kerning(style.kerning)
        gc.gravity = Magick::NorthWestGravity
        gc.fill = style.color
        text_to_render = style.process_text(text)
        gc.text(style.xoffset, style.yoffset, text_to_render)

        metrics = gc.get_multiline_type_metrics(text_to_render)
        image = Magick::Image.new(metrics.width + style.xextra + style.xoffset, metrics.height + style.yextra + style.yoffset) do
          self.background_color = style.bg_color
        end
        gc.draw(image)

        # scale down to original size
        if scale_hack
          image.resize!(metrics.width / SCALE_FACTOR,
                        metrics.height / SCALE_FACTOR,
                        @@config[:scale_filter]  || Magick::GaussianFilter,
                        @@config[:scale_support] || 0.5)
        end
        # handle gif transparency
        if (style.format == :gif)
          image = image.matte_replace(0, 0)
        end

        image.write(absolute_path)
      end

      return self.new(text, public_path)
    end

    # The constructor is used by the <tt>create</tt> factory method. You should not use it,
    # but use the <tt>create</tt> method instead.
    def initialize(text, public_path)
      @content = text
      @public_path = public_path
    end

    # Returns the relative path of the image starting at the public directory
    def path
      return File.join('', @public_path)
    end

    # Return the width of the image
    def width
      get_geometry if @width.nil?
      return @width
    end
      
    # Returns the height of the image
    def height
      get_geometry if @height.nil?
      return @height
    end

    # Returns the string the image is created from
    def to_s
      return @text
    end

    private

    # Retrieves the geometry of the image and saves it to the <tt>@width</tt> and
    # <tt>@height</tt> attributes of the class
    def get_geometry
      image = Magick::Image.read(File.join(RAILS_ROOT, 'public', @public_path)).first
      @width = image.columns
      @height = image.rows
    end
  end
end
