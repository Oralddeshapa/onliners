require 'nokogiri'
require 'open-uri'
require 'json'
require_relative 'site'
require_relative 'comments'
require 'faraday'

class Judge
  attr_reader :url, :id

  def proceed(url, id)
    #news_view_count / news_id=""
    #unicode => URF-8
    @url = url
    @id = id
    article = Site.new(url)
    if article.working?
      score(url)
    else
      -1
    end
  end

  private

  def score(url)
    comments_url = get_comments_url(url)
    parse(comments_url)
  end

  def parse(url)
    html = URI.open(url)
    doc = Nokogiri::HTML.parse(html).at('body')
    data = JSON.parse(doc)
    comments = Comments.new(data["comments"], id)
    out(comments.all_comments, "output.txt")
    top = comments.prepare_relative_comments
    out(top, "output_after.txt")
    data
  end

  def out(text, name)
    output = File.open(name,'w')
    text.each do |part|
      output.puts part.to_s
    end
    output.close
  end

  def get_comments_url(url)
    html = URI.open(url)
    number = Nokogiri::HTML.parse(html).xpath('//span[@class="news_view_count"]/@news_id')
    "https://comments.api.onliner.by/news/tech.post/" + number.first.value.to_s + "/comments?limit=9999"
  end
end

judge = Judge.new
#judge.proceed("https://comments.api.onliner.by/news/tech.post/539685/comments?limit=9999", 1)
judge.proceed("https://tech.onliner.by/2021/06/07/prezentaciya-apple-na-wwdc-2021-rasskazyvaem-o-glavnom", 1)
#p judge.proceed("http://www.cubecinema.com/programme")
