require_relative 'form'

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::CollectionSeparatable
  include Mongoid::Attributes::Dynamic

  index({ form_id: 1 }, { background: true })

  field :name, type: String

  belongs_to :form
  embeds_one :metainfo

  separated_by :form_id, parent_class: 'Form', on_condition: :entries_separated

end

