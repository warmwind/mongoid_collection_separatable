class Form
  include Mongoid::Document
  has_many :entries
end
