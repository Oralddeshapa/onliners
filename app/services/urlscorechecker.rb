require 'commentslist.rb'

class Urlscorechecker
  attr_reader :url, :id

  def proceed(url, id)
    @url = url
    @id = id
    article = Site.new(url)
    if article.working?
      score(url)
    else
      false
    end
  end

  private

  def score(url)
    comments_url = get_comments_url(url)
    top_comments = parse(comments_url)
    article_mood = 0
    top_comments.each do |comment|
      comment.update_attribute(:rating, get_mood(comment))
      if comment.rating == "Positive"
        article_mood += 1
      elsif comment.rating == "Negative"
        article_mood -= 1
      end
    end
    article_mood = article_mood * 100 / top_comments.count
  end

  def parse(url)
    data = JSON.parse(Faraday.get(url).body)
    comments = Commentslist.new(data["comments"], id)
    comments.top_n_comments(5)
  end

  def get_comments_url(url)
    html = URI.open(url)
    number = Nokogiri::HTML.parse(html).xpath('//span[@class="news_view_count"]/@news_id')
    "https://comments.api.onliner.by/news/tech.post/" + number.first.value.to_s + "/comments?limit=9999"
  end

  def get_mood(comment)
    Monkeylearn.configure do |c|
      c.token = '4c6b15ad7919c41d43859464adaac24334f59636'
    end
    data = [comment.text]
    model_id = 'cl_pi3C7JiL'
    result = Monkeylearn.classifiers.classify(model_id, data)
    result.result[0][0][0]["label"]
  end
end
