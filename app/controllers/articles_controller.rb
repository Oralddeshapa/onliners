class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments
  end

  def create
    ca = CreateArticle.new(article_params)
    corrrect =  ca.call
    if !corrrect
      flash[:error] = ca.errors.full_messages.to_sentence
    end
    redirect_to  root_path
  end

  def article_is_valid?(url)
    article = Site.new(url)
    if article.working?
      true
    else
      false
    end
  end

  def article_params
    params.require(:article).permit(:url)
  end
end
