require_relative 'comment'

class Comments
   attr_reader :all_comments, :relative_comments, :id

   def initialize(comments, id)
     @all_comments = comments
     @id = id
   end

   def prepare_relative_comments
     @relative_comments = []
     indexes = sort_by_rating
     p indexes.count
     count = 49
     if all_comments.count < 50
       count = all_comments.count - 1
     end
     p count
     for i in 0..count
       comment = all_comments[indexes[i][0]]
       comment = Comment.new(comment["text"], comment["author"]["name"], comment["marks"]["likes"], comment["marks"]["dislikes"], id)
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
