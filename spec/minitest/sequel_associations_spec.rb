require_relative "../spec_helper"

class Minitest::SequelAssociationsTest < Minitest::Spec

  describe Minitest::Spec do

    describe 'associations' do

      describe "#assert_association() & .must_have_association()" do
        before do
          @c = Class.new(::Post) do
            one_to_many :comments
          end
          @m = @c.new
        end

        it "should raise no error on a correct association" do
          assert_no_error { assert_association(@c, :one_to_many, :comments) }
          # ===
          proc { @c.must_have_association(:one_to_many, :comments) }.wont_have_error
        end

        it "should raise error on incorrect association" do
          expected =  /Expected .* to have a :many_to_one association :comment but no association ':comment' was found - \navailable associations are: \[ {:attribute=>:comments, :type=>:one_to_many, :class=>:Comment, :keys=>\[:.*_id\]} \]/
          assert_error_raised(expected) do
            assert_association(@c, :many_to_one, :comment)
          end

          proc {
            @c.must_have_association(:many_to_one, :comment)
          }.must_have_error(expected)
        end

        it "should raise error on valid association with incorrect options passed" do
          expected = /Expected .* to have a :one_to_many association :comments with given options: {:key=>:comments_id} but should be {:key=>:.*_id}/
          assert_error_raised(expected) do
            assert_association(@c, :one_to_many, :comments, { key: :comments_id })
          end

          proc {
            @c.must_have_association(:one_to_many, :comments, { key: :comments_id })
          }.must_have_error(expected)
        end

      end

      describe "assert_association_one_to_many() & .must_have_one_to_many_association()" do
        before do
          @c = Class.new(::Post) do
            one_to_many :comments
          end
          @m = @c.new
        end

        it "should raise no error on a correct association" do
          assert_no_error { assert_association_one_to_many(@m, :comments) }

          proc {
            @m.must_have_one_to_many_association(:comments)
          }.wont_have_error
        end

        it "should raise error on incorrect association" do
          expected = /Expected .* to have a :one_to_many association :comment but no association ':comment' was found - \navailable associations are: \[ {:attribute=>:comments, :type=>:one_to_many, :class=>:Comment, :keys=>\[:.*_id\]} \]/
          assert_error_raised(expected) do
            assert_association_one_to_many(@m, :comment, {})
          end

          proc {
            @m.must_have_one_to_many_association(:comment, {})
          }.must_have_error(expected)
        end

        it "should raise error on valid association with incorrect options passed" do
          expected = /Expected .* to have a :one_to_many association :comments with given options: {:class_name=>\"Comments\"} but should be {:class_name=>\"Comment\"}/
          assert_error_raised(expected) do
            assert_association_one_to_many(@m, :comments, { class_name: "Comments" })
          end

          proc {
            @m.must_have_one_to_many_association(:comments, { class_name: "Comments"})
          }.must_have_error(expected)
        end

      end

      describe "assert_association_many_to_one() & .must_have_many_to_one_association()" do
        before do
          @c = Class.new(::Comment) do
            many_to_one :post
          end
          @m = @c.new
        end

        it "should raise no error on a correct association" do
          assert_no_error { assert_association_many_to_one(@m, :post) }

          proc { @m.must_have_many_to_one_association(:post) }.wont_have_error
        end

        it "should raise error on incorrect association" do
          expected = /Expected .* to have a :many_to_one association :posts but no association ':posts' was found - \navailable associations are: \[ {:attribute=>:post, :type=>:many_to_one, :class=>:Post, :keys=>\[:.*_id\]} \]/
          assert_error_raised(expected) do
            assert_association_many_to_one(@m, :posts, {})
          end

          proc {
            @m.must_have_many_to_one_association(:posts, {})
          }.must_have_error(expected)
        end

        it "should raise error on valid association with incorrect options" do
          expected = /Expected .* to have a :many_to_one association :post with given options: {:class_name=>\"Posts\"} but should be {:class_name=>\"Post\"}/
          assert_error_raised(expected) do
            assert_association_many_to_one(@m, :post, { class_name: "Posts" })
          end

          proc {
            @m.must_have_many_to_one_association(:post, { class_name: "Posts" })
          }.must_have_error(expected)
        end

      end

      describe "assert_association_many_to_many() & .must_have_many_to_many_association()" do
        before do
          @c = Class.new(::Category) do
            many_to_many :posts
          end
          @m = @c.new
        end

        it "should raise no error on a correct association" do
          assert_no_error { assert_association_many_to_many(@m, :posts) }

          proc {
            @m.must_have_many_to_many_association(:posts)
          }.wont_have_error
        end

        it "should raise error on incorrect association" do
          expected = /Expected .* to have a :many_to_many association :post but no association ':post' was found - \navailable associations are: \[ {:attribute=>:posts, :type=>:many_to_many, :class=>:Post, :join_table=>:.*, :left_keys=>\[:(.*)_id\], :right_keys=>\[:(.*)_id\]} \]/
          assert_error_raised(expected) do
            assert_association_many_to_many(@m, :post, {})
          end

          proc {
            @m.must_have_many_to_many_association(:post, {})
          }.must_have_error(expected)
        end

        it "should raise error on valid association with incorrect options passed" do
          expected = /Expected .* to have a :many_to_many association :posts with given options: {:class_name=>\"Posts\"} but should be {:class_name=>\"Post\"}/
          assert_error_raised(expected) do
            assert_association_many_to_many(@m, :posts, { class_name: "Posts" })
          end

          proc {
            @m.must_have_many_to_many_association(:posts, { class_name: "Posts" })
          }.must_have_error(expected)
        end

      end

      describe "assert_association_one_to_one() & .must_have_one_to_one_association()" do
        before do
          @c = Class.new(::Author) do
            one_to_one :key_post, class: :Post, order: :id
          end
          @m = @c.new
        end

        it { assert_association_one_to_one(@m, :key_post) }
        it { @m.must_have_one_to_one_association(:key_post) }

        it "should raise no error on a correct association" do
          assert_no_error { assert_association_one_to_one(@m, :key_post) }

          proc {
            @m.must_have_one_to_one_association(:key_post)
          }.wont_have_error
        end

        it "should raise error on incorrect association" do
          expected = /Expected .* to have a :one_to_one association :key_posts but no association ':key_posts' was found - \navailable associations are: \[ {:attribute=>:key_post, :type=>:one_to_one, :class=>:Post, :keys=>\[:.*_id\]} \]/
          assert_error_raised(expected) do
            assert_association_one_to_one(@m, :key_posts, {})
          end

          proc {
            @m.must_have_one_to_one_association(:key_posts,{})
          }.must_have_error(expected)
        end

        it "should raise error on :one_to_one association { Author, :key_post } with incorrect options" do
          expected = /Expected .* to have a :one_to_one association :key_post with given options: {:class_name=>\"Comments\"} but should be {:class_name=>\"Post\"}/
          assert_error_raised(expected) do
            assert_association_one_to_one(@m, :key_post, { class_name: "Comments" })
          end

          proc {
            @m.must_have_one_to_one_association(:key_post,{ class_name: "Comments" })
          }.must_have_error(expected)
        end

      end


      describe "refute_association() & .wont_have_association()" do
        before do
          @c = Class.new(::Post) do
            many_to_one :comment
          end
          @m = @c.new
        end

        it "should raise no error on non-existant association" do
          assert_no_error { refute_association(@c, :one_to_many, :does_not_exist) }
          # ===
          proc { @c.wont_have_association(:one_to_many, :does_not_exist) }.wont_have_error
        end

        it "should raise error on existing association" do
          e =  /Expected .* to NOT have a :many_to_one association :comment, but such an association was found/
          assert_error_raised(e) do
            refute_association(@c, :many_to_one, :comment)
          end
          # ===
          proc {
            @c.wont_have_association(:many_to_one, :comment)
          }.must_have_error(e)
        end

      end

      describe "refute_association_one_to_many() & .wont_have_one_to_many_association()" do
        before do
          @c = Class.new(::Post) do
            one_to_many :comments
          end
          @m = @c.new
        end

        it "should raise no error on non-existant association" do
          assert_no_error { refute_association_one_to_many(@m, :does_not_exist) }
          # ===
          proc { @m.wont_have_one_to_many_association(:does_not_exist) }.wont_have_error
        end

        it "should raise error on existing association" do
          e =  /Expected .* to NOT have a :one_to_many association :comments, but such an association was found/
          assert_error_raised(e) do
            refute_association_one_to_many(@m, :comments)
          end
          # ===
          proc {
            @m.wont_have_one_to_many_association(:comments)
          }.must_have_error(e)
        end

      end

      describe "refute_association_many_to_one() & .wont_have_many_to_one_association()" do
        before do
          @c = Class.new(::Post) do
            many_to_one :author
          end
          @m = @c.new
        end

        it "should raise no error on non-existant association" do
          assert_no_error { refute_association_many_to_one(@m, :does_not_exist) }
          # ===
          proc { @m.wont_have_many_to_one_association(:does_not_exist) }.wont_have_error
        end

        it "should raise error on existing association" do
          e =  /Expected .* to NOT have a :many_to_one association :author, but such an association was found/
          assert_error_raised(e) do
            refute_association_many_to_one(@m, :author)
          end
          # ===
          proc {
            @m.wont_have_many_to_one_association(:author)
          }.must_have_error(e)
        end

      end

      describe "refute_association_many_to_many() & .wont_have_many_to_many_association()" do
        before do
          @c = Class.new(::Post) do
            many_to_many :authors
          end
          @m = @c.new
        end

        it "should raise no error on non-existant association" do
          assert_no_error { refute_association_many_to_many(@m, :does_not_exist) }
          # ===
          proc { @m.wont_have_many_to_many_association(:does_not_exist) }.wont_have_error
        end

        it "should raise error on existing association" do
          e =  /Expected .* to NOT have a :many_to_many association :authors, but such an association was found/
          assert_error_raised(e) do
            refute_association_many_to_many(@m, :authors)
          end
          # ===
          proc {
            @m.wont_have_many_to_many_association(:authors)
          }.must_have_error(e)
        end

      end

      describe "refute_association_one_to_one() & .wont_have_one_to_one_association()" do
        before do
          @c = Class.new(::Post) do
            one_to_one :first_comment
          end
          @m = @c.new
        end

        it "should raise no error on non-existant association" do
          assert_no_error { refute_association_one_to_one(@m, :does_not_exist) }
          # ===
          proc { @m.wont_have_one_to_one_association(:does_not_exist) }.wont_have_error
        end

        it "should raise error on existing association" do
          e =  /Expected .* to NOT have a :one_to_one association :first_comment, but such an association was found/
          assert_error_raised(e) do
            refute_association_one_to_one(@m, :first_comment)
          end
          # ===
          proc {
            @m.wont_have_one_to_one_association(:first_comment)
          }.must_have_error(e)
        end

      end

    end

  end

end
