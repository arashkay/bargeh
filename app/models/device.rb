class Device < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true
  validates :device_type, presence: true, inclusion: { in: %w(ios android windows blackberry), message: 'should be one of these: ios, android, windows, blackberry' }
  validate :being_useful
  validates :device_id, uniqueness: { scope: :device_type }
   
  before_create :defaults

#METHODS
  
  def self.find_or_create_for(user_id, params)
    device = Device.new params.merge({user_id: user_id})
    return device unless device.valid?
    current = Device.where( { user_id: user_id, device_type: params[:device_type] } )
    if params[:device_id].blank?
      current = current.where( { notification_id: params[:notification_id] }).first
    else
      current = current.where( { device_id: params[:device_id] }).first
    end
    unless current.blank?
      current.update_attributes params
      return current 
    end
    device.save
    device
  end

private
  def being_useful
    errors[:base] << "Pass either of notification id or device id" if [self.notification_id, self.device_id].select{|i| i.blank?}.size==2
  end

  def defaults
    self.can_notify = true if self.can_notify.nil? 
  end

end
