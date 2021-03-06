class Phone < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :image, presence: true
  belongs_to :vendor
  belongs_to :case_type
  belongs_to :phone_type
  belongs_to :platform
  belongs_to :screen_type
  belongs_to :touch_screen_type

  def self.by_vendor_url(vendor_url)
    includes(:vendor).where(vendors: {url: vendor_url})
  end

  def self.by_params(params)
    phones = Phone.scoped
    [:vendor_id, :phone_type_id, :case_type_id, :platform_id,
     :screen_type_id, :touch_screen_type_id].each do |property|
      unless params[property].blank?
        phones = phones.where(property => params[property])
      end
    end
    [:contain_touch_screen, :contain_3g, :contain_wifi, :contain_bluetooth, :contain_gps,
     :contain_memory_card, :contain_mp3_player, :contain_radio,
     :contain_camera, :contain_double_sim_support].each do |property|
      unless params[property].blank?
        phones = phones.where(property => param_to_boolean(params[property]))
      end
    end
    phones
  end

  private

  def self.param_to_boolean(param)
    if param == "1"
      true
    elsif param == "0"
      false
    end
  end
end
