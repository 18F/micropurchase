class MarkdownRender
  attr_reader :markdown, :text

  def initialize(text)
    @text = text
    @markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      no_intra_emphasis: true,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      lax_spacing: true
    )
  end

  def to_s
    markdown.render(text)
  end
end
