class Form
  include Mongoid::Document

  field :collection_separated, type: Boolean

  has_many :entries
end
