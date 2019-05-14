require 'mongoid'
require 'mongoid/collection_separatable/monkey_patches'
require 'mongoid/collection_separatable/tasks/separate'
require 'active_support'
require 'mongoid/collection_separatable/version'
require 'mongoid/collection_separatable/railtie' if defined?(Rails)


module Mongoid
  module CollectionSeparatable
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :separated_field, :separated_condition_field, :separated_parent_class, :separated_parent_field, :separated_collection_prefix

      def separated_by separated_field, opts={}
        @separated_parent_class = opts[:parent_class].constantize
        @separated_parent_field = opts[:parent_field] || :id
        @separated_collection_prefix = opts[:prefix].to_s.presence || self.to_s.downcase.pluralize + '_'
        @separated_condition_field = opts[:on_condition]
        @separated_field = separated_field
        unless @separated_parent_class.fields.key?(@separated_condition_field)
          @separated_parent_class.class_eval <<-END
            field :#{@separated_condition_field}, type: Boolean
          END
        end
      end
    end

  end
end
