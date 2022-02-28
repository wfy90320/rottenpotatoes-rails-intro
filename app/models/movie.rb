class Movie < ActiveRecord::Base
    def self.ob_rate
        return self.pluck(:rating).uniq
    end
end
