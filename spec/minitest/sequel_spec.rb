require 'spec_helper'

module Minitest::Assertions
  
  # 
  def assert_returns_error(expected_msg, klass=Minitest::Assertion, &blk)
    e = assert_raises(klass) do
      yield
    end
    assert_equal expected_msg, e.message
  end
  
  # 
  def assert_no_error(&blk)
    e = assert_silent do
      yield
    end
  end
  
end

describe 'Minitest::Sequel' do
  
  
  it 'should have a VERSION' do
    refute_nil ::Minitest::Sequel::VERSION
  end
  
  
  describe '#assert_have_column' do
    
    let(:m) { Post.first }
    
    describe 'a valid column' do
      
      it { assert_have_column(m, :title, type: :string, db_type: 'varchar(255)', allow_null: true ) }
      
      it 'should raise no error without options' do
        assert_no_error { assert_have_column(m, :title) }
      end
      
      it 'should raise no error with options type: string' do
        assert_no_error { assert_have_column(m, :title, { type: :string } ) }
      end
      
      it "should raise no error with options type: string, db_type: 'varchar(255)' " do
        assert_no_error { assert_have_column(m, :title, { type: :string, db_type: 'varchar(255)' } ) }
      end
      
      it "should raise an error with incorrect options type: string, db_type: '" do
        assert_returns_error("Expected Post model to have column: :title with: { type: 'string', db_type: 'varchar(250)' } but found: { db_type: 'varchar(255)' }") do
          assert_have_column(m, :title, { type: :string, db_type: 'varchar(250)' } )
        end
      end
      
      it "should raise no error with options allow_null: true " do
        assert_no_error { assert_have_column(m, :title, { allow_null: true } ) }
      end
      
      it "should raise an error with incorrect options allow_null: :false" do
        assert_returns_error("Expected Post model to have column: :title with: { allow_null: 'false' } but found: { allow_null: 'true' }") do
          assert_have_column(m, :title, { allow_null: :false } )
        end
      end
      
      it "should raise no error with options default: nil " do
        assert_no_error { assert_have_column(m, :title, { default: :nil } ) }
      end
      
      it "should raise no error with options default: '1' " do
        assert_no_error { assert_have_column(m, :category_id, { default: '1' } ) }
      end
      
      it "should raise an error with incorrect options default: 'not nil'" do
        assert_returns_error("Expected Post model to have column: :title with: { default: 'not nil' } but found: { default: 'nil' }") do
          assert_have_column(m, :title, { default: 'not nil' } )
        end
      end
      
      it "should raise no error with options max_length: 255 " do
        assert_no_error { assert_have_column(m, :title, { max_length: 255 } ) }
      end
      
      it "should raise an error with incorrect options max_length: 200" do
        assert_returns_error("Expected Post model to have column: :title with: { max_length: '200' } but found: { max_length: '255' }") do
          assert_have_column(m, :title, { max_length: 200 } )
        end
      end
      
      it "should raise no error with options primary_key: :true " do
        assert_no_error { assert_have_column(m, :id, { primary_key: :true } ) }
      end
      
      it "should raise an error with incorrect options primary_key: false" do
        assert_returns_error("Expected Post model to have column: :id with: { primary_key: 'false' } but found: { primary_key: 'true' }") do
          assert_have_column(m, :id, { primary_key: :false } )
        end
      end
      
      it "should raise an error with incorrect options primary_key: 'invalid'" do
        assert_returns_error("Expected Post model to have column: :id with: { primary_key: 'invalid' } but found: { primary_key: 'true' }") do
          assert_have_column(m, :id, { primary_key: 'invalid' } )
        end
      end
      
      it "should raise no error with options auto_increment: :true " do
        assert_no_error { assert_have_column(m, :id, { auto_increment: :true } ) }
      end
      
      it "should raise an error with incorrect options auto_increment: false" do
        assert_returns_error("Expected Post model to have column: :id with: { auto_increment: 'false' } but found: { auto_increment: 'true' }") do
          assert_have_column(m, :id, { auto_increment: :false } )
        end
      end
      
    end #/ a valid column
    
    describe 'an invalid column' do
      
      it 'should raise error on a invalid column' do
        assert_returns_error('Expected Post model to have column: :does_not_exist but no such column exists') do
          assert_have_column(m, :does_not_exist)
        end
      end
      
    end
    
  end #/ assert_have_column
  
  
  describe 'assert_association' do
    
    it 'should raise no error on a correct association' do
      assert_no_error { assert_association(Post, :one_to_many, :comments) }
    end
    
    it 'should raise error on incorrect { Post, :many_to_one, :comment } association' do
      expected = "Expected Post to have a :many_to_one association :comment but no association ':comment' was found - \navailable associations are: [ {:attribute=>:author, :type=>:many_to_one, :class=>:Author, :keys=>[:author_id]}, {:attribute=>:comments, :type=>:one_to_many, :class=>:Comment, :keys=>[:post_id]}, {:attribute=>:categories, :type=>:many_to_many, :class=>:Category, :join_table=>:categories_posts, :left_keys=>[:post_id], :right_keys=>[:category_id]} ]\n"
      assert_returns_error(expected) do
        assert_association(Post, :many_to_one, :comment)
      end
    end
    
    it 'should raise error on incorrect { Post, :one_to_many, :comments ,options} association' do
      expected = "Expected Post to have a :one_to_many association :comments with given options: {:key=>:commentss_id} but should be {:key=>:post_id}"
      assert_returns_error(expected) do
        assert_association(Post, :one_to_many, :comments, { key: :commentss_id })
      end
    end
    
  end
  
  describe 'assert_association_one_to_many' do
    
    it 'should raise no error on a correct Post :comments association' do
      assert_no_error { assert_association_one_to_many(Post.first, :comments) }
    end
    
    it 'should raise error on incorrect { Post, :comment } association' do
      expected = "Expected Post to have a :one_to_many association :comment but no association ':comment' was found - \navailable associations are: [ {:attribute=>:author, :type=>:many_to_one, :class=>:Author, :keys=>[:author_id]}, {:attribute=>:comments, :type=>:one_to_many, :class=>:Comment, :keys=>[:post_id]}, {:attribute=>:categories, :type=>:many_to_many, :class=>:Category, :join_table=>:categories_posts, :left_keys=>[:post_id], :right_keys=>[:category_id]} ]\n"
      assert_returns_error(expected) do
        assert_association_one_to_many(Post.first, :comment, {})
      end
    end
    
    it 'should raise error on { Post, :comments } with incorrect options association' do
      expected = "Expected Post to have a :one_to_many association :comments with given options: {:class_name=>\"Comments\"} but should be {:class_name=>\"Comment\"}"
      assert_returns_error(expected) do
        assert_association_one_to_many(Post.first, :comments, { class_name: 'Comments' })
      end
    end
    
  end
  
  describe 'assert_association_many_to_one' do
    
    it 'should raise no error on a correct :many_to_one association { Comment, :post }' do
      assert_no_error { assert_association_many_to_one(Comment.first, :post) }
    end
    
    it 'should raise error on incorrect :many_to_one association { Comment, :posts }' do
      expected = "Expected Comment to have a :many_to_one association :posts but no association ':posts' was found - \navailable associations are: [ {:attribute=>:post, :type=>:many_to_one, :class=>:Post, :keys=>[:post_id]} ]\n"
      assert_returns_error(expected) do
        assert_association_many_to_one(Comment.first, :posts, {})
      end
    end
    
    it 'should raise error on :many_to_one association { Comments, :post } with incorrect options' do
      expected = "Expected Comment to have a :many_to_one association :post with given options: {:class_name=>\"Posts\"} but should be {:class_name=>\"Post\"}"
      assert_returns_error(expected) do
        assert_association_many_to_one(Comment.first, :post, { class_name: 'Posts' })
      end
    end
    
  end
  
  describe 'assert_association_many_to_many' do
    
    it 'should raise no error on a correct :many_to_many association { Category, :posts }' do
      assert_no_error { assert_association_many_to_many(Category.first, :posts) }
    end
    
    it 'should raise error on incorrect :many_to_many association { Category, :post }' do
      expected = "Expected Category to have a :many_to_many association :post but no association ':post' was found - \navailable associations are: [ {:attribute=>:posts, :type=>:many_to_many, :class=>:Post, :join_table=>:categories_posts, :left_keys=>[:category_id], :right_keys=>[:post_id]} ]\n"
      assert_returns_error(expected) do
        assert_association_many_to_many(Category.first, :post, {})
      end
    end
    
    it 'should raise error on :many_to_many association { Category, :posts } with incorrect options' do
      expected = "Expected Category to have a :many_to_many association :posts with given options: {:class_name=>\"Posts\"} but should be {:class_name=>\"Post\"}"
      assert_returns_error(expected) do
        assert_association_many_to_many(Category.first, :posts, { class_name: 'Posts' })
      end
    end
    
  end
  
  describe 'assert_association_one_to_one' do
    
    before do
      class Author < Sequel::Model
        one_to_one   :key_post, :class=>:Post, :order=>:id
      end
    end
    
    let(:a) { Author.first }
    
    it { assert_association_one_to_one(a, :key_post) }
    
    
    it 'should raise no error on a correct :one_to_one association { Author, :key_post }' do
      assert_no_error { assert_association_one_to_one(Author.first, :key_post) }
    end
    
    it 'should raise error on incorrect :one_to_one association { Author, :key_posts }' do
      expected = "Expected Author to have a :one_to_one association :key_posts but no association ':key_posts' was found - \navailable associations are: [ {:attribute=>:posts, :type=>:one_to_many, :class=>:Post, :keys=>[:author_id]}, {:attribute=>:key_post, :type=>:one_to_one, :class=>:Post, :keys=>[:author_id]} ]\n"
      assert_returns_error(expected) do
        assert_association_one_to_one(Author.first, :key_posts, {})
      end
    end

    it 'should raise error on :one_to_one association { Author, :key_post } with incorrect options' do
      expected = "Expected Author to have a :one_to_one association :key_post with given options: {:class_name=>\"Comments\"} but should be {:class_name=>\"Post\"}"
      assert_returns_error(expected) do
        assert_association_one_to_one(Author.first, :key_post, { class_name: 'Comments' })
      end
    end
    
  end
  
end
