class Recipe < ActiveRecord::Base
  belongs_to :user

  has_many :comments, :dependent => :destroy
  has_many :amounts, :dependent => :destroy
  has_many :ingredients, :through => :amounts

  accepts_nested_attributes_for :amounts, :ingredients

  validates_presence_of :name, :course, :portions, :instructions
  validates_numericality_of :portions

  before_create :replace_new_ingredients_with_existing_records

  def course= value
    super value.downcase
  end

  def replace_new_ingredients_with_existing_records
    self.amounts.each do |amount|
      ingredient = Ingredient.find_by_name(amount.ingredient.name)
      unless ingredient.nil?
        amount.ingredient = ingredient
      end
    end
  end

  def self.courses
    %w(dessert snack breakfast main starter)
  end
  
end
