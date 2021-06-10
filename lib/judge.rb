require 'nokogiri'
require 'open-uri'
require_relative 'site'

class Judge
  attr_reader :url

  def proceed(url)
    #news_view_count / news_id=""
    #unicode => URF-8
    @url = url
    article = Site.new(url)
    if article.working?
      score(url)
    else
      -1
    end
  end

  private

  def score(url)
    html = URI.open(url)
    doc = Nokogiri::HTML.parse(html)
    text = doc.at('body').text.split(",")
    parse(text)
  end

  def parse(data)
    ammount = data.count
    i = data.count
    until i < 2
      part = data[i - 1]
      if unused_text?(part, data[i - 2])
        data[i - 2] += part
        data.delete(part)
      elsif part.include?("text")
        unicode = part.split("\"")[3]
        decode_text(unicode)
      end
      i -= 1
    end
    out(data, "output_after.txt")
    data
  end

  def out(text, name)
    output = File.open(name,'w')
    text.each do |part|
      output.puts part
    end
    output.close
  end

  def unused_text?(part, before_part)
    if !part.include?("\":") and part.include?("\\")
      if before_part.include?("text") or (!before_part.include?("\":") and before_part.include?("\\"))
        true
      end
    else
      false
    end
  end

  def decode_text(text)
    p "\u0417\u0430\u0447\u0430\u0441\u0442\u0443".encode('utf-8')
    example =
    text = text.gsub("\\", '_\\').split("_")
    text.each do |word|
      number = word[2..5]
      word = "\u0417".gsub("\\", number)
      #%Q{'\u#{number}'}
    end
    #map{|part| part = part[2..-1].reverse.concat("\u").reverse.encode('utf-8')}.join("")
  end
end

judge = Judge.new
judge.proceed("https://comments.api.onliner.by/news/tech.post/539685/comments")
#p judge.proceed("http://www.cubecinema.com/programme")
