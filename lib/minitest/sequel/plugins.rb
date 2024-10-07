# frozen_string_literal: false

# reopening to add validations functionality
module Minitest
  # add support for Assert syntax
  module Assertions
    # Test if a model instance is timestamped via .plugin(:timestamps)
    #
    # This assertion checks if a given model instance has been properly timestamped
    # using the Sequel Timestamps plugin. It verifies the presence of the plugin,
    # the existence of the required columns, and the correct behavior of timestamps
    # for both new and updated records.
    #
    # @param model [Sequel::Model] The model instance to test
    # @param opts [Hash] Options to modify the assertion behavior
    # @option opts [Boolean] :updated_record Set to true to test an updated record
    #
    # @example Testing a new record
    #     let(:m) { Post.create(title: 'Dummy') }
    #     assert_no_error { assert_timestamped_model_instance(m) }
    #
    # @example Testing an updated record
    #     m.title = 'Updated'
    #     m.save
    #     assert_no_error { assert_timestamped_model_instance(m, updated_record: true) }
    #
    # @example Testing an incorrectly timestamped record
    #     let(:m) { Post.create(title: 'Dummy', updated_at: Time.now) }
    #
    #     msg = /expected #.updated_at to be NIL on new record/
    #
    #     assert_error_raised(msg) do
    #       assert_timestamped_model_instance(m, updated_record: false)
    #     end
    #
    # @raise [Minitest::Assertion] If the model instance does not meet the timestamped criteria
    #
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def assert_timestamped_model_instance(model, opts = {})
      model_class = model.class

      # 1. test for Timestamps plugin
      plugs = model_class.instance_variable_get(:@plugins).map(&:to_s)

      unless plugs.include?('Sequel::Plugins::Timestamps')
        msg = "Not a plugin(:timestamps) model, available plugins are: #{plugs.inspect}"
        raise(Minitest::Assertion, msg)
      end

      str = 'AssertTimestampedModelInstance -'

      # 2. test for created_at / :updated_at columns
      msg = "#{str} expected model to have column :created_at. Debug: [#{model.inspect}]"
      assert_have_column(model, :created_at, {}, msg)

      msg = "#{str} expected model to have column :updated_at. Debug: [#{model.inspect}]"
      assert_have_column(model, :updated_at, {}, msg)

      if opts[:updated_record]
        # 4. updated record
        msg = "#{str} expected #created_at to be an instance of Time on updated record"
        assert_instance_of(Time, model.created_at, msg)

        msg = "#{str} expected #updated_at to be an instance of Time on updated record"
        assert_instance_of(Time, model.updated_at, msg)
      else
        # 3.  initial record
        msg = "#{str} expected #created_at to be an instance of Time on new record"
        assert_instance_of(Time, model.created_at, msg)

        msg = "#{str} expected #updated_at to be NIL on new record"
        assert_no_error { assert_nil(model.updated_at, msg) }
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # Test if a model class is timestamped with .plugin(:timestamps)
    #
    # This assertion checks if a given model class has been properly configured
    # with the Sequel Timestamps plugin. It verifies the presence of the plugin,
    # the existence of the required columns, and the correct behavior of timestamps
    # for both new and updated records.
    #
    # @param model [Class] The model class to test
    # @param opts [Hash] Options to modify the assertion behavior
    #
    # @example Testing a timestamped model
    #     class Comment < Sequel::Model
    #       plugin(:timestamps)
    #     end
    #
    #     assert_no_error { assert_timestamped_model(Comment) }
    #
    # @example Testing a non-timestamped model
    #     class Post < Sequel::Model; end
    #
    #     msg = /Not a \.plugin\(:timestamps\) model, available plugins are/
    #
    #     assert_error_raised(msg) { assert_timestamped_model(Post) }
    #
    # @example Testing with additional attributes to create a valid model instance
    #     assert_no_error do
    #       assert_timestamped_model(Comment, {body: "I think...", email: "e@email.com"})
    #     end
    #
    # @raise [Minitest::Assertion] If the model class does not meet the timestamped criteria
    #
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def assert_timestamped_model(model, opts = {})
      m = opts.empty? ? model.send(:make) : model.send(:create, opts)

      # 1. test for Timestamps plugin
      plugs = model.instance_variable_get(:@plugins).map(&:to_s)

      unless plugs.include?('Sequel::Plugins::Timestamps')
        msg = "Not a plugin(:timestamps) model, available plugins are: #{plugs.inspect}"
        raise(Minitest::Assertion, msg)
      end

      str = 'AssertTimestampedModel - expected'

      # 2. test for created_at / :updated_at columns
      msg = "#{str} model to have column :created_at. Debug: [#{m.inspect}]"
      assert_have_column(m, :created_at, {}, msg)

      msg = "#{str} model to have column :updated_at. Debug: [#{m.inspect}]"
      assert_have_column(m, :updated_at, {}, msg)

      # 3.  initial record
      msg = "#{str} :created_at to be an instance of Time on new record. Debug: [#{m.inspect}]"
      assert_instance_of(Time, m.created_at, msg)

      msg = "#{str} :updated_at to be an instance of Time on new record. Debug: [#{m.inspect}]"
      assert_instance_of(NilClass, m.updated_at, msg)

      # 4. updated record
      # old_ts = m.created_at
      # sleep 1  # TODO: could this be converted to timecop or similar?
      # m.title = "#{m.title} updated"
      assert(m.save, "AssertTimestampedModel:#save - updated model failed. Debug: [#{m.inspect}]")

      msg = "#{str} :created_at to be an instance of Time on updated record. Debug: [#{m.inspect}]"
      assert_instance_of(Time, m.created_at, msg)

      msg = "#{str} :updated_at to be an instance of Time on updated record. Debug: [#{m.inspect}]"
      assert_instance_of(Time, m.updated_at, msg)

      # assert_equal(old_ts, m.created_at, "#{str} the :created_at timestamp to be unchanged")
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # Test if a model class is paranoid with .plugin(:paranoid) via [Sequel-Paranoid](https://github.com/sdepold/sequel-paranoid)
    #
    # This assertion checks if a given model class has been properly configured
    # with the Sequel Paranoid plugin. It verifies the presence of the plugin,
    # the existence of the required column (:deleted_at), and the correct behavior
    # of soft deletion for both new and updated records.
    #
    # @param model [Class] The model class to test
    # @param opts [Hash] Options to modify the assertion behavior
    #
    # @example Testing a paranoid model
    #     class Comment < Sequel::Model
    #       plugin(:paranoid)
    #     end
    #     assert_no_error { assert_paranoid_model(Comment) }
    #
    # @example Testing a non-paranoid model
    #     class Post < Sequel::Model; end
    #
    #     msg = /Not a plugin\(:paranoid\) model, available plugins are/
    #
    #     assert_error_raised(msg) { assert_paranoid_model(Post) }
    #
    # @example Testing with additional attributes to create a valid model instance
    #     assert_no_error do
    #        assert_paranoid_model(Comment, {body: "I think...", email: "e@email.com"})
    #     end
    #
    # @raise [Minitest::Assertion] If the model class does not meet the paranoid criteria
    #
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def assert_paranoid_model(model, opts = {})
      m = opts.empty? ? model.send(:make) : model.send(:create, opts)

      # 1. test for Paranoid plugin
      plugs = model.instance_variable_get(:@plugins).map(&:to_s)

      unless plugs.include?('Sequel::Plugins::Paranoid')
        raise(
          Minitest::Assertion,
          "Not a plugin(:paranoid) model, available plugins are: #{plugs.inspect}"
        )
      end

      str = 'AssertParanoidModel - expected'

      msg = "#{str} #deleted_at to be NIL on new model"
      assert_nil(m.deleted_at, msg)

      # after update
      assert(m.save, "AssertParanoidModel:save - updated model failed. Debug: [#{m.inspect}]")

      msg = "#{str} #deleted_at to be NIL on updated model"
      assert_nil(m.deleted_at, msg)

      # after destroy
      assert(m.destroy, "AssertParanoidModel:destroy - destroy model failed. Debug: [#{m.inspect}]")

      # assert_instance_of(Time, m.deleted_at,
      #
      msg = "#{str} #deleted_at to be instance of Time on destroyed model, Debug: [#{m.inspect}]"
      assert_instance_of(NilClass, m.deleted_at, msg)
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # Test to ensure the current model is NOT a :timestamped model
    #
    # This assertion checks if a given model class has NOT been configured
    # with the Sequel Timestamps plugin. It verifies the absence of the plugin
    # in the model's list of plugins.
    #
    # @param model [Class] The model class to test
    # @param _opts [Hash] Unused options parameter (kept for consistency with other methods)
    #
    # @example Testing a non-timestamped model
    #     class Post < Sequel::Model; end
    #     it { refute_timestamped_model(Post) }
    #
    # @example Testing a timestamped model (will fail)
    #     class Comment < Sequel::Model
    #       plugin :timestamps
    #     end
    #     it { refute_timestamped_model(Comment) } # This will fail
    #
    # @raise [Minitest::Assertion] If the model class is configured with the Timestamps plugin
    #
    def refute_timestamped_model(model, _opts = {})
      plugs = model.instance_variable_get(:@plugins).map(&:to_s)

      msg = "RefuteTimestampedModel - expected #{model} to NOT be a :timestamps model, but it was."
      msg << " Debug: [#{plugs.inspect}]"

      refute_includes(plugs, 'Sequel::Plugins::Timestamps', msg)
    end

    # Test to ensure the current model is NOT a :paranoid model
    #
    # This assertion checks if a given model class has NOT been configured
    # with the Sequel Paranoid plugin. It verifies the absence of the plugin
    # in the model's list of plugins.
    #
    # @param model [Class] The model class to test
    #
    # @example Testing a non-paranoid model
    #     class Post < Sequel::Model; end
    #     it { refute_paranoid_model(Post) }
    #
    # @example Testing a paranoid model (will fail)
    #     class Comment < Sequel::Model
    #       plugin :paranoid
    #     end
    #     it { refute_paranoid_model(Comment) } # This will fail
    #
    # @raise [Minitest::Assertion] If the model class is configured with the Paranoid plugin
    #
    def refute_paranoid_model(model)
      plugs = model.instance_variable_get(:@plugins).map(&:to_s)

      msg = "RefuteParanoidModel - expected #{model} to NOT be a :paranoid model, but it was. "
      msg << "Debug: [#{plugs.inspect}]"

      refute_includes(plugs, 'Sequel::Plugins::Paranoid', msg)
    end
  end
  # /module Assertions

  # add support for Spec syntax
  module Expectations
    infect_an_assertion :assert_timestamped_model, :must_be_timestamped_model,   :reverse
    infect_an_assertion :assert_timestamped_model, :must_be_a_timestamped_model, :reverse
    infect_an_assertion :assert_paranoid_model,    :must_be_paranoid_model,      :reverse
    infect_an_assertion :assert_paranoid_model,    :must_be_a_paranoid_model,    :reverse

    infect_an_assertion :refute_timestamped_model, :wont_be_timestamped_model,   :reverse
    infect_an_assertion :refute_timestamped_model, :wont_be_a_timestamped_model, :reverse
    infect_an_assertion :refute_paranoid_model,    :wont_be_paranoid_model,      :reverse
    infect_an_assertion :refute_paranoid_model,    :wont_be_a_paranoid_model,    :reverse
  end
