class Comment
   attr_reader :text, :author, :rating, :likes, :dislikes, :post_id

   def initialize(text, author, likes, dislikes, id)
     @text = text
     @author = author
     @likes = likes
     @dislikes = dislikes
     @post_id = id
   end

   def to_s
     {"text" => text, "author" => author, "likes" => likes, "dislikes" => dislikes, "rating" => rating}
   end
end
