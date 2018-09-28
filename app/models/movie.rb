class Movie < ActiveRecord::Base
     def self.ratings
        self.uniq.order(:rating).pluck(:rating)
    end
end
