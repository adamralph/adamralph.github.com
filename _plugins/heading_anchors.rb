# frozen_string_literal: true

require "nokogiri"
require "set"

# Adds a permalink anchor to section headings in rendered pages.
module HeadingAnchors
  GLYPH = "#"

  def self.apply(html)
    return html unless html.include?("<main")

    document = Nokogiri::HTML5.parse(html)
    used = document.css("[id]").map { |element| element["id"] }.to_set
    added = false

    document.css("main h2, main h3").each do |heading|
      next if only_link?(heading)
      next if heading.at_css(".heading-hash")
      next if in_related_posts?(heading)

      id = heading["id"] || generated_id(heading, used)
      add_anchor(heading, id)
      added = true
    end

    added ? document.to_html : html
  end

  # True when the heading is already a link, as post titles on the index are.
  def self.only_link?(heading)
    children = heading.children.reject { |node| node.text? && node.text.strip.empty? }
    children.length == 1 && children.first.name == "a"
  end

  def self.in_related_posts?(heading)
    heading.ancestors.any? do |node|
      node["class"].to_s.split.include?("related-posts")
    end
  end

  def self.generated_id(heading, used)
    section = heading.ancestors.find { |node| node.name == "section" && node["id"] }
    return section["id"] if section

    base = slugify(heading.text)
    base = "section" if base.empty?

    id = base
    suffix = 2
    while used.include?(id)
      id = "#{base}-#{suffix}"
      suffix += 1
    end

    used << id
    heading["id"] = id
    id
  end

  def self.add_anchor(heading, id)
    if heading.at_css("a")
      hash = Nokogiri::XML::Node.new("a", heading.document)
      hash["class"] = "heading-hash"
      hash["href"] = "##{id}"
      hash["aria-label"] = "Link to this section"
      hash.content = GLYPH
      heading.children.first.add_previous_sibling(hash)
    else
      link = Nokogiri::XML::Node.new("a", heading.document)
      link["class"] = "heading-link"
      link["href"] = "##{id}"

      hash = Nokogiri::XML::Node.new("span", heading.document)
      hash["class"] = "heading-hash"
      hash["aria-hidden"] = "true"
      hash.content = GLYPH
      link.add_child(hash)

      heading.children.to_a.each { |child| link.add_child(child) }
      heading.add_child(link)
    end
  end

  def self.slugify(text)
    text
      .downcase
      .strip
      .gsub(/[^\w\s-]/, "")
      .gsub(/[\s_-]+/, "-")
      .gsub(/^-+|-+$/, "")
  end
end

Jekyll::Hooks.register :documents, :post_render do |document|
  next unless document.output_ext == ".html"

  document.output = HeadingAnchors.apply(document.output)
end

Jekyll::Hooks.register :pages, :post_render do |page|
  next unless page.output_ext == ".html"

  page.output = HeadingAnchors.apply(page.output)
end
