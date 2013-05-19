class Composition < ActiveRecord::Base
	audited

	attr_accessible :title

	validates :title, presence: true, length: { maximum: 100 }

	has_many :performance_compositions
	has_many :performances, through: :performance_compositions

	def self.existing_or_new(id, title, new_content)
    # Return empty array on missing title.
    return [] unless title.present?
    composition = self.where(id: id).first_or_initialize(title: title)
    # Return an existing composition from the database.
    return composition unless composition.new_record?
    recent = new_content[:compositions].select {
      |n| n.title == composition.title }.last
    # Return recent incoming, non-existent composition.
    return recent if recent.present?
    new_content[:compositions] << composition
    # Return an entirely new composition.
    composition
	end
end
