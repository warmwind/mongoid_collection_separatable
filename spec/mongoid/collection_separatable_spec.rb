require 'spec_helper'

RSpec.describe Mongoid::CollectionSeparatable do
  def check_query_plan query_plan, form, query
    expect(query_plan['namespace']).to eq("mongoid_test.entries_#{form.id}")
    expect(query_plan['parsedQuery']).to eq(query)
  end

  describe 'included' do
    it 'set condition field on condition class' do
      field = Form.fields['entries_separated']
      expect(field).not_to be_nil
      expect(field.options[:type]).to eq(Mongoid::Boolean)
      expect(Entry.separated_field).to eq(:form_id)
      expect(Entry.separated_parent_class).to eq(Form)
      expect(Entry.separated_parent_field).to eq(:id)
      expect(Entry.separated_condition_field).to eq(:entries_separated)
      expect(Entry.separated_collection_prefix).to eq('entries_')
    end

    it 'use parent field from setting' do
      class MockEntry
        include Mongoid::Document
        include Mongoid::CollectionSeparatable
        field :name, type: String

        belongs_to :form

        separated_by :form_name, parent_class: 'Form', parent_field: :name, on_condition: :entries_separated, prefix: :own_prefix
      end

      expect(MockEntry.separated_parent_field).to eq(:name)
      expect(MockEntry.separated_collection_prefix).to eq('own_prefix')
    end
  end

  describe 'query and persist' do
    context 'fetch entries form entries collection when condition field is not set' do
      let(:form) {Form.create!}
      before do
        form.entries.create name: 'test'
      end

      it 'when query by association' do
        expect(form.entries.count).to eq(1)
      end

      it 'when explain query' do
        query_plan = form.entries.explain.to_h['queryPlanner']
        expect(query_plan['namespace']).to eq('mongoid_test.entries')
      end
    end

    context 'fetch entries from separated collections when condition field is true' do
      let(:form) {Form.create!}
      before do
        form.set entries_separated: true
        form.entries.create name: 'test'
      end

      it 'when query by association' do
        expect(form.entries.count).to eq(1)
      end

      it 'when query by class and provide object id and class' do
        expect(Entry.where(form_id: form.id).count).to eq(1)
        expect(Entry.where(form: form).count).to eq(1)
      end

      it 'when explain query' do
        query = form.entries.explain.to_h['queryPlanner']
        check_query_plan(query, form, {'form_id' => {'$eq' => form.id}})

        query = form.entries.where(name: 'test').explain.to_h['queryPlanner']
        check_query_plan(query, form, {'$and' => [{'form_id' => {'$eq' => form.id}}, {'name' => {'$eq' => 'test'}}]})

        query = Entry.where(form: form).explain.to_h['queryPlanner']
        check_query_plan(query, form, {'form_id' => {'$eq' => form.id}})

        query = Entry.where(form: form, name: 'test').explain.to_h['queryPlanner']
        check_query_plan(query, form, {'$and' => [{'form_id' => {'$eq' => form.id}}, 'name' => {'$eq' => 'test'}]})
      end

      it 'when aggregate and provide form id as match condition' do
        expect(form.entries.ensured_collection.name).to eq("entries_#{form.id}")
      end

    end

  end
end
