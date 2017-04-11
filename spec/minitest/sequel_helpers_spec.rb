require_relative "../spec_helper"


describe Minitest::Spec do

  describe "#ensure_working_CRUD(:Model, :attribute)" do

    it "should return true for a valid working Model" do
      proc { Minitest::Spec.ensure_working_CRUD(Post, :title) }.wont_have_error
    end

  end

end
