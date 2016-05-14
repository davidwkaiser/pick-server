class User < ActiveRecord::Base

  validates   :soundcloud_id, presence: true, uniqueness: true
  has_many  :genre_selections
  has_many  :genres, through: :genre_selections
  has_many  :artist_roles
  has_many  :roles, through: :artist_roles

  has_many  :received_pickings, class_name: "Picking", foreign_key: :receiver_id
  has_many  :sent_pickings, class_name: "Picking", foreign_key: :sender_id

  has_many  :requested_picks, through: :sent_pickings, source: :receiver
  has_many  :pick_requests, through: :received_picks, source: :sender

  has_many  :searched_roles
  has_many  :s_roles, through: :searched_roles, source: :role

  def pickings
    pickings = []
    Picking.where(sender: self, status: true).each do |pic|
      pickings << pic.receiver
    end
    Picking.where(receiver: self, status: true).each do |pic|
      pickings << pic.sender
    end
    pickings.uniq
  end

  def pending_picks
    pickings = []
    self.sent_pickings.where(status: false).each do |pic|
      pickings << pic.receiver
    end
    self.received_pickings.where(status: false).each do |pic|
      pickings << pic.sender
    end
    pickings.uniq
  end

  def sent_requests
    requests = []
    Picking.where(receiver: self).find_each do |pic|
      requests << pic.sender
    end
    requests
  end

  def request(sender)
    Picking.where(sender: sender, receiver: self, status: false)
  end

  def is_picking?(user)
    Picking.where(sender: self, status: true).find_each do |pic|
      return true if pic.receiver === user
    end
    false
  end

  def destroy_data
    self.received_relationships.destroy_all
    self.sent_relationships.destroy_all
  end
end
