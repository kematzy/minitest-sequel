require_relative "../spec_helper"

describe Minitest::Spec do

  describe "a .plugin(:timestamps) model" do

    it "should raise no error" do
      c = Class.new(::Post)
      c.plugin(:timestamps)
      proc { assert_timestamped_model(c, {title: "Dummy"}) }.wont_have_error
    end

    describe "#:created_at" do

      it "should raise no error when the :created_at column is present" do
        c = Class.new(::Post)
        c.plugin(:timestamps)
        proc { assert_timestamped_model(c, {title: "Dummy"}) }.wont_have_error
      end

      it "should raise an error when the :created_at column is missing" do
        c = Class.new(::CreatedPost)
        c.plugin(:timestamps)
        e = %r{Expected .* model to have column: :created_at but no such column exists}
        proc { assert_timestamped_model(c, {title: "Dummy"}) }.must_have_error(e)
      end

      it "should be a timestamp on a new model" do
        c = Class.new(::Post)
        c.plugin(:timestamps)
        mi = c.create(title: "Dummy", created_at: nil)
        proc { assert_timestamped_model_instance(mi) }.wont_have_error
      end

      # it 'should be a timestamp on a new model msdlfajfasj' do
      #   c = Class.new(::Post)
      #   c.plugin(:timestamps)
      #   mi = c.create(title: 'Dummy')
      #   proc { assert_timestamped_model_instance(mi) }.wont_have_error
      # end

    end

    describe "#:updated_at" do

      it "should raise no error when the :updated_at column is present" do
        c = Class.new(::Post)
        c.plugin(:timestamps)
        proc { assert_timestamped_model(c, {title: "Dummy"}) }.wont_have_error
      end

      it "should raise an error when the :updated_at column is missing" do
        c = Class.new(::UpdatedPost)
        c.plugin(:timestamps)
        e = %r{Expected .* model to have column: :updated_at but no such column exists}
        proc { assert_timestamped_model(c, {title: "Dummy"}) }.must_have_error(e)
      end

      it "should be a nil on a new model" do
        c = Class.new(::Post)
        c.plugin(:timestamps)
        mi = c.create(title: "Dummy")
        proc { assert_timestamped_model_instance(mi, updated_record: false) }.wont_have_error
      end

      it "should raise an error if :updated_at is not nil on a new model" do
        c = Class.new(::Post)
        c.plugin(:timestamps)
        mi = c.create(title: "Dummy", updated_at: Time.now )
        proc {
          assert_timestamped_model_instance(mi, updated_record: false)
        }.must_have_error(/AssertTimestampedModelInstance:updated - expected #updated_at to be NIL on new record/)
      end

      it "should be a timestamp on an updated model" do
        c = Class.new(::Post)
        c.plugin(:timestamps)
        mi = c.create(title: "Dummy")
        mi.update(title: "updated")
        mi.save
        mi.updated_at.wont_be_nil
        proc { assert_timestamped_model_instance(mi, updated_record: true) }.wont_have_error
      end

    end

  end

  describe "a NON .plugin(:timestamps) model" do

    it "should raise an error" do
      c = Class.new(::Post)
      e = "Not a plugin(:timestamps) model, available plugins are: [\"Sequel::Model\", \"Sequel::Model::Associations\", \"Sequel::Plugins::ValidationClassMethods\"]"
      proc { assert_timestamped_model(c, {title: "Dummy"}) }.must_have_error(e)
    end

  end





  # describe 'a valid timestamped model' do
  #
  #   it 'should not raise any errors' do
  #     c = Class.new(::Post)
  #     c.plugin(:timestamps)
  #     proc { assert_timestamped_model(c, {title: 'Dummy'}) }.wont_have_error
  #   end
  #
  #   # it_must_be_a_timestamped_model(Post) do
  #   #   Post.plugin(:timestamps)
  #   #   @m = Post.create(title: 'it works')
  #   # end
  #
  # end
  #
  # describe 'a non-timestamped model' do
  #
  #   it 'should raise error - :created_at nil' do
  #     e = %r{:created_at should be a timestamp, but was \[nil\];}
  #     c = Class.new(::Post)
  #     proc { assert_timestamped_model(c, {title: 'Dummy'}) }.must_have_error(e)
  #   end
  #
  #   it 'should raise error - :created_at nil' do
  #     e = 'e' #%r{:created_at should be a timestamp, but was \[nil\];}
  #     c = Class.new(::Post)
  #     proc { assert_timestamped_model(c, {title: 'Dummy', created_at: Time.now }) }.must_have_error(e)
  #   end
  #
  #   # it_must_be_a_timestamped_model(Dummy) { @m = Dummy.create(title: 'it fails') }
  #
  # end


  describe "ClassMethods" do
    before do
      @c = Class.new(::Minitest::Spec)

    end

    # it 'shoudl...' do
    #   @c.methods.sort.must_equal 'd'
    # end

    it "should..." do
      # proc { @c.it_must_be_a_timestamped_model(Post) { @m = Post.create } }.must_equal 'd'
      # @c.class_eval { it_must_be_a_timestamped_model(Post) { @m = Post.create } }.must_equal 'd'
    end



  end


  # describe 'Assertions' do
  #
  #   describe '#.assert_valid_model' do
  #
  #     it 'should raise no error on a valid model' do
  #       proc { assert_valid_model(Post.new) }.wont_have_error
  #     end
  #
  #     it 'should raise an error on a invalid model' do
  #       proc { assert_valid_model(Dummy.new) }.must_have_error('e')
  #     end
  #
  #   end
  #
  # end
  #
  #
  # describe '.plugin(:timestamps)' do
  #
  #   before do
  #     @c = Class.new(Post)
  #     @c1 = @c.dup
  #     @c.plugin(:timestamps)
  #
  #     @d = Class.new(Dummy)
  #   end
  #
  #   describe 'a timestamped model' do
  #     # Post.plugin(:timestamps)
  #
  #     it '...' do
  #       assert_output('e','c') { assert_timestamped_model(@d, {}) }
  #     end
  #     # it_must_be_timestamped_model(Post) do
  #     #   @m = @c.create
  #     # end
  #
  #   end
  #
  #   describe 'a non-timestamped model' do
  #
  #     # it '' do
  #     #   instance_exec {
  #     #     Minitest::Spec.it_must_be_timestamped_model(Comment) do
  #     #       @m = Comment.create
  #     #     end
  #     #   }.must_have_error 'e'
  #     # end
  #
  #   end
  #
  # end

end





#
# module Minitest::Assertions
#
#   def fuck_my_ass_instance(&blk)
#     a = instance_eval do
#       yield(blk)
#     end
#   end
#
#   def fuck_my_ass_class(&blk)
#     a = Minitest::Spec.class_eval do
#       yield(blk)
#     end
#   end
#   def fuck_my_ass_module(&blk)
#     a = Minitest::Spec.module_eval do
#       yield(blk)
#     end
#   end
# end
#
#
# # class ThisFuckingShit < Minitest::Test
# #
# #   def test_gofuckyourself
# #
# #     # # proc {
# #     #   fuck_my_ass_instance do
# #     #     Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #     #   end
# #     #
# #       fuck_my_ass_class do
# #         it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #       end
# #
# #       fuck_my_ass_module do
# #         Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #       end
# #     # }.must_have_error 'e'
# #     # a = instance_eval do
# #     #   Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #     # end
# #     # assert_equal('fuck', a)
# #   end
#
# #
# #   # def test_gofuckyourself
# #   #   a = Minitest::Spec.class_eval {
# #   #     it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #   #   }
# #   #   assert_equal('fuck', a)
# #   # end
# #
# #   # def test_gofuckyourself
# #   #   a = Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #   #   assert_equal('fuck', a)
# #   # end
# #
# #   # def test_gofuckyourself
# #   #   Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #   #   # assert_equal('fuck', a)
# #   # end
# #
# #   # def test_gofuckyourself
# #   #   a = Minitest::Spec.instance_eval {
# #   #     it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #   #   }
# #   #   assert_equal('fuck', a)
# #   # end
# #   #
# # end
#
#
# describe Minitest::Spec do
#
#   # it 'a' do
#   #   Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
#   # end
#
#
#   #   proc {
#   #     proc {
#   #       Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
#   #     }.call #.must_have_error('f')
#   #   }.call.must_equal 'fuck'
#   # end
#   #
# end
#
#
# # class Minitest::SequelPluginsTest < Minitest::Spec
#
# #   describe Minitest::Spec do
# #
# #     describe 'plugins' do
# #
# #       describe '.plugin(:timestamps)' do
# #         Post.plugin(:timestamps)
# #
# #         # it_must_be_timestamped_model(Post) do
# #         #   @m = Post.create
# #         # end
# #
# #         # before do
# #         # # it_must_be_timestamped_model(Comment) do
# #         # #   @m = Comment.create
# #         # # end
# #         # # @a = 'fuckiangdsalgdjlasdgdlgjaldsjgflkadfklsadflkadfslkjelkj'
# #         #   @a = Minitest::Spec.class_eval do
# #         #     proc {
# #         #       # Comment.new.must_respond_to(:fuckmyass)
# #         #       it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #         #     }.call
# #         #
# #         #     #
# #         #   end
# #         # end
# #
# #
# #         it 'shfofudsalfdsalfdsjafldjasdflkadflkjsdalkfasd,jfdsjkfwdsjklxadskljdsfklsdjfal ds' do
# #
# #           # proc {
# #           #   Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #           # }.must_output('d', 'e')
# #
# #           # proc {
# #           #   Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #           # }.must_equal 'd'
# #
# #           # proc {
# #           #   Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #           # }.call.must_equal 'd'
# #
# #
# #           # Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #           # # .must_output('d', 'e')
# #
# #
# #         end
# #
# #
# #
# #
# #
# #
# #
# #
# #
# #
# #
# #
# #
# #
# #         # it 'should.....' do
# #         #   a = Minitest::Spec.it_must_be_timestamped_model(Comment) { @m = Comment.create }
# #         #   a.must_equal 'd'
# #         #   # @a.must_equal 'd'
# #         # end
# #
# #         it 'should...' do
# #           # proc {
# #             # c = Minitest::Spec
# #
# #             # proc {
# #               # c.instance_eval do
# #                 # Minitest::Spec.
# #                 # it_must_be_timestamped_model(Comment) do
# #                 #   @m = Comment.create
# #                 # end
# #               # end
# #             # }.must_output('e')
# #         end
# #
# #         # before do
# #         #   @c = Class.new(Post)
# #         #   @c1 = @c.dup
# #         #   @c.plugin(:timestamps)
# #         #
# #         #   @d = Class.new(Dummy)
# #         # end
# #         #
# #         # it 'should raise no error for a timestamped model' do
# #         #   proc { assert_timestamped_model(@c, {}) }.wont_have_error
# #         # end
# #         #
# #         # it 'should raise an error for a non-timestamped model' do
# #         #   e  = 'dummy'
# #         #   proc {
# #         #     assert_timestamped_model(@c1, { created_at: Time.now })
# #         #   }.must_have_error(e)
# #         # end
# #         #
# #         # it 'should raise an error for a non-timestamped model without a :created_at column' do
# #         #   e  = /Expected .* model to have column: :created_at but no such column exists/
# #         #   proc {
# #         #     assert_timestamped_model(@d, {})
# #         #   }.must_have_error(e)
# #         # end
# #
# #         # before do
# #         #   @c = Class.new(Minitest::Spec)
# #         #   @c.extend(SequelPluginsVerfication)
# #         #   @m = @c.new
# #         # end
# #         #
# #         # it 'should ....' do
# #         #   # @c.methods.sort.must_equal 'd'
# #         #   # @m.methods.sort.must_equal 'd'
# #         # end
# #
# #       end
# #
# #
# #     end
# #
# #
# #
# #
# #
# #     # module ::T; self.extend(SequelPluginsVerfication); end
# #
# #
# #
# #
# #     describe 'testing methods' do
# #
# #
# #
# #       # it { assert_timestamped_model(Post) }
# #       # before do
# #       #   # @c = T.new
# #       # end
# #
# #       it 'should do somethings' do
# #         # SequelPluginsVerfication.methods.sort.must_equal 'd'
# #
# #         # proc {
# #           # SequelPluginsVerfication.verify_is_a_timestamped_model(Dummy)
# #         # }.must_have_error('e')
# #
# #
# #         # @c.methods.sort.must_equal 'd'
# #         # assert_output('e', 'd') { @c.verify_is_a_timestamped_model(Post, { title: 'Dummy', body: 'Default'}) }
# #
# #         # out, err = capture_io do
# #         #   @c.verify_is_a_timestamped_model(Post, { title: 'Dummy', body: 'Default'})
# #         # end
# #
# #         # assert_match %r%info%, out
# #         # assert_match %r%bad%, err
# #         # proc {
# #         #   @c.verify_is_a_timestamped_model(Post, { title: 'Dummy', body: 'Default'})
# #         # }.must_have_error('e')
# #
# #         # @c.verify_is_a_timestamped_model(Post).must_equal 'd'
# #         # @c.verify_is_a_timestamped_model(Post, { title: ('Dummy', body: 'Default'}).must_equal 'd'
# #
# #
# #         # proc {
# #         #   T.verify_is_a_timestamped_model(Dummy)
# #         # }.must_have_error('e')
# #       end
# #
# #     end
# # #     # proc {
# # #       verify_is_a_timestamped_model(Post)
# # #       verify_is_a_timestamped_model(Dummy)
# # #     # }.must_have_error('e')
# # #
# # #     describe 'testing DB plugins' do
# # #
# # #       describe '.verify_is_a_timestamped_model()' do
# # #
# # #         it 'should...' do
# # #           # methods.sort.must_equal 'd'
# # #           # proc {
# # #             # verify_is_a_timestamped_model(Post)
# # #           # }.wont_have_error
# # #         end
# # #
# # #         it 'should...' do
# # #           # methods.sort.must_equal 'd'
# # #           # assert_output('e','d') {
# # #             # verify_is_a_timestamped_model(Dummy)
# # #           # }
# # #         end
# # #
# # #       end
# # #
# # #     end
# #
# #   end
#
# # end
