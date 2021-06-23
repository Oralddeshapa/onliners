module ArticleHelper
  def rating(comment)
    case
      when comment.rating > 0 then 'Positive'
      when comment.rating < 0 then 'Negative'
      else 'Neutral'
    end
  end
end
