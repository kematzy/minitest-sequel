# frozen_string_literal: true

require_relative '../../../spec_helper'

class CrudParanoidPost < Sequel::Model
  plugin :paranoid

  def self.make
    create(title: 'Post Title')
  end
end

describe Minitest::Spec do
  describe 'a valid CRUD model' do
    it 'can create' do
      assert_no_error { assert_crud_can_create(Post) }
    end

    it 'can read' do
      assert_no_error { assert_crud_can_read(Post) }
    end

    it 'can update' do
      assert_no_error { assert_crud_can_update(Post, :title) }
    end

    it 'can destroy' do
      assert_no_error { assert_crud_can_destroy(Post) }
    end
  end

  describe 'a paranoid CRUD model' do
    it 'can create' do
      assert_no_error { assert_crud_can_create(CrudParanoidPost) }
    end

    it 'can read' do
      assert_no_error { assert_crud_can_read(CrudParanoidPost) }
    end

    it 'can update' do
      assert_no_error { assert_crud_can_update(CrudParanoidPost, :title) }
    end

    it 'can destroy' do
      assert_no_error { assert_crud_can_destroy(CrudParanoidPost) }
    end
  end
end
