require 'urlscorechecker.rb'

class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    @article = Article.new
  end

  def new
  end

  def show
    @article = Article.find(params[:id])
    @comments = Comment.where(post_id: params[:id])
  end

  def create
    @article = Article.new(params.require(:article).permit(:url))
    usc = Urlscorechecker.new
    if @article.save
      score = usc.proceed(@article.url, @article.id)
      if score
        @article.update_attribute(:score, score)
      else
        flash[:alert] = "Something went wrong, check the url please."
        @article.destroy
      end
    else
      flash[:alert] = "Something went wrong, check the url please."
    end
    redirect_to  root_path
  end
end
