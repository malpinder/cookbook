class User < ActiveRecord::Base
  require 'digest/sha1'
  
  has_many :recipes
  has_many :comments

  attr_accessor :password
  attr_protected :salt

  validates_presence_of :username
  validates_uniqueness_of :username, :message => 'is already taken.'
  validates_length_of :username, :in => 6..16, :allow_nil => true
  validates_format_of :username, :with => /^[a-z0-9]+$/i, :message => 'must contain only letters and numbers.'

  validates_presence_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  validates_presence_of :password
  validates_length_of :password, :in => 6..24, :allow_nil => true
  validates_format_of :password, :with => /^.*\d+.*$/, :message => "must contain at least one digit."
  validates_format_of :password, :with => /[^\s]/, :message => "cannot contain spaces."
  validates_confirmation_of :password

  after_create :add_activation_code
  before_save :add_salt, :encrypt_password

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

  def add_salt
    return if password.nil?

    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    string = ""
    1.upto(10)  {|i| string << chars[rand(chars.size-1)] }

    self.salt = string
  end

  def encrypt_password
    return if password.nil?
    self.encrypted_password = Digest::SHA1.hexdigest(password+salt)
  end

end
