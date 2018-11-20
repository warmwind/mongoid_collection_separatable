class Entry
  include Mongoid::Document
  include Mongoid::CollectionSeparatable

  field :name, type: String

  belongs_to :form

  #separate_by :form_id, condition_by: :collection_separated
end
