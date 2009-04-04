class Amount < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient

  accepts_nested_attributes_for :ingredient

  validates_presence_of :amount
end