end

# reopening the class
# rubocop:disable Style/ClassAndModuleChildren
class Minitest::Spec < Minitest::Test
  # Ensure that a given model is properly configured as a paranoid model
  #
  # This method sets up a series of tests to verify that a model
  # is correctly using the Sequel Paranoid plugin. It checks the behavior
  # of the :deleted_at column in various scenarios.
  #
  # @param model [Class] The model class to test
  #
  # @example Testing a paranoid model
  #     class Comment < Sequel::Model
  #       plugin :paranoid
  #     end
  #
  #     describe Comment do
  #       ensure_paranoid_model(Comment)
  #     end
  #
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.ensure_paranoid_model(model)
    # rubocop:disable Metrics/BlockLength
    describe 'a paranoid model with .plugin(:paranoid)' do
      let(:m) { model.send(:make) }

      describe 'on a new record' do
        it '#:deleted_at should be NULL (empty)' do
          msg = 'EnsureParanoidModel#new - expected #deleted_at to be nil on new record. '
          msg << "Debug: [#{m.inspect}]"

          assert_nil(m.deleted_at, msg)
        end
      end

      describe 'on an updated record' do
        it '#:deleted_at should be NULL (empty)' do
          m.save

          msg = 'EnsureParanoidModel#update - expected #deleted_at to be nil on updated record. '
          msg << "Debug: [#{m.inspect}]"

          assert_nil(m.deleted_at, msg)
        end
      end

      describe 'after a record#destroy' do
        it "#:deleted_at should be NULL (empty) on a delete'd record" do
          m.destroy

          msg = 'EnsureParanoidModel#destroy - expected #deleted_at to be nil on destroyed record. '
          msg << "Debug: [#{m.inspect}]"

          assert_nil(m.deleted_at, msg)
        end
      end

      describe 'after a record#delete' do
        it "#:deleted_at should be NULL (empty) on a delete'd record" do
          m.delete

          msg = 'EnsureParanoidModel#delete - expected #deleted_at to be nil on deleted record. '
          msg << "Debug: [#{m.inspect}]"

          assert_nil(m.deleted_at, msg)
        end
      end

      describe 'after a record#soft_delete' do
        it '#:deleted_at should be a timestamp' do
          refute(m.deleted?)
          assert_no_error { m.soft_delete }
          assert(m.deleted?)

          msg = 'EnsureParanoidModel#destroy - expected #deleted_at to be instance of Time '
          msg << "on deleted model. Debug: [#{m.inspect}]"

          assert_instance_of(Time, m.deleted_at, msg)
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # Ensure that a given model is properly configured as a timestamped model
  #
  # This method sets up a series of tests to verify that a model
  # is correctly using the aequel-timestamps plugin. It checks the behavior
  # of the :created_at and :updated_at columns in various scenarios.
  #
  # @param model [Class] The model class to test
  #
  # @example Testing a timestamped model
  #     class Comment < Sequel::Model
  #       plugin :timestamps
  #     end
  #
  #     describe Comment do
  #       ensure_timestamped_model(Comment)
  #     end
  #
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.ensure_timestamped_model(model)
    # rubocop:disable Metrics/BlockLength
    describe 'a timestamped model with .plugin(:timestamps)' do
      let(:m) { model.send(:make) }

      describe 'a new record' do
        it '#:created_at should be a timestamp' do
          msg = 'EnsureTimestampedModel#new - expected #created_at to be an instance of Time '
          msg << "on new record. Debug: [#{m.inspect}]"

          assert_instance_of(Time, m.created_at, msg)
        end

        it '#:updated_at should be nil (empty)' do
          msg = 'EnsureTimestampedModel#new - expected #updated_at to be nil on new record. '
          msg << "Debug: [#{m.inspect}]"

          assert_nil(m.updated_at, msg)
        end
      end

      describe 'after an update' do
        it '#:created_at should remain unchanged ' do
          assert_instance_of(Time, m.created_at)
          old_ts = m.created_at

          sleep 1 # TODO: convert this with time_cop or similar one day.
          m.save

          msg = 'EnsureTimestampedModel#update - expected #created_at to be unchanged '
          msg << "on update record. Debug: [#{m.inspect}]"

          assert_equal(old_ts, m.created_at, msg)
        end

        it '#:updated_at should be a timestamp' do
          m.save

          msg = 'EnsureTimestampedModel#new - expected #updated_at to be an instance of Time '
          msg << "on updated record. Debug: [#{m.inspect}]"

          assert_instance_of(Time, m.updated_at, msg)
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
# rubocop:enable Style/ClassAndModuleChildren
