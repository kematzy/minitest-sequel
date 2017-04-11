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
  def assert_timestamped_model_instance(model, opts = {}, msg = nil)
    msg = msg.nil? ? "" : "#{msg}\n"
    model_class = model.class
    # m = model.create(opts)
    # 1. test for Timestamps plugin
    plugs = model_class.instance_variable_get("@plugins").map { |p| p.to_s }
    if plugs.include?("Sequel::Plugins::Timestamps")
      # 2. test for created_at / :updated_at columns
      assert_have_column(model, :created_at, {} ,"AssertTimestampedModelInstance - expected model to have column :created_at, Debug: [#{model.inspect}]")
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
  def assert_timestamped_model(model, opts = {}, msg = nil)
    msg = msg.nil? ? "" : "#{msg}\n"
    m = model.create(opts)

    # 1. test for Timestamps plugin
    plugs = model.instance_variable_get("@plugins").map{ |p| p.to_s }
    if plugs.include?("Sequel::Plugins::Timestamps")
      # 2. test for created_at / :updated_at columns
      assert_have_column(m, :created_at, {} ,"AssertTimestampedModel - expected model to have column :created_at. Debug: [#{m.inspect}]")
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

  #
  #
  def assert_paranoid_model(model, opts = {}, msg = nil)
    msg = msg.nil? ? "" : "#{msg}\n"
    m  = model.create(opts)
    m1 = model.create(opts)

    msg << "Expected #{model} to be a .plugin(:paranoid) model:\n"
    m.deleted_at.must_be_nil(msg << "")

    # after update
    m.save
    m.deleted_at.must_be_nil

    # after delete
    m1.delete
    m1.deleted_at.must_be_nil

    # after destroy
    m.destroy
    m.deleted_at.must_be_instance_of(Time)

  end

  #
  #
  def assert_valid_model(model)
    assert model.valid?
    model.errors.must_be_empty
  end

end

# reopening to add plugins functionality
class Minitest::Spec

  #
  #
  def self.it_must_be_a_timestamped_model(model, &blk)

    describe "#{model}.plugin(:timestamps)" do
      before do
        instance_exec(&blk)
      end

      it "#:created_at should be a timestamp on a new record" do
        @m.created_at.must_be_instance_of(Time)
      end

      it "#:created_at should remain unchanged after an update" do
        old_ts = @m.created_at
        @m.created_at.must_be_instance_of(Time)

        sleep 1  # TODO: convert this with timecop or similar one day.
        @m.save
        @m.created_at.must_equal(old_ts)
      end

      it "#:updated_at should be NULL (empty) on a new record" do
        @m.updated_at.must_be_nil
      end

      it "#:created_at should be a timestamp on an updated record" do
        @m.save
        @m.updated_at.must_be_instance_of(Time)
      end

    end

  end
  #
  #
  def self.it_must_be_a_timestamped_model(model, &blk)

    describe "#{model}.plugin(:timestamps)" do
      before do
        instance_exec(&blk)
      end

      it "#:created_at should be a timestamp on a new record" do
        @m.created_at.must_be_instance_of(Time)
      end

      it "#:created_at should remain unchanged after an update" do
        old_ts = @m.created_at
        @m.created_at.must_be_instance_of(Time)

        sleep 1  # TODO: convert this with timecop or similar one day.
        @m.save
        @m.created_at.must_equal(old_ts)
      end

      it "#:updated_at should be NULL (empty) on a new record" do
        @m.updated_at.must_be_nil
      end

      it "#:created_at should be a timestamp on an updated record" do
        @m.save
        @m.updated_at.must_be_instance_of(Time)
      end

    end

  end

  #
  #
  def self.it_must_be_a_paranoid_model(model, &blk)

    describe "#{model}.plugin(:paranoid)" do
      before do
        instance_exec(&blk)
      end

      it "#:deleted_at should be NULL (empty) on a new record" do
        @m.deleted_at.must_be_nil
      end

      it "#:deleted_at should be NULL (empty) on an updated record" do
        @m.save
        @m.deleted_at.must_be_nil
      end

      it "#:deleted_at should be a timestamp on a destroy'ed record" do
        @m.destroy
        @m.deleted_at.must_be_instance_of(Time)
      end

      it "#:deleted_at should be NULL (empty) on a delete'd record" do
        @m.delete
        @m.deleted_at.must_be_nil
      end

    end

  end

  #
  #
  def self.verify_is_a_timestamped_model(model, opts = {})

    describe "a timestamped model with .plugin(:timestamps)" do

      # let (:m1) { _model.send(:make) }
      let (:m) { model.create(opts) }

      it "#:created_at should be a timestamp on a new record" do
        m.created_at.must_be_instance_of(Time)
      end

      it "#:created_at should remain unchanged after an update" do
        old_ts = m.created_at
        m.created_at.must_be_instance_of(Time)

        sleep 1  # TODO: convert this with timecop or similar one day.
        m.save
        m.created_at.must_equal(old_ts)
      end

      it "#:updated_at should be NULL (empty) on a new record" do
        m.updated_at.must_be_nil
      end

      it "#:created_at should be a timestamp on an updated record" do
        m.save
        m.updated_at.must_be_instance_of(Time)
      end

    end

  end

  #
  #
  def self.verify_is_a_valid_CRUD_model(model, attr, opts = {})

    describe "a valid CRUD model" do

      it "can create a #{model}" do
        # m = _model.send(:make)
        m = model.create(opts)
        m.must_be_instance_of(model)
        m.errors.must_be_empty
      end

      it "can read a #{model}" do
        # m = _model.send(:make)
        m   = model.create(opts)
        res = model.send :first
        res.must_be_instance_of(model)
        res.must_equal(m)
      end

      it "can update a #{model}" do
        # m   = _model.send :make
        m    = model.create(opts)
        str = "#{m.send(_attr.to_sym)} Updated"
        res = model.send :first

        res.must_equal(m)
        res.send("#{attr}=", str )
        res.save

        res2 = model.send :first
        res2.send(attr.to_sym).must_equal(str)
      end

      it "can destroy a #{model}" do
        # m = _model.send(:make)
        m = model.create(opts)

        m.deleted_at.must_be_nil
        m.destroy
        m.deleted_at.wont_be_nil
        m.deleted_at.must_be_instance_of(Time)
      end

    end

  end

  #
  #
  def self.verify_is_a_paranoid_model(model, opts = {})

    describe "a paranoid model with .plugin(:paranoid)" do

      let (:m) { model.create(opts) }

      it "#:deleted_at should be NULL (empty) on a new record" do
        m.deleted_at.must_be_nil
      end

      it "#:deleted_at should be NULL (empty) on an updated record" do
        m.save
        m.deleted_at.must_be_nil
      end

      it "#:deleted_at should be a timestamp on a destroy'ed record" do
        m.destroy
        m.deleted_at.must_be_instance_of(Time)
      end

      it "#:deleted_at should be NULL (empty) on a delete'd record" do
        m.delete
        m.deleted_at.must_be_nil
      end

    end

  end
  # end

end
