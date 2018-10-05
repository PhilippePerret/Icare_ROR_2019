class AideController < ApplicationController

  # Afficher une page d'aide
  def show
    @aide_id = params[:id] # par exemple 'partage'
    aide_path = Rails.root.join('app','views','aide','files',"#{@aide_id}.html.md")
    @body = render_markdown(aide_path)
  end

  # Afficher la table des matières de l'aide
  def index
  end

  # Procéder à une recherche dans l'aide
  def search
  end

  def render_markdown(file)
    markdown = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        disable_indented_code_blocks: true)
    markdown.render(File.read(file)).html_safe
  end
end
