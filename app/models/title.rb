class Title < ActiveRecord::Base
	attr_accessible :title
	belongs_to :composition

	validates :title, presence: true
end
