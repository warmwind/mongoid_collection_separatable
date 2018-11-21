require 'mongoid'
require 'mongoid/collection_separatable/monkey_patches'
require 'active_support'
require 'mongoid/collection_separatable/version'


module Mongoid
  module CollectionSeparatable
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :separated_field, :separated_condition_field, :separated_parent_class, :separated_parent_field

      def separated_by separated_field, opts={}
        @separated_parent_class = opts[:parent_class].constantize
        @separated_parent_field = opts[:parent_field] || :id
        @separated_condition_field = opts[:on_condition]
        @separated_field = separated_field
        @separated_parent_class.class_eval %Q{
          field  :#{@separated_condition_field}, type: Boolean
        } unless @separated_parent_class.fields.key?(@separated_condition_field)
      end
    end

  end
end
