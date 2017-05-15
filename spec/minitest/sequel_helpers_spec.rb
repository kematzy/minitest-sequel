require_relative "../spec_helper"

describe Minitest::Spec do
  
  describe "a valid CRUD model" do

    it "can create" do
      assert_crud_can_create(::Post)
    end

    it "can read" do
      assert_crud_can_read(::Post)
    end

    it "can update" do
      assert_crud_can_update(::Post, :title)
    end

    it "can destroy" do
      assert_crud_can_destroy(::Post)
    end

  end

end
