require_relative '../spec_helper'

class ::Post < Sequel::Model
  plugin :validation_class_methods
end
class ::Dummy < Sequel::Model
  plugin :validation_class_methods
end


class Minitest::SequelValidationsTest < Minitest::Spec
  
  describe Minitest::Spec do
    
    describe 'validations' do
      
      describe 'assert_validates()' do
        before do
          @c = Class.new(::Post) do
            validates_presence_of(:title)
          end
          @m = @c.new
        end
        
        it 'should raise no error when correctly validating Post#title' do
          proc {
            assert_validates(@m, :presence, :title)
          }.wont_have_error
        
          proc {
            @m.must_validate(:presence, :title)
          }.wont_have_error
        end
        
        it 'should raise an error when trying to validate invalid column' do
          e = /Column :does_not_exist is not defined in .*/
          proc {
            assert_validates(@m, :presence, :does_not_exist)
          }.must_have_error(e)
        
          proc {
            @m.must_validate(:presence, :does_not_exist)
          }.must_have_error(e)
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate(:presence, :title, { message: 'dummy' })
          }.must_have_error(/Expected .* to validate :presence for :title column with: { message: 'dummy' } but found: { message: 'is not present' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :presence for :author_id column, but no validations are defined for :author_id/
          proc {
            assert_validates(@m, :presence, :author_id)
          }.must_have_error(e)

          proc {
            @m.must_validate(:presence, :author_id)
          }.must_have_error(e)
        end
        
        it "should raise an error when invalid option(s) are passed" do
          e = /Expected .* to validate :presence for :title column, but the following invalid option\(s\) was found: { :completey_invalid;  }. Valid options are: \[:message\]/
          assert_error_raised(e) do
            assert_validates(@m, :presence, :title, { completey_invalid: :false } )
          end
          
          proc {
            @m.must_validate(:presence, :title, { completey_invalid: :false })
          }.must_have_error(e)
        end
        
        it 'should raise an error when the validation type is wrong for the column' do
          e = /Expected .* to validate :numericality for :title column, but no :numericality validation is defined for :title/
          assert_error_raised(e) do
            assert_validates(@m, :numericality, :title)
          end
          
          proc {
            @m.must_validate(:numericality, :title)
          }.must_have_error(e)
          
        end
        
        it 'should raise an eror when no validation is defined for the column' do
          e = /Expected .* to validate :presence for :id column, but no validations are defined for :id/
          assert_error_raised(e) do
            assert_validates(@m, :presence, :id)
          end
          
          proc {
            @m.must_validate(:presence, :id)
          }.must_have_error(e)
          
        end
        
        it 'should raise an eror when no validations are defined for the model' do
          e = /No validations defined in .*/
          @m = Class.new(::Dummy).new
          
          assert_error_raised(e) do
            assert_validates(@m, :presence, :id)
          end
          
          proc {
            @m.must_validate(:presence, :id)
          }.must_have_error(e)
          
        end
        
      end
      
      describe 'refute_validates_presence()' do
        before do
          @c = Class.new(::Post) do
            validates_presence_of(:title)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :title with :presence, but the column :title was validated with :presence/
          proc {
            refute_validates(@m, :presence, :title)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate(:presence, :title)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates(@m, :presence, :author_id)
          }.wont_have_error
          
          proc {
            @m.wont_validate(:presence, :author_id)
          }.wont_have_error
        end
        
        it 'should raise an error when trying to validate invalid column' do
          e = /Column :does_not_exist is not defined in .*/
          proc {
            refute_validates(@m, :presence, :does_not_exist)
          }.must_have_error(e)
        
          proc {
            @m.wont_validate(:presence, :does_not_exist)
          }.must_have_error(e)
        end
        
        
        it 'should raise an eror when no validations are defined for the model' do
          e = /No validations defined in .*/
          @m = Class.new(::Dummy).new
          
          assert_error_raised(e) do
            refute_validates(@m, :presence, :id)
          end
          
          proc {
            @m.wont_validate(:presence, :id)
          }.must_have_error(e)
          
        end
        
      end
      
      
      describe 'assert_validates_presence()' do
        before do
          @c = Class.new(::Post) do
            validates_presence_of(:title)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the presence of Post#title' do
          proc {
            assert_validates_presence(@m, :title)
          }.wont_have_error
        
          proc {
            @m.must_validate_presence_of(:title)
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_presence_of(:title, { message: 'dummy' })
          }.must_have_error(/Expected .* to validate :presence for :title column with: { message: 'dummy' } but found: { message: 'is not present' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :presence for :author_id column, but no validations are defined for :author_id/
          proc {
            assert_validates_presence(@m, :author_id)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_presence_of(:author_id)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_presence()' do
        before do
          @c = Class.new(::Post) do
            validates_presence_of(:title)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :title with :presence, but the column :title was validated with :presence/
          proc {
            refute_validates_presence(@m, :title)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_presence_of(:title)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_presence(@m, :author_id)
          }.wont_have_error
          
          proc {
            @m.wont_validate_presence_of(:author_id)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_length()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the length of Post#title' do
          proc {
            assert_validates_length(@m, :title)
          }.wont_have_error
        
          proc {
            @m.must_validate_length_of(:title)
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_length_of(:title, { message: 'dummy' })
          }.must_have_error(/Expected .* to validate :length for :title column with: { message: 'dummy' } but found: { message: '' }/)
          
          proc {
            @m.must_validate_length_of(:title, { nil_message: 'dummy' })
          }.must_have_error(/Expected .* to validate :length for :title column with: { nil_message: 'dummy' } but found: { nil_message: 'is not present' }/)
          
          proc {
            @m.must_validate_length_of(:title, { too_long: 'dummy' })
          }.must_have_error(/Expected .* to validate :length for :title column with: { too_long: 'dummy' } but found: { too_long: 'is too long' }/)
          
          proc {
            @m.must_validate_length_of(:title, { too_short: 'dummy' })
          }.must_have_error(/Expected .* to validate :length for :title column with: { too_short: 'dummy' } but found: { too_short: 'is too short' }/)
          
          proc {
            @m.must_validate_length_of(:title, { wrong_length: 'dummy' })
          }.must_have_error(/Expected .* to validate :length for :title column with: { wrong_length: 'dummy' } but found: { wrong_length: 'is the wrong length' }/)
          
          proc {
            @m.must_validate_length_of(:title, { is: 10 })
          }.must_have_error(/Expected .* to validate :length for :title column with: { is: '10' } but found: { is: '' }/)
          
          proc {
            @m.must_validate_length_of(:title, { minimum: 10 })
          }.must_have_error(/Expected .* to validate :length for :title column with: { minimum: '10' } but found: { minimum: '' }/)
          
          proc {
            @m.must_validate_length_of(:title, { maximum: 20 })
          }.must_have_error(/Expected .* to validate :length for :title column with: { maximum: '20' } but found: { maximum: '' }/)
          
          proc {
            @m.must_validate_length_of(:title, { within: 10..20 })
          }.must_have_error(/Expected .* to validate :length for :title column with: { within: '10..20' } but found: { within: '' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :length for :author_id column, but no validations are defined for :author_id/
          proc {
            assert_validates_length(@m, :author_id)
          }.must_have_error(e)
        
          proc {
            @m.must_validate_length_of(:author_id)
          }.must_have_error(e)
        
        end
        
      end
      
      describe 'refute_validates_length()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :title with :length, but the column :title was validated with :length/
          proc {
            refute_validates_length(@m, :title)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_length_of(:title)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_length(@m, :author_id)
          }.wont_have_error
          
          proc {
            @m.wont_validate_length_of(:author_id)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_exact_length()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title, is: 10)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the exact length of Post#title' do
          proc {
            assert_validates_exact_length(@m, :title, 10)
          }.wont_have_error
          
          proc {
            @m.must_validate_exact_length_of(:title, 10)
          }.wont_have_error
          
          proc {
            @m.must_validate_length_of(:title, { is: 10 })
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_exact_length_of(:title, 10, { message: 'dummy' })
          }.must_have_error(/Expected .* to validate :length for :title column with: { message: 'dummy', is: '10' } but found: { message: '' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :length for :author_id column, but no validations are defined for :author_id/
          proc {
            assert_validates_exact_length(@m, :author_id, 10)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_exact_length_of(:author_id, 10)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_exact_length()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title, is: 10)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :title with :length, but the column :title was validated with :length/
          proc {
            refute_validates_exact_length(@m, :title, 10)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_exact_length_of(:title, 10)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_exact_length(@m, :author_id, 10)
          }.wont_have_error
          
          proc {
            @m.wont_validate_exact_length_of(:author_id, 10)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_min_length()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title, minimum: 10)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the minimum length of Post#title' do
          
          proc {
            assert_validates_min_length(@m, :title, 10)
          }.wont_have_error
          
          proc {
            @m.must_validate_min_length_of(:title, 10)
          }.wont_have_error
          
          proc {
            @m.must_validate_length_of(:title, { minimum: 10 })
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_min_length_of(:title, 10, { message: 'dummy' })
          }.must_have_error(/Expected .* to validate :length for :title column with: { message: 'dummy', minimum: '10' } but found: { message: '' }/)
          
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :length for :author_id column, but no validations are defined for :author_id/
          proc {
            assert_validates_min_length(@m, :author_id, 10)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_min_length_of(:author_id, 10)
          }.must_have_error(e)
          
        end
        
      end
      
      describe 'refute_validates_min_length()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title, minimum: 10)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :title with :length, but the column :title was validated with :length/
          proc {
            refute_validates_min_length(@m, :title, 10)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_min_length_of(:title, 10)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_min_length(@m, :author_id, 10)
          }.wont_have_error
          
          proc {
            @m.wont_validate_min_length_of(:author_id, 10)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_max_length()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title, maximum: 10)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the maximum length of Post#title' do
          proc {
            assert_validates_max_length(@m, :title, 10)
          }.wont_have_error
          
          proc {
            @m.must_validate_max_length_of(:title, 10)
          }.wont_have_error
          
          proc {
            @m.must_validate_length_of(:title, { maximum: 10 })
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_max_length_of(:title, 10, { message: 'dummy' })
          }.must_have_error(/Expected .* to validate :length for :title column with: { message: 'dummy', maximum: '10' } but found: { message: '' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :length for :author_id column, but no validations are defined for :author_id/
          proc {
            assert_validates_max_length(@m, :author_id, 10)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_max_length_of(:author_id, 10)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_max_length()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title, maximum: 10)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :title with :length, but the column :title was validated with :length/
          proc {
            refute_validates_max_length(@m, :title, 10)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_max_length_of(:title, 10)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_max_length(@m, :author_id, 10)
          }.wont_have_error
          
          proc {
            @m.wont_validate_max_length_of(:author_id, 10)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_length_range()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title, within: 10..20)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the length range of Post#title' do
          proc {
            assert_validates_length_range(@m, :title, 10..20)
          }.wont_have_error
          
          proc {
            @m.must_validate_length_range_of(:title, 10..20)
          }.wont_have_error
          
          proc {
            @m.must_validate_length_of(:title, { within: 10..20 })
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_length_range_of(:title, 10..20, { message: 'dummy' })
          }.must_have_error(/Expected .* to validate :length for :title column with: { message: 'dummy', within: '10..20' } but found: { message: '' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :length for :author_id column, but no validations are defined for :author_id/
          proc {
            assert_validates_length_range(@m, :author_id, 10..20)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_length_range_of(:author_id, 10..20)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_length_range()' do
        before do
          @c = Class.new(::Post) do
            validates_length_of(:title, within: 10..20)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :title with :length, but the column :title was validated with :length/
          proc {
            refute_validates_length_range(@m, :title, 10..20)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_length_range(@m, :author_id, 10..20)
          }.wont_have_error
          
          proc {
            @m.wont_validate_length_range_of(:author_id, 10..20)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_format()' do
        before do
          @c = Class.new(::Post) do
            validates_format_of(:title, with: /\w+/)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the format of Post#title' do
          proc {
            assert_validates_format(@m, :title)
          }.wont_have_error
          
          proc {
            @m.must_validate_format_of(:title)
          }.wont_have_error
          
          proc {
            @m.must_validate_format_of(:title, { with: /\w+/ })
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          regex = /^\w$/
          proc {
            @m.must_validate_format_of(:title, with: regex, message: 'dummy')
          }.must_have_error(/Expected .* to validate :format for :title column with: { message: 'dummy', with: '(.*)' } but found: { message: 'is invalid', with: '(.*)' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :format for :author_id column, but no validations are defined for :author_id/
          proc {
            assert_validates_format(@m, :author_id, with: /\w+/)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_format_of(:author_id, with: /\w+/)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_format()' do
        before do
          @c = Class.new(::Post) do
            validates_format_of(:title, with: /\w/)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :title with :format, but the column :title was validated with :format/
          proc {
            refute_validates_format(@m, :title, with: /\w/)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_format_of(:title, with: /\w/)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_format(@m, :author_id, with: /\w/)
          }.wont_have_error
          
          proc {
            @m.wont_validate_format_of(:author_id, with: /\w/)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_inclusion()' do
        before do
          @c = Class.new(::Post) do
            validates_inclusion_of(:title, in: [:a, :b, :c])
          end
          @m = @c.new
        end
        
        it 'should correctly validate the inclusion of Post#title' do
          proc {
            assert_validates_inclusion(@m, :title, in: [:a, :b, :c])
          }.wont_have_error
          
          proc {
            @m.must_validate_inclusion_of(:title, in: [:a, :b, :c])
          }.wont_have_error
          
          proc {
            @m.must_validate_inclusion_of(:title, { in: [:a, :b, :c] })
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_inclusion_of(:title, in: ['a'], message: 'dummy')
          }.must_have_error(/Expected .* to validate :inclusion for :title column with: { message: 'dummy', in: '\[\"a\"\]' } but found: { message: 'is not in range or set: \[:a, :b, :c\]', in: '\[:a, :b, :c\]' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :inclusion for :author_id column, but no validations are defined for :author_id/
          proc {
            assert_validates_inclusion(@m, :author_id, in: [:a, :b, :c])
          }.must_have_error(e)
          
          proc {
            @m.must_validate_inclusion_of(:author_id, in: [:a, :b, :c])
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_inclusion()' do
        before do
          @c = Class.new(::Post) do
            validates_inclusion_of(:title, in: [:a, :b, :c])
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :title with :inclusion, but the column :title was validated with :inclusion/
          proc {
            refute_validates_inclusion(@m, :title, in: [:a, :b, :c])
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_inclusion_of(:title, in: [:a, :b, :c])
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_inclusion(@m, :author_id, in: [:a, :b, :c])
          }.wont_have_error
          
          proc {
            @m.wont_validate_inclusion_of(:author_id, in: [:a, :b, :c])
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_integer()' do
        before do
          @c = Class.new(::Post) do
            validates_numericality_of(:id, only_integer: true)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the integer of Post#id' do
          proc {
            assert_validates_integer(@m, :id)
          }.wont_have_error
          
          proc {
            @m.must_validate_integer_of(:id)
          }.wont_have_error
          
          proc {
            @m.must_validate_numericality_of(:id)
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_integer_of(:id, message: 'dummy')
          }.must_have_error(/Expected .* to validate :numericality for :id column with: { message: 'dummy', only_integer: 'true' } but found: { message: 'is not a number' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :numericality for :title column, but no validations are defined for :title/
          proc {
            assert_validates_integer(@m, :title)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_integer_of(:title)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_integer()' do
        before do
          @c = Class.new(::Post) do
            validates_numericality_of(:id, only_integer: true)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :id with :numericality, but the column :id was validated with :numericality/
          proc {
            refute_validates_integer(@m, :id)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_integer_of(:id)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_integer(@m, :author_id)
          }.wont_have_error
          
          proc {
            @m.wont_validate_integer_of(:author_id)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_numericality()' do
        before do
          @c = Class.new(::Post) do
            validates_numericality_of(:id)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the numericality of Post#id' do
          proc {
            assert_validates_numericality(@m, :id)
          }.wont_have_error
          
          proc {
            @m.must_validate_numericality_of(:id)
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_numericality_of(:id, message: 'dummy')
          }.must_have_error(/Expected .* to validate :numericality for :id column with: { message: 'dummy' } but found: { message: 'is not a number' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :numericality for :title column, but no validations are defined for :title/
          proc {
            assert_validates_numericality(@m, :title)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_numericality_of(:title)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_integer()' do
        before do
          @c = Class.new(::Post) do
            validates_numericality_of(:id)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :id with :numericality, but the column :id was validated with :numericality/
          proc {
            refute_validates_numericality(@m, :id)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_numericality_of(:id)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_numericality(@m, :author_id)
          }.wont_have_error
          
          proc {
            @m.wont_validate_numericality_of(:author_id)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_uniqueness()' do
        before do
          @c = Class.new(::Post) do
            validates_uniqueness_of(:urlslug)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the uniqueness of Post#urlslug' do
          proc {
            assert_validates_uniqueness(@m, :urlslug)
          }.wont_have_error
          
          proc {
            @m.must_validate_uniqueness_of(:urlslug)
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_uniqueness_of(:urlslug, message: 'dummy')
          }.must_have_error(/Expected .* to validate :uniqueness for :urlslug column with: { message: 'dummy' } but found: { message: 'is already taken' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :uniqueness for :title column, but no validations are defined for :title/
          proc {
            assert_validates_uniqueness(@m, :title)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_uniqueness_of(:title)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_uniqueness()' do
        before do
          @c = Class.new(::Post) do
            validates_uniqueness_of(:urlslug)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :urlslug with :uniqueness, but the column :urlslug was validated with :uniqueness/
          proc {
            refute_validates_uniqueness(@m, :urlslug)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_uniqueness_of(:urlslug)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_uniqueness(@m, :author_id)
          }.wont_have_error
          
          proc {
            @m.wont_validate_uniqueness_of(:author_id)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_acceptance()' do
        before do
          @c = Class.new(::Post) do
            validates_acceptance_of(:urlslug)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the acceptance of Post#urlslug' do
          proc {
            assert_validates_acceptance(@m, :urlslug)
          }.wont_have_error
          
          proc {
            @m.must_validate_acceptance_of(:urlslug)
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_acceptance_of(:urlslug, accept: 'f', message: 'dummy')
          }.must_have_error(/Expected .* to validate :acceptance for :urlslug column with: { message: 'dummy', accept: 'f' } but found: { message: 'is not accepted', accept: '1' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :acceptance for :title column, but no validations are defined for :title/
          proc {
            assert_validates_acceptance(@m, :title)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_acceptance_of(:title)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_acceptance()' do
        before do
          @c = Class.new(::Post) do
            validates_acceptance_of(:urlslug)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :urlslug with :acceptance, but the column :urlslug was validated with :acceptance/
          proc {
            refute_validates_acceptance(@m, :urlslug)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_acceptance_of(:urlslug)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_acceptance(@m, :author_id)
          }.wont_have_error
          
          proc {
            @m.wont_validate_acceptance_of(:author_id)
          }.wont_have_error
        end
        
      end
      
      
      describe 'assert_validates_confirmation()' do
        before do
          @c = Class.new(::Dummy) do
            validates_confirmation_of(:password)
          end
          @m = @c.new
        end
        
        it 'should correctly validate the confirmation of Dummy#password' do
          proc {
            assert_validates_confirmation(@m, :password)
          }.wont_have_error
          
          proc {
            @m.must_validate_confirmation_of(:password)
          }.wont_have_error
        end
        
        it 'should correctly validate provided options' do
          proc {
            @m.must_validate_confirmation_of(:password, message: 'dummy')
          }.must_have_error(/Expected .* to validate :confirmation for :password column with: { message: 'dummy' } but found: { message: 'is not confirmed' }/)
        end
        
        it 'should raise an error when the attribute is not being validated' do
          e = /Expected .* to validate :confirmation for :title column, but no validations are defined for :title/
          proc {
            assert_validates_confirmation(@m, :title)
          }.must_have_error(e)
          
          proc {
            @m.must_validate_confirmation_of(:title)
          }.must_have_error(e)
        end
        
      end
      
      describe 'refute_validates_confirmation()' do
        before do
          @c = Class.new(::Dummy) do
            validates_confirmation_of(:password)
          end
          @m = @c.new
        end
        
        it 'should report an error when column is validated' do
          e = /Expected .* NOT to validate :password with :confirmation, but the column :password was validated with :confirmation/
          proc {
            refute_validates_confirmation(@m, :password)
          }.must_have_error(e)
          
          proc {
            @m.wont_validate_confirmation_of(:password)
          }.must_have_error(e)
        end
        
        it 'should report no error when column is NOT validated' do
          proc {
            refute_validates_confirmation(@m, :title)
          }.wont_have_error
          
          proc {
            @m.wont_validate_confirmation_of(:title)
          }.wont_have_error
        end
        
      end
      
    end
    
  end
  
end
