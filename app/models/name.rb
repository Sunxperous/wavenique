class Name < ActiveRecord::Base
	attr_accessible :name
	belongs_to :artist

	validates :name, presence: true
end
