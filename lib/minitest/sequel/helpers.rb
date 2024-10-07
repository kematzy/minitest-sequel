# frozen_string_literal: false

# require "minitest/sequel"
require 'minitest/assertions'

# reopening to add validations functionality
module Minitest
  # add support for Assert syntax
  module Assertions
    # Asserts that a model can be created successfully.
    #
    # @param model [Class] The model class to test.
    #
    # This method attempts to create a new instance of the given model
    # using the :make method (typically provided by a factory).
    # It then asserts that:
    # 1. The created instance is of the correct type.
    # 2. The instance has no errors after creation.
    #
    # @raise [Minitest::Assertion] If the assertions fail.
    #
    def assert_crud_can_create(model)
      m = model.send(:make)

      msg = "CRUD:create - expected #{m.class} to be an instance of #{model}"
      assert_instance_of(model, m, msg)

      msg = "CRUD:create - expected .errors to be empty, but was: [#{m.errors.inspect}]"
      assert_empty(m.errors, msg)
    end

    # Asserts that a model can be read successfully.
    #
    # @param model [Class] The model class to test.
    #
    # This method attempts to create a new instance of the given model
    # using the :make method, then retrieves the first record from the database.
    # It then asserts that:
    # 1. The created instance is of the correct type.
    # 2. The retrieved record is equal to the created instance.
    #
    # @raise [Minitest::Assertion] If the assertions fail.
    #
    def assert_crud_can_read(model)
      m = model.send(:make)
      res = model.send(:first)

      msg = "CRUD:read - expected #{res.class} to be an instance of #{model}"
      assert_instance_of(model, m, msg)

      assert_equal(m, res, "CRUD:read - expected [#{m.inspect}] to equal [#{res.inspect}]")
    end

    # Asserts that a model can be updated successfully.
    #
    # @param model [Class] The model class to test.
    # @param attr [Symbol, String] The attribute to update.
    #
    # This method attempts to create a new instance of the given model,
    # update a specific attribute, and then verify the update.
    #
    # @raise [Minitest::Assertion] If the assertions fail.
    #
    def assert_crud_can_update(model, attr)
      # Create a new instance of the model
      m = model.send(:make)

      # Generate a new value for the attribute by appending " Updated" to its current value
      tmp_str = "#{m.send(attr.to_sym)} Updated"

      # Retrieve the first record from the database
      res = model.send(:first)

      # Assert that the retrieved record matches the created instance
      assert_equal(m, res, "CRUD:update - expected [#{m.inspect}] to equal [#{res.inspect}]")

      # Update the attribute with the new value
      res.send(:"#{attr}=", tmp_str)
      res.save

      # Retrieve the updated record from the database
      res2 = model.send(:first)

      # Assert that the updated attribute matches the new value
      msg = "CRUD:update - expected [#{res2.send(attr.to_sym)}] to equal "
      msg << "the updated string: [#{tmp_str}]"

      assert_equal(tmp_str, res2.send(attr.to_sym), msg)
    end

    # Asserts that a model can be destroyed successfully.
    #
    # @param model [Class] The model class to test.
    #
    # This method tests the destroy functionality of a model, considering both
    # hard delete and soft delete (using :deleted_at) scenarios.
    #
    # @raise [Minitest::Assertion] If the assertions fail.
    #
    # rubocop:disable Metrics/MethodLength
    def assert_crud_can_destroy(model)
      # Create a new instance of the model
      m = model.send(:make)

      # 1. test for Paranoid plugin
      plugs = model.instance_variable_get(:@plugins).map(&:to_s)
      paranoid = plugs.include?('Sequel::Plugins::Paranoid')

      if paranoid
        # If the model uses soft delete (has :deleted_at), ensure it's initially nil
        msg = "CRUD:destroy - expected :deleted_at to be nil, but was [#{m.deleted_at}]"
        assert_nil(m.deleted_at, msg)

        assert(m.soft_delete, 'CRUD:soft_delete - expected m.soft_delete to return true')

        # For soft delete, :deleted_at should be set to a timestamp
        refute_nil(m.deleted_at, 'CRUD:destroy - expected m.deleted_at to be NOT be nil')

        msg = 'CRUD:destroy - expected m.deleted_at to be an instance of Time'
        assert_instance_of(Time, m.deleted_at, msg)
      else
        # Attempt to destroy the model instance
        assert(m.destroy, 'CRUD:destroy - expected m.destroy to return true')
      end

      # Try to retrieve the first record from the database after destruction
      res = model.send(:first)

      if paranoid
        # By default the paranoid record should be returned from the database
        msg = "CRUD:destroy - expected #{model}.first to NOT return nil, but was: [#{res.inspect}]"
        refute_nil(res, msg)
      else
        # By default the record should not be returned from the database
        msg = "CRUD:destroy - expected #{model}.first to return nil, but was: [#{res.inspect}]"
        assert_nil(res, msg)
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
  # /module Assertions
