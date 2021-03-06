require 'textrazor'

class ArticlesController < ApplicationController
  before_action :require_admin, except: [:index, :show]

  def index
    @articles = Article.published.order(:created_at).reverse_order
  end

  def show
    @article = Article.find(params[:id])
    redirect_to articles_path unless @article
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
    redirect_to articles_path unless @article
  end

  def create
    @article = Article.new(params.require(:article).permit(:title, :body, :markdown))
    @article.save

    generate_tags @article if params[:autotag] == "true"

    redirect_to article_path(@article)
  end

  def update
    article = Article.find(params[:id])
    return unless article
    article.update(params.require(:article).permit(:title, :body, :markdown))

    generate_tags article if params[:autotag] == "true"

    redirect_to article_path
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy

    redirect_to articles_path
  end

  def delete
    article = Article.find(params[:id])
    return unless article

    article.deleted!

    redirect_to articles_path
  end

  def remove_tag
    article = Article.find(params[:article_id])
    tag = Tag.find(params[:id])
    article.remove_tag(tag)

    redirect_to article_path(article)
  end

  def trash
    @articles = Article.deleted.order(:created_at).reverse_order
  end

  def recover
    article = Article.find(params[:id])
    redirect_to trash_path unless article
    article.published!

    redirect_to article_path(article)
  end

  private

  def generate_tags(article)
    topics = Textrazor::Client.new(key: ENV['TEXTRAZOR_API_KEY']).topics article.body
    return unless topics

    topics.first(5).each do |topic|
      tag = upsert_tag_by_name topic["label"]
      article.add_tag(tag)
    end
  end
end
