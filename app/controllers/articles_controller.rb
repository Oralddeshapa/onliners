require 'judge.rb'

class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    @article = Article.new
  end

  def create
    @article = Article.new(params.require(:article).permit(:url))
    judge = Judge.new
    judge.proceed(@article.url, @article.id)
    @article.save

    redirect_to  root_path
  end
end
