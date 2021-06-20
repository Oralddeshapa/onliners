class CreateArticle
  TOP=3

  def call(article_params)
    @article = Article.new(article_params)
    if Article.where(url: @article.url).count != 0
      message = "Reanalizing this url :D"
      @article = Article.where(url: @article.url)[0]
      @article.touch
      @article.comments.each do |comment|
        comment.destroy
      end
    else
      message = "Article was successfully created and now being analized :D"
      res = Faraday.get @article.url
      @article.save
    end
    attach_comments
    ArticleWorker.perform_async(@article.id)
    message
  rescue Faraday::ConnectionFailed, URI::InvalidURIError
    "SHOCK URL NE URL D:"
  end

  def attach_comments
    @com_url ||= comments_url(@article.url)
    data = JSON.parse(Faraday.get(@com_url).body)
    comments_section = data["comments"]
    save_comments(comments_section.sort_by{|x| (x["marks"]["likes"] - x["marks"]["dislikes"])})
  end

  def comments_url(site_url)
    html = URI.open(site_url)
    number = Nokogiri::HTML.parse(html).xpath('//span[@class="news_view_count"]/@news_id')
    "https://comments.api.onliner.by/news/tech.post/" + number.first.value.to_s + "/comments?limit=9999"
  end

  def save_comments(sorted_array)
    count = TOP
    if sorted_array.count < count #if there is less then TOP comments
      count = sorted_array.count - 2
    end
    count.times do |i|
      comment = sorted_array[i]
      comment = @article.comments.create({text:comment["text"], author:comment["author"]["name"], likes:comment["marks"]["likes"], dislikes:comment["marks"]["dislikes"]})
    end
  end


end
