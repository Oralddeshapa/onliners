class CreateArticle
  include ActiveModel::Validations
  COMMENTS_LIMIT=5

  def call(article_params)
    @article = Article.new(article_params)
    old_article = Article.where(url: @article.url)
    if @article.url.include?('onliner')
      if old_article.present?
        message = "Reanalizing this url :D"
        @article = old_article[0]
        @article.touch
        @article.comments.destroy_all
      else
        message = "Article was successfully created and now being analized :D"
        @article.save
      end
      attach_comments
      ArticleWorker.perform_async(@article.id)
      true
    else
      errors.add(:article, "Site support only onliner articles")
      false
    end
  rescue Faraday::ConnectionFailed, URI::InvalidURIError
    errors.add(:article, "URL is not valid")
    false
  end

  def attach_comments
    @com_url ||= comments_url(@article.url)
    data = JSON.parse(Faraday.get(@com_url).body)
    comments_section = data["comments"]
    save_comments(comments_section.sort_by{|x| (x["marks"]["likes"] - x["marks"]["dislikes"])})
  end

  def comments_url(site_url)
    response = Faraday.get site_url
    html = response.body
    number = Nokogiri::HTML.parse(html).xpath('//span[@class="news_view_count"]/@news_id')
    "https://comments.api.onliner.by/news/tech.post/" + number.first.value.to_s + "/comments?limit=9999"
  end

  def save_comments(sorted_array)
    count = COMMENTS_LIMIT
    if sorted_array.count < count
      count = sorted_array.count - 1 # Cause last comment is numeric data not a comment
    end
    sorted_array.first(count).each do |comment|
      comment = @article.comments.create({text:comment["text"], author:comment["author"]["name"], likes:comment["marks"]["likes"], dislikes:comment["marks"]["dislikes"]})
    end
  end


end
