class ArticleWorker
  include Sidekiq::Worker

  def perform(id)
    evaluate_comments(Article.find(id))
  end

  def evaluate_comments(article)
    comment_part = 100 / article.comments.count
    score = 0
    article.comments.each do |comment|
      comment.update(:rating => evaluate_text(comment.text) * comment_part)
      score += comment.rating
    end
    article.update(:score => score)
  end

  def evaluate_text(text)
    Monkeylearn.configure do |c|
      c.token = Rails.application.credentials.monkeylearn_api_token!
    end
    data = [text]
    model_id = 'cl_pi3C7JiL'
    result = Monkeylearn.classifiers.classify(model_id, data)
    mood = result.result[0][0][0]["label"]
    if mood == "Positive"
      1
    elsif mood == "Negative"
      -1
    else
      0
    end
  end
end
