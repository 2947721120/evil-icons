module EvilIcons
  module Helpers

    def evil_icons
      render "evil_icons/icons"
    end

    def icon(name, options = {})
      size  = options[:size] ? "icon--#{options[:size]}" : ''
      options[:class] = "icon icon--#{name} #{size} #{options[:class]}"

      content_tag :div, options do
        content_tag :svg, class: "icon__cnt" do
          tag :use, "xlink:href" => "##{name}-icon"
        end
      end

    end

  end
end
