require_relative "../spec_helper"

describe Minitest::Spec do
  
  describe "# assert_timestamped_model()" do
    
    describe "a .plugin(:timestamps) model" do

      it "should raise no error on a valid model" do
        c = Class.new(::Post)
        c.plugin(:timestamps)
        proc { assert_timestamped_model(c, {title: "Dummy"}) }.wont_have_error
      end

      it "should raise no error when the :created_at and :updated_at columns are present" do
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

      it "should raise an error when the :updated_at column is missing" do
        c = Class.new(::UpdatedPost)
        c.plugin(:timestamps)
        e = %r{Expected .* model to have column: :updated_at but no such column exists}
        proc { assert_timestamped_model(c, {title: "Dummy"}) }.must_have_error(e)
      end
      
    end

    describe "a NON .plugin(:timestamps) model" do

      it "should raise an error" do
        c = Class.new(::Post)
        e = "Not a plugin(:timestamps) model, available plugins are: [\"Sequel::Model\", \"Sequel::Model::Associations\", \"Sequel::Plugins::ValidationClassMethods\"]"
        proc { assert_timestamped_model(c, {title: "Dummy"}) }.must_have_error(e)
      end

    end
    
  end
  
  describe "# assert_timestamped_model_instance()" do
    
    it "should not raise an error on a new model and set the :created_at: to a timestamp" do
      c = Class.new(::Post)
      c.plugin(:timestamps)
      mi = c.create(title: "Dummy", created_at: nil)
      proc { assert_timestamped_model_instance(mi) }.wont_have_error
    end
    
    it "should not raise an error on an updated model and set the :updated_at to a timestamp" do
      c = Class.new(::Post)
      c.plugin(:timestamps)
      mi = c.create(title: "Dummy")
      mi.update(title: "updated")
      mi.save
      mi.updated_at.wont_be_nil
      proc { assert_timestamped_model_instance(mi, updated_record: true) }.wont_have_error
    end
    
    it "should set :updated_at to NIL on a new model" do
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
    
  end
  
  describe "model.must_be_timestamped_model()" do
    
    it "should NOT raise an error on a :timestamped model" do
      c = Class.new(::Post)
      c.plugin(:timestamps)
      proc { c.must_be_timestamped_model({title: "Timestamped"}) }.wont_have_error
    end
    
    it "should raise an error on a NON :timestamped model" do
      c = Class.new(::Post)
      proc { c.must_be_timestamped_model({title: "Timestamped"}) }.must_have_error(/Not a plugin\(:timestamps\) model, available plugins are/)
    end

  end

  describe "# assert_paranoid_model()" do
  
    describe "a .plugin(:paranoid) model" do

      it "should raise no error on a valid model" do
        c = Class.new(::Author)
        c.plugin(:paranoid)
        proc { assert_paranoid_model(c, {name: "John Lescroart"}) }.wont_have_error
      end
    
      it "should raise no error when the :deleted_at column is present" do
        c = Class.new(::Author)
        c.plugin(:paranoid)
        proc { assert_paranoid_model(c, {name: "Patricia Cornwell"}) }.wont_have_error
      end
      
      it "should raise a NoMethodError when the :deleted_at column is missing" do
        c = Class.new(::ParanoidPost)
        c.plugin(:paranoid)
        proc { 
          assert_paranoid_model(c, {title: "Dummy"}) 
        }.must_raise(NoMethodError)
      end
      
    end

    describe "a NON .plugin(:paranoid) model" do

      it "should raise an error" do
        c = Class.new(::Post)
        e = "Not a plugin(:paranoid) model, available plugins are: [\"Sequel::Model\", \"Sequel::Model::Associations\", \"Sequel::Plugins::ValidationClassMethods\"]"
        proc { assert_paranoid_model(c, {title: "Dummy"}) }.must_have_error(e)
      end

    end
        
  end

  describe "model.must_be_a_paranoid_model()" do
    
    it "should NOT raise an error on a :paranoid model" do
      c = Class.new(::Author)
      c.plugin(:paranoid)
      proc { c.must_be_a_paranoid_model({name: "Stephen King"}) }.wont_have_error
    end
    
    it "should raise an error on a NON :paranoid model" do
      c = Class.new(::Post)
      proc { c.must_be_a_paranoid_model({title: "Paranoid"}) }.must_have_error(/Not a plugin\(:paranoid\) model, available plugins are/)
    end

  end

  describe "# refute_timestamped_model()" do
  
    it "should raise error on a .plugin(:timestamps) model" do
      c = Class.new(::Post)
      c.plugin(:timestamps)
      e = /expected .* to NOT be a :timestamped model, but it was/
      proc { refute_timestamped_model(c) }.must_have_error(e)
    end

    it "should raise NO error on a NON .plugin(:timestamps) model" do
      c = Class.new(::Dummy)
      proc { refute_timestamped_model(c) }.wont_have_error
    end
        
  end
  
  describe "# refute_paranoid_model()" do
  
    it "should raise error on a .plugin(:paranoid) model" do
      c = Class.new(::Author)
      c.plugin(:paranoid)
      e = /expected .* to NOT be a :paranoid model, but it was/
      proc { refute_paranoid_model(c) }.must_have_error(e)
    end

    it "should raise NO error on a NON .plugin(:paranoid) model" do
      c = Class.new(::Post)
      proc { refute_paranoid_model(c) }.wont_have_error
    end
        
  end
  
  describe "model.wont_be_timestamped_model()" do
    
    it "should NOT raise an error on a NON :timestamped model" do
      c = Class.new(::Post)
      proc { c.wont_be_timestamped_model({title: "Timestamped"}) }.wont_have_error
    end
    
    it "should raise an error on a :timestamped model" do
      c = Class.new(::Post)
      c.plugin(:timestamps)
      proc { c.wont_be_timestamped_model({title: "Timestamped"}) }.must_have_error(/to NOT be a :timestamped model, but it was/)
      proc { c.wont_be_a_timestamped_model({title: "Timestamped"}) }.must_have_error(/to NOT be a :timestamped model, but it was/)
    end
    
  end
  
  describe "model.wont_be_paranoid_model()" do
    
    it "should NOT raise an error on a NON :paranoid model" do
      c = Class.new(::Author)
      proc { c.wont_be_paranoid_model({name: "Paranoid"}) }.wont_have_error
    end
    
    it "should raise an error on a :paranoid model" do
      c = Class.new(::Author)
      c.plugin(:paranoid)
      proc { c.wont_be_a_paranoid_model({name: "Paranoid"}) }.must_have_error(/to NOT be a :paranoid model, but it was/)
    end
    
  end
  
  
end