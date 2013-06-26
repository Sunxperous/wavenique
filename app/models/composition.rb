class Composition < ActiveRecord::Base
	attr_accessible :title
	validates :title, presence: true, length: { maximum: 100 }
	has_many :performance_compositions
	has_many :performances, through: :performance_compositions

  def merge(target)
    update_attribute(:original_id, target)
    PerformanceComposition.where("composition_id = ?", id).update_all(:composition_id => target)
    Composition.where("original_id = ?", id).update_all(:original_id => target)
  end

  def original
    self.original_id or self.id
  end
end