end

# reopening to add helpers functionality
# rubocop:disable Style/ClassAndModuleChildren
class Minitest::Spec < Minitest::Test
  # module MinitestSequelCRUD

  # Enables quick tests to ensure that the basic CRUD functionality is working correctly for a Model
  #
  #     let(:m) { User.make }
  #
  #     ensure_working_CRUD(User, :username)
  #
  # NOTE!
  #
  # * the passed `_model` argument must be the actual Model class and NOT a string or symbol
  # * the passed attribute `_attr` must be a String attribute or the tests will fail
  #
  # **DEPENDENCIES**
  #
  # this test depends upon being able to create a new model instance for each test via using
  # Sequel Factory's `#make()` method
  #
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.ensure_working_crud(model, attr)
    # rubocop:disable Metrics/BlockLength
    describe 'a valid CRUD model' do
      it "can create a #{model}" do
        m = model.send(:make)

        msg = "CRUD:create - expected #{m.class} to be an instance of #{model}"
        assert_instance_of(model, m, msg)

        msg = "CRUD:create - expected .errors to be empty, but was: [#{m.errors.inspect}]"
        assert_empty(m.errors, msg)
      end

      it "can read a #{model}" do
        m = model.send(:make)
        # res = model.send(:where, id: m.id)
        res = model.send(:first)
        # res = model[m.id]

        msg = "CRUD:read - expected #{res.class} to be an instance of #{model}"
        assert_instance_of(model, m, msg)

        msg = "CRUD:read - expected [#{m.inspect}] to equal [#{res.inspect}]"
        assert_equal(m, res, msg)
      end

      it "can update a #{model}" do
        m = model.send(:make)
        tmp_str = "#{m.send(attr.to_sym)} Updated"
        res = model.send(:first)
        # res = model[m.id]

        msg = "CRUD:update - expected [#{m.inspect}] to equal [#{res.inspect}]"
        assert_equal(m, res, msg)
        res.send(:"#{attr}=", tmp_str)
        res.save

        res2 = model.send(:first)
        # res2 = model[m.id]

        msg = "CRUD:update - expected [#{res2.send(attr.to_sym)}] to equal the "
        msg << "updated string: [#{tmp_str}]"

        assert_equal(tmp_str, res2.send(attr.to_sym), msg)
      end

      it "can destroy a #{model}" do
        m = model.send(:make)

        if m.respond_to?(:deleted_at)
          msg = "CRUD:delete - expected m.deleted_at to be nil, but was [#{m.deleted_at}]"
          assert_nil(m.deleted_at, msg)
        end

        assert(m.destroy, 'CRUD:delete - expected m.destroy to return true')
        res = model.send(:first)

        if m.respond_to?(:deleted_at)
          refute_nil(m.deleted_at, 'CRUD:delete - expected m.deleted_at to be NOT be nil')

          msg = 'CRUD:delete - expected m.deleted_at to be an instance of Time'
          assert_instance_of(Time, m.deleted_at, msg)
        else
          msg = "CRUD:delete - expected #{model}.first to return nil, but was: [#{res.inspect}]"
          assert_nil(res, msg)
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
# rubocop:enable Style/ClassAndModuleChildren
