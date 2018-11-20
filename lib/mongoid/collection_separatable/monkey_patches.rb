module Mongoid
  module Contextual

    private

    # Changes:
    # 1. Get form_id from selector
    # 2. If collection is entries, not matter from context or current collection object, and form has entries_separated flag set, set collection  name instance variable to entries plus form_id as new collection name
    # 3. It's not good because it will query form to check entries_separated flag exists or not each time. Hope to find a better way later

    def create_context_with_separated_entries
      context = create_context_without_separated_entries
      form_id = self.selector['form_id'].to_s
      if (collection.name == 'entries' || context.collection&.name == 'entries') && Form.where(id: form_id, collection_separated: true).exists?
        # self.selector.except!('form_id')
        # filter = context.instance_variable_get(:@view).filter.except('form_id')
        # context.instance_variable_get(:@view).instance_variable_set :@filter, filter
        context.collection.instance_variable_set :@name, "entries_#{form_id}"
        collection.instance_variable_set :@name, "entries_#{form_id}"
      end
      self.instance_variable_set :@context, context
      context
    end

    alias_method :create_context_without_separated_entries, :create_context
    alias_method :create_context, :create_context_with_separated_entries
  end
end

module Mongoid
  module Relations
    module Referenced

      class Many < Relations::Many

        private

        # Changes:
        # 1. 'base' should be an instance of Form
        # 2. If form has entries_separated flat and collection name is entries, clone a new context because it is build each time when called and set to context. Then remove form_id from selector because all the entries inside the new collection has the same form_id


        def criteria_with_separated_entries
          cri = criteria_without_separated_entries
          if base.is_a?(Form) && base.collection_separated && collection.name == 'entries'
            context = cri.context.clone
            context.collection.instance_variable_set :@name, "entries_#{base.id}"
            cri.instance_variable_set :'@collection', @collection
            # cri.selector.except!('form_id')
          end
          cri
        end

        alias_method :criteria_without_separated_entries, :criteria
        alias_method :criteria, :criteria_with_separated_entries
      end
    end
  end
end

module Mongoid

  # The +Criteria+ class is the core object needed in Mongoid to retrieve
  # objects from the database. It is a DSL that essentially sets up the
  # selector and options arguments that get passed on to a Mongo::Collection
  # in the Ruby driver. Each method on the +Criteria+ returns self to they
  # can be chained in order to create a readable criterion to be executed
  # against the database.
  class Criteria

    def ensured_collection
      context.collection
    end

  end
end
