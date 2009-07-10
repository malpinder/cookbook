class User < ActiveRecord::Base
  has_many :recipes
  has_many :comments

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_length_of :username, :in => 6..16, :allow_nil => true
  validates_format_of :username, /^[A-Za-z0-9]+>$/i

  validates_presence_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  validates_presence_of :password
  validates_length_of :password, :in => 6..24, :allow_nil => true
  validates_format_of :password, :with => /^.*\d+.*$/, :message => "Must contain at least one digit."
  validates_format_of :password, :with => /[^\s]/, :message => "Cannot contain spaces."
  validates_confirmation_of :password

  after_create :add_activation_code

  def self.valid_user(attrs)
    username = attrs[:username] || ''
    password = attrs[:password] || ''

    self.find_by_username_and_password(username, password)
  end
  
  def add_activation_code
    self.activation_code = generate_random_string
    self.save
  end

  def generate_random_string
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    string = ""
    1.upto(10)  {|i| string << chars[rand(chars.size-1)] }
    return string
  end

end
