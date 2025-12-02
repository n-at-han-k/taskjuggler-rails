module TaskjugglerRails
  module Renderer
    module_function

    def render_html(tjp_source)
      Dir.mktmpdir("tjp") do |dir|
        input_tjp  = File.join(dir, "input.tjp")
        output_dir = File.join(dir, "out")
        FileUtils.mkdir_p(output_dir)

        File.write(input_tjp, tjp_source)

        exe  = resolve_tj3_path
        args = TaskjugglerRails.config.tj3_args.flat_map { |k, v| ["--#{k}", v.to_s] }

        #
        # IMPORTANT:
        # TaskJuggler syntax requires:
        #
        #   --output-dir <directory>
        #
        cmd = [
          exe,
          input_tjp,
          "--output-dir", output_dir,
          *args
        ]

        log = `#{cmd.join(" ")} 2>&1`

        html_file = Dir[File.join(output_dir, "*.html")].first
        raise "TaskJuggler produced no HTML.\n#{log}" unless html_file

        html = File.read(html_file)

        embed_assets(html, output_dir)
      end
    end


    # ----------------------------------------------------------
    # Asset embedding (css/js/icons) same as before
    # ----------------------------------------------------------

    def embed_assets(html, output_dir)
      doc = Nokogiri::HTML(html)

      Dir[File.join(output_dir, "css/*.css")].each do |css_file|
        node = Nokogiri::XML::Node.new("style", doc)
        node.content = File.read(css_file)
        doc.at("head") << node
      end

      doc.css('link').each { |l| l.remove if l["href"].to_s.start_with?("css/") }

      Dir[File.join(output_dir, "scripts/*.js")].each do |js_file|
        node = Nokogiri::XML::Node.new("script", doc)
        node.content = File.read(js_file)
        doc.at("body") << node
      end

      doc.css("script").each { |s| s.remove if s["src"].to_s.start_with?("scripts/") }

      doc.css("img").each do |img|
        src = img["src"].to_s
        next unless src.start_with?("icons/")

        icon_path = File.join(output_dir, src)
        next unless File.exist?(icon_path)

        mime = "image/#{File.extname(icon_path).delete('.')}"
        encoded = Base64.strict_encode64(File.binread(icon_path))
        img["src"] = "data:#{mime};base64,#{encoded}"
      end

      doc.to_html
    end


    def resolve_tj3_path
      explicit = TaskjugglerRails.config.tj3_path
      return explicit if explicit && File.exist?(explicit)

      path = `which tj3`.strip
      return path unless path.empty?

      raise "TaskJuggler executable not found"
    end
  end
end

