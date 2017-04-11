require_relative "../spec_helper"


class Minitest::SequelHaveColumnTest < Minitest::Spec

  describe Minitest::Spec do

    describe "verify DB schema" do

      let(:m) { Post.new }

      describe "#assert_have_column & .must_have_column" do

        describe "a valid column" do

          it { assert_have_column(m, :title, type: :string, db_type: "varchar(255)", allow_null: true ) }
          it { m.must_have_column(:title, type: :string, db_type: "varchar(255)", allow_null: true ) }

          it "should raise no error with valid column and no options" do
            assert_no_error_raised { assert_have_column(m, :title) }
            proc{ assert_have_column(m, :title) }.wont_have_error

            proc{ m.must_have_column(:title) }.wont_have_error
          end

          it "should raise no error with options type: string" do
            assert_no_error { assert_have_column(m, :title, { type: :string } ) }

            proc { m.must_have_column(:title, { type: :string }) }.wont_have_error
          end

          it "should raise no error with options type: string, db_type: 'varchar(255)' " do
            assert_no_error_raised { assert_have_column(m, :title, { type: :string, db_type: "varchar(255)" } ) }

            proc { m.must_have_column(:title, {type: :string, db_type: "varchar(255)"}) }.wont_have_error
          end

          it "should raise an error with incorrect options type: string, db_type: '" do
            assert_error_raised("Expected Post model to have column: :title with: { type: 'string', db_type: 'varchar(250)' } but found: { db_type: 'varchar(255)' }") do
              assert_have_column(m, :title, { type: :string, db_type: "varchar(250)" } )
            end

            proc {
              m.must_have_column(:title, { type: :string, db_type: "varchar(250)" })
            }.must_have_error("Expected Post model to have column: :title with: { type: 'string', db_type: 'varchar(250)' } but found: { db_type: 'varchar(255)' }")
          end

          it "should raise no error with options allow_null: true " do
            assert_no_error { assert_have_column(m, :title, { allow_null: true } ) }

            proc { m.must_have_column(:title, { allow_null: true }) }.wont_have_error
          end

          it "should raise an error with incorrect options allow_null: :false" do
            assert_error_raised("Expected Post model to have column: :title with: { allow_null: 'false' } but found: { allow_null: 'true' }") do
              assert_have_column(m, :title, { allow_null: :false } )
            end

            proc {
              m.must_have_column(:title, { allow_null: :false })
            }.must_have_error(/have column: :title with: { allow_null: 'false' } but found: { allow_null: 'true' }/)
          end

          it "should raise no error with options default: nil " do
            assert_no_error { assert_have_column(m, :title, { default: :nil } ) }

            proc { m.must_have_column(:title, { default: :nil }) }.wont_have_error
          end

          it "should raise no error with options default: '1' " do
            assert_no_error { assert_have_column(m, :category_id, { default: "1" }) }

            proc { m.must_have_column(:category_id, { default: "1" }) }.wont_have_error
          end

          it "should raise an error with incorrect options default: 'not nil'" do
            assert_error_raised("Expected Post model to have column: :title with: { default: 'not nil' } but found: { default: 'nil' }") do
              assert_have_column(m, :title, { default: "not nil" } )
            end

            proc {
              m.must_have_column(:title, { default: "not nil" })
            }.must_have_error("Expected Post model to have column: :title with: { default: 'not nil' } but found: { default: 'nil' }")
          end

          it "should raise no error with options max_length: 255 " do
            assert_no_error { assert_have_column(m, :title, { max_length: 255 } ) }

            proc { m.must_have_column(:title, { max_length: 255 }) }.wont_have_error
          end

          it "should raise an error with incorrect options max_length: 200" do
            assert_error_raised("Expected Post model to have column: :title with: { max_length: '200' } but found: { max_length: '255' }") do
              assert_have_column(m, :title, { max_length: 200 } )
            end

            proc {
              m.must_have_column(:title, { max_length: 200 })
            }.must_have_error(/column: :title with: { max_length: '200' } but found: { max_length: '255' }/)
          end

          it "should raise no error with options primary_key: :true " do
            assert_no_error { assert_have_column(m, :id, { primary_key: :true } ) }

            proc { m.must_have_column(:id, { primary_key: :true }) }.wont_have_error
          end

          it "should raise an error with incorrect options primary_key: false" do
            assert_error_raised("Expected Post model to have column: :id with: { primary_key: 'false' } but found: { primary_key: 'true' }") do
              assert_have_column(m, :id, { primary_key: :false })
            end

            proc {
              m.must_have_column(:id, { primary_key: :false })
            }.must_have_error(/have column: :id with: { primary_key: 'false' } but found: { primary_key: 'true' }/)
          end

          it "should raise an error with incorrect options primary_key: 'invalid'" do
            assert_error_raised(/have column: :id with: { primary_key: 'invalid' } but found: { primary_key: 'true' }/) do
              assert_have_column(m, :id, { primary_key: "invalid" } )
            end

            proc {
              m.must_have_column(:id, { primary_key: "invalid" })
            }.must_have_error(/have column: :id with: { primary_key: 'invalid' } but found: { primary_key: 'true' }/)
          end

          it "should raise no error with options auto_increment: :true " do
            assert_no_error { assert_have_column(m, :id, { auto_increment: :true } ) }

            proc { m.must_have_column(:id, { auto_increment: :true }) }.wont_have_error
          end

          it "should raise an error with incorrect options" do
            e = /Expected .* model to have column: :id with: { auto_increment: 'false' } but found: { auto_increment: 'true' }/
            assert_error_raised(e) do
              assert_have_column(m, :id, { auto_increment: :false } )
            end

            proc {
              m.must_have_column(:id, { auto_increment: :false })
            }.must_have_error(e)

            e = /Expected .* model to have column: :id with: { type: 'string' } but found: { type: 'integer' }/
            proc {
              m.must_have_column(:id, { type: :string })
            }.must_have_error(e)
          end

          it "should raise an error when invalid option(s) are passed" do
            e = /Expected .* model to have column: :id, but the following invalid option\(s\) was found: { :completey_invalid;  }. Valid options are: \[:type, :db_type, :allow_null, :max_length, :default, :primary_key, :auto_increment\]/
            assert_error_raised(e) do
              assert_have_column(m, :id, { completey_invalid: :false } )
            end

            proc {
              m.must_have_column(:id, { completey_invalid: :false })
            }.must_have_error(e)
          end

        end #/ a valid column

        describe "an invalid column" do

          it "should raise error on a invalid column" do
            assert_error_raised("Expected Post model to have column: :does_not_exist but no such column exists") do
              assert_have_column(m, :does_not_exist)
            end

            proc {
              m.must_have_column(:does_not_exist)
            }.must_have_error(/have column: :does_not_exist but no such column exists/)
          end

        end

      end

      describe "#refute_have_column & .wont_have_column" do

        describe "a valid column" do

          it "should not raise an error on a non-existing column" do
            proc {
              m.wont_have_column(:does_not_exist)
            }.wont_have_error
          end

          it "should raise an error on an existing column" do
            proc {
              m.wont_have_column(:title)
            }.must_have_error("Expected Post model to NOT have column: :title but such a column was found")
          end
        end

        describe "an invalid column" do

          it "should NOT raise error on an invalid column" do
            assert_no_error_raised do
              refute_have_column(m, :does_not_exist)
            end

            proc {
              m.wont_have_column(:does_not_exist)
            }.wont_have_error
          end

        end

      end

    end

  end

end
