class ArticleWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(id)
    evaluate_comments(Article.find(id))
  end

  def evaluate_comments(article)
    comment_part = 100 / article.comments.count
    article.comments.each do |comment|
      comment.update(:rating => evaluate_text(comment.text) * comment_part)
    end
    score = article.comments.inject (0) { |score, comment| score + comment["rating"]}
    article.update(:score => score)
  end

  def evaluate_text(text)
    model_id = Rails.application.credentials.monkeylearn_api_model_id!
    result = Monkeylearn.classifiers.classify(model_id, [text])
    case result.result[0][0][0]["label"]
      when 'Positive' then 1
      when 'Negative' then -1
      else 0
    end
  end
end
