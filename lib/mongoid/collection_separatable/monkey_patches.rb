module BSON
  class ObjectId
    def to_json(*_args)
      to_s.to_json
    end

    def as_json(*_args)
      to_s.as_json
    end
  end
end

module Mongoid
  module Contextual
    private

    # Changes:
    # 1. Get form_id from selector
    # 2. If collection is entries, not matter from context or current collection object, and form has entries_separated flag set, set collection  name instance variable to entries plus form_id as new collection name
    # 3. It's not good because it will query form to check entries_separated flag exists or not each time. Hope to find a better way later

    def create_context_with_separated_entries
      context = create_context_without_separated_entries
      query_class = instance_variable_get :@klass
      if should_query_from_separated_collection? query_class
        new_collection_name = query_class.separated_collection_prefix + separated_value(query_class)
        # self.selector.except!('form_id')
        # filter = context.instance_variable_get(:@view).filter.except('form_id')
        # context.instance_variable_get(:@view).instance_variable_set :@filter, filter
        context.collection.instance_variable_set :@name, new_collection_name
        collection.instance_variable_set :@name, new_collection_name
      end
      instance_variable_set :@context, context
      context
    end

    def should_query_from_separated_collection? query_class
      return if !query_class.respond_to?(:separated_field) || !query_class.send(:separated_field)
      query_class.separated_parent_class.where(query_class.separated_parent_field => separated_value(query_class), query_class.separated_condition_field => true).exists?
    end

    def separated_value query_class
      selector[query_class.separated_field.to_s].to_s
    end

    alias create_context_without_separated_entries create_context
    alias create_context create_context_with_separated_entries
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
          query_class = cri.instance_variable_get :@klass
          if should_query_from_separated_collection? query_class
            context = cri.context.clone
            context.collection.instance_variable_set :@name, "#{query_class.separated_collection_prefix}#{base.id}"
            cri.instance_variable_set :'@collection', @collection
            # cri.selector.except!('form_id')
          end
          cri
        end

        def should_query_from_separated_collection?(query_class)
          query_class.respond_to?(:separated_field) && query_class.send(:separated_field) && base.is_a?(query_class.separated_parent_class) && base.send(query_class.separated_condition_field)
        end

        alias criteria_without_separated_entries criteria
        alias criteria criteria_with_separated_entries
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

