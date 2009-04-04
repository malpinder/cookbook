class User < ActiveRecord::Base
  has_many :recipes
  has_many :comments

  validates_presence_of :username
  validates_uniqueness_of :username

  validates_presence_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  validates_presence_of :password
  validates_format_of :password, :with => /^.*\d+.*$/
  validates_confirmation_of :password

    def self.valid_user(attrs)
    username = attrs[:username] || ''
    password = attrs[:password] || ''

    self.find_by_username_and_password(username, password)
  end

end
