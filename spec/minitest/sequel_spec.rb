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

  end
  
end
