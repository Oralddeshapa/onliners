class Commentslist
   attr_reader :all_comments, :relative_comments, :id

   def initialize(comments, id)
     @all_comments = comments
     @id = id
   end

   def top_n_comments(n)
     @relative_comments = []
     indexes = sort_by_rating
     if all_comments.count < n #if there is less then 50 comments
       n = all_comments.count - 2
     end
     for i in 0..n
       comment = all_comments[indexes[i][0]]
       comment = Comment.create({text:comment["text"], author:comment["author"]["name"], likes:comment["marks"]["likes"], dislikes:comment["marks"]["dislikes"], post_id:id})
       relative_comments.append comment
     end
     relative_comments
   end

   def sort_by_rating
     sort_pairs = {}
     i = 0
     all_comments.each do |comment|
       rating = comment["marks"]["likes"] - comment["marks"]["dislikes"]
       sort_pairs[i] = rating
       i += 1
     end
     sort_pairs = sort_pairs.sort_by {|key, value| value} # [rating, index in comments]
     sort_pairs.reverse!
   end
end
