require_relative 'form'

class Entry
  include Mongoid::Document
  include Mongoid::CollectionSeparatable
  field :name, type: String

  belongs_to :form

  separated_by :form_id, parent_class: 'Form', on_condition: :entries_separated

end

