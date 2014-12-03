module EvilIcons
  module Helpers

    def evil_icons_sprite
      html_safe File.new(EvilIcons.sprite_file).read
    end

    def evil_icon(name, options = {})
      size  = options[:size] ? "icon--#{options[:size]}" : ''
      options[:class] = "icon icon--#{name} #{size} #{options[:class]}"

      html_safe "
        <div class='#{options[:class]}'>
          <svg class='icon__cnt'><use xlink:href='##{name}-icon'/></svg>
        </div>
      "
    end


    private

    def html_safe(html)
      return html.html_safe if html.respond_to?(:html_safe)
      html
    end

  end
end
