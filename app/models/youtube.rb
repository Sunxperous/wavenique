class Youtube < ActiveRecord::Base
	audited
	has_associated_audits
	attr_accessible :video_id
	has_many :performances, inverse_of: :youtube, conditions: { unlinked: false }

	validates :video_id, length: { is: 11 }, presence: true, uniqueness: { case_sensitive: true }
	validates_presence_of :performances
	validates_associated :performances

  attr_accessor :new_content

	def to_param
		video_id
	end

	def modify(p)
    # Cleanse performance hash.
    p[:perf].delete_if do |k, v|
      v["comp"].values.map { |comp_v| comp_v["t"].blank? }.include?(true)
    end
		# Validate video_id is embeddable and in Music category. And exists.
    transaction do
      self.new_content = Performance.new
      if !new_record?
        if !changes?(p[:perf].values)
          errors[:base] << "There are no changes."
          return false
        end
        if p[:timestamp] == associated_audits.last.created_at.to_s
          edit_performances(p[:perf])
          if performances.blank?
            raise ActiveRecord::Rollback
          end
        else
          errors[:base] << "Someone else has edited."
          return false
        end
      else
        add_performances(p[:perf])
      end
      self.new_content = nil
      save
    end
	end

	private
  def changes?(new_performances)
    new_compositions = new_performances.map do |v|
      v["comp"].values.map do |comp_v|
        comp_v["id"].blank? ? comp_v["t"] : comp_v["id"].to_i unless comp_v["t"].blank?
      end
    end
    compositions_changed = new_compositions != performances.map { |v| v.composition_ids }
    
    new_artists = new_performances.map do |v|
      v["artist"].values.map do |artist_v|
        artist_v["id"].blank? ? artist_v["n"] : artist_v["id"].to_i unless artist_v["n"].blank?
      end
    end
    artists_changed = new_artists != performances.map { |v| v.artist_ids }
    compositions_changed or artists_changed
  end

	def add_performances(performances_hash)
		performances_hash.values.each do |hash|
			performances << Performance.define_new(hash)
		end
    performances.each { |p| p.purge_new_duplicates }
	end

	def edit_performances(performances_hash)
		current_performances = performances.all
		if current_performances.length >= performances_hash.length # If there are more or equal existing performances...
			current_performances.zip(performances_hash.values) do |current, new|
				new.present? ? current.redefine(new) : current.unlink
			end
		else # There are less existing performances...
			performances_hash.values.zip(current_performances) do |new, current|
				if current.present?
					current.redefine(new)
				else
					performances << Performance.define_new(new)
				end
			end
		end
    performances.each { |p| p.purge_new_duplicates }
	end
end


