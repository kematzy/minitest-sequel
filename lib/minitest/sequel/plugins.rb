require "minitest/sequel"

# reopening to add validations functionality
module Minitest::Assertions

  # Test if a model instance is timestamped via .plugin(:timestamps)
  # 
  #     let(:m) { Post.create(title: "Dummy") }
  #     proc { assert_timestamped_model_instance(m) }.wont_have_error
  # 
  # You can also test if an updated record is correctly timestamped
  # 
  #     m.title = "Updated"
  #     m.save
  #     proc { assert_timestamped_model_instance(m, updated_record: true) }.wont_have_error
  # 
  # Or alternatively test if an updated record is wrongly timestamped
  # 
  #     let(:m) { Post.create(title: "Dummy", updated_at: Time.now) }
  #     proc { assert_timestamped_model_instance(m, updated_record: false) }.must_have_error(/expected #.updated_at to be NIL on new record/)
  # 
  # 
  def assert_timestamped_model_instance(model, opts = {})
    model_class = model.class
    # 1. test for Timestamps plugin
    plugs = model_class.instance_variable_get("@plugins").map(&:to_s)
    if plugs.include?("Sequel::Plugins::Timestamps")
      # 2. test for created_at / :updated_at columns
      assert_have_column(model, :created_at, {}, "AssertTimestampedModelInstance - expected model to have column :created_at, Debug: [#{model.inspect}]")
      assert_have_column(model, :updated_at, {}, "AssertTimestampedModelInstance - expected model to have column :updated_at, Debug: [#{model.inspect}]")

      if opts[:updated_record]
        # 4. updated record
        assert_instance_of(Time, model.created_at, "AssertTimestampedModelInstance:created_at - expected #created_at to be an instance of Time on updated record")
        assert_instance_of(Time, model.updated_at, "AssertTimestampedModelInstance:updated_at - expected #updated_at to be an instance of Time on updated record")
      else
        # 3.  initial record
        assert_instance_of(Time, model.created_at, "AssertTimestampedModelInstance:created_at - expected #created_at to be an instance of Time on new record")
        proc {
          assert_nil(model.updated_at, "AssertTimestampedModelInstance:updated - expected #updated_at to be NIL on new record")
        }.wont_have_error
      end
    else
      raise(Minitest::Assertion, "Not a plugin(:timestamps) model, available plugins are: #{plugs.inspect}")
    end
  end

  # Test if a model class is timestamped with .plugin(:timestamps)
  # 
  #     # Declared locally in the Model
  #     class Comment < Sequel::Model
  #       plugin(:timestamps)
  #     end
  #     proc { assert_timestamped_model(Comment) }.wont_have_error
  # 
  #     # on a non-timestamped model
  #     class Post < Sequel::Model; end
  #     proc { assert_timestamped_model(Post) }.must_have_error(/Not a \.plugin\(:timestamps\) model, available plugins are/)
  # 
  # 
  #  NOTE!
  # 
  #  You can also pass attributes to the created model in the tests via the `opts` hash like this:
  # 
  #     proc { assert_timestamped_model(Comment, {body: "I think...", email: "e@email.com"}) }.wont_have_error
  # 
  # 
  def assert_timestamped_model(model, opts = {})
    m = model.create(opts)
    # 1. test for Timestamps plugin
    plugs = model.instance_variable_get("@plugins").map(&:to_s)
    if plugs.include?("Sequel::Plugins::Timestamps")
      # 2. test for created_at / :updated_at columns
      assert_have_column(m, :created_at, {}, "AssertTimestampedModel - expected model to have column :created_at. Debug: [#{m.inspect}]")
      assert_have_column(m, :updated_at, {}, "AssertTimestampedModel - expected model to have column :updated_at. Debug: [#{m.inspect}]")

      # 3.  initial record
      assert_instance_of(Time, m.created_at, "AssertTimestampedModel:created_at - expected #created_at to be an instance of Time on new record. Debug: [#{m.inspect}]")
      assert_instance_of(NilClass, m.updated_at, "AssertTimestampedModel:updated_at - expected #updated_at to be an instance of NilClass on new record. Debug: [#{m.inspect}]")

      # 4. updated record
      # old_ts = m.created_at
      # sleep 1  # TODO: could this be converted to timecop or similar?
      m.title = "#{m.title} updated"
      assert(m.save, "AssertTimestampedModel:#save - updated model failed. Debug: [#{m.inspect}]")
      assert_instance_of(Time, m.created_at, "AssertTimestampedModel:created_at - expected #created_at to be an instance of Time on updated record. Debug: [#{m.inspect}]")
      assert_instance_of(Time, m.updated_at, "AssertTimestampedModel:updated_at - expected #updated_at to be an instance of Time on updated record. Debug: [#{m.inspect}]")
      # assert_equal(old_ts, m.created_at, "AssertTimestampedModel - expected the :created_at timestamp to be unchanged")
    else
      raise(Minitest::Assertion, "Not a plugin(:timestamps) model, available plugins are: #{plugs.inspect}")
    end
  end

  # Test if a model class is paranoid with .plugin(:paranoid) via [Sequel-Paranoid](https://github.com/sdepold/sequel-paranoid)
  # 
  #     # Declared locally in the Model
  #     class Comment < Sequel::Model
  #       plugin(:paranoid)
  #     end
  #     proc { assert_paranoid_model(Comment) }.wont_have_error
  # 
  #     # on a non-paranoid model
  #     class Post < Sequel::Model; end
  #     proc { assert_paranoid_model(Post) }.must_have_error(/Not a plugin\(:paranoid\) model, available plugins are/)
  # 
  # 
  #  NOTE!
  # 
  #  You can also pass attributes to the created model in the tests via the `opts` hash like this:
  # 
  #     proc { assert_timestamped_model(Comment, {body: "I think...", email: "e@email.com"}) }.wont_have_error
  # 
  # 
  def assert_paranoid_model(model, opts = {})
    m = model.create(opts)
    # 1. test for Paranoid plugin
    plugs = model.instance_variable_get("@plugins").map(&:to_s)
    if plugs.include?("Sequel::Plugins::Paranoid")
      assert_nil(m.deleted_at, "AssertParanoidModel:deleted_at - expected #deleted_at to be NIL on new model")
      # after update
      assert(m.save, "AssertParanoidModel:save - updated model failed. Debug: [#{m.inspect}]")
      assert_nil(m.deleted_at, "AssertParanoidModel:deleted_at - expected #deleted_at to be NIL on updated model")
      # after destroy
      assert(m.destroy, "AssertParanoidModel:destroy - destroy model failed. Debug: [#{m.inspect}]")
      assert_instance_of(Time, m.deleted_at, "AssertParanoidModel:deleted_at - expected #deleted_at to be instance of Time on destroyed model, Debug: [#{m.inspect}]")
    else
      raise(Minitest::Assertion, "Not a plugin(:paranoid) model, available plugins are: #{plugs.inspect}")
    end
  end
  
  
  
  # Test to ensure the current model is NOT a :timestamped model
  #
  #     it { refute_timestamped_model(Post) }
  #
  def refute_timestamped_model(model, opts = {})
    plugs = model.instance_variable_get("@plugins").map(&:to_s)
    refute_includes(plugs, "Sequel::Plugins::Timestamps", "RefuteTimestampedModel - expected #{model} to NOT be a :timestamped model, but it was, Debug: [#{plugs.inspect}]")
  end
  
  # Test to ensure the current model is NOT a :paranoid model
  #
  #     it { refute_paranoid_model(Post) }
  #
  def refute_paranoid_model(model)
    plugs = model.instance_variable_get("@plugins").map(&:to_s)
    refute_includes(plugs, "Sequel::Plugins::Paranoid", "RefuteParanoidModel - expected #{model} to NOT be a :paranoid model, but it was, Debug: [#{plugs.inspect}]")
  end
  
    
end


# add support for Spec syntax
module Minitest::Expectations

  infect_an_assertion :assert_timestamped_model,        :must_be_timestamped_model,         :reverse
  infect_an_assertion :assert_paranoid_model,           :must_be_paranoid_model,            :reverse
  infect_an_assertion :assert_paranoid_model,           :must_be_a_paranoid_model,          :reverse

  infect_an_assertion :refute_timestamped_model,        :wont_be_timestamped_model,         :reverse
  infect_an_assertion :refute_timestamped_model,        :wont_be_a_timestamped_model,       :reverse
  infect_an_assertion :refute_paranoid_model,           :wont_be_paranoid_model,            :reverse
  infect_an_assertion :refute_paranoid_model,           :wont_be_a_paranoid_model,          :reverse
end
