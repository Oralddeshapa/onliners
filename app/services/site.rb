require 'faraday'

class Site
  attr_reader :code, :url

  def initialize(url)
    @url = url
  end

  def working?
    @start = Time.now
    res = Faraday.get url
    @finish = Time.now
    @code = res.status
    if (200..399).include?(code)
      true
    elsif (400..499).include?(code)
      false
    end
  rescue
    nil
  end
end
