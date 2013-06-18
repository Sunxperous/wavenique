class User::Google < ActiveRecord::Base
  attr_accessible :site_id
  belongs_to :user, inverse_of: :youtube
  validates_presence_of :user, :site_id, :access_token, :refresh_token
  validates_uniqueness_of :site_id

  def self.sign_in(code)
    data, access_token, refresh_token = GoogleAPI.authentication(code)
    ug = self.new(site_id: data.id) unless ug = self.find_by_site_id(data.id)
    ug.build_user(name: data.name) if ug.new_record?
    ug.refresh_token = refresh_token if refresh_token.present?
		ug.access_token = access_token
    ug.save
		ug.user
  end
end

