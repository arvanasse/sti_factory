require File.join(File.dirname(__FILE__), 'database')

class Car < Vehicle
end

class Truck < Vehicle
end

class MonsterTruck < Vehicle
end

describe "an STI class with a factory method", :shared=>true do
  context "when instantiating a new object" do
    it "should return the subclass named in the type attribute if it is a valid subclass" do
      %w{Car Truck MonsterTruck}.each do |class_name|
        target_class = class_name.constantize
        Vehicle.new( inheritance_column => class_name).should be_a_kind_of( target_class )
      end
    end

    it "should return the specified class if no type attribute is supplied" do
      %w{Vehicle Car Truck MonsterTruck}.each do |class_name|
        target_class = class_name.constantize
        target_class.new.should be_a_kind_of( target_class )
      end
    end

    it "should return the specified class if the supplied type attribute is a valid subclass of the base class" do
      %w{Vehicle Car Truck MonsterTruck}.each do |class_name|
        target_class = class_name.constantize
        target_class.new( inheritance_column => 'Book' ).should be_a_kind_of( target_class )
      end
    end
  end

  context "when instantiating an new instance using a string key for the inheritance column" do
    it "should return the subclass named in the type attribute if it is a valid subclass" do
      %w{Car Truck MonsterTruck}.each do |class_name|
        target_class = class_name.constantize
        Vehicle.new( inheritance_column.to_s => class_name).should be_a_kind_of( target_class )
      end
    end

    it "should return the specified class if the supplied type attribute is a valid subclass of the base class" do
      %w{Vehicle Car Truck MonsterTruck}.each do |class_name|
        target_class = class_name.constantize
        target_class.new( inheritance_column.to_s => 'Book' ).should be_a_kind_of( target_class )
      end
    end
  end

  describe "when creating a new object" do
    it "should persist an instance of the subclass named in the type attribute" do
      %w{Car Truck MonsterTruck}.each do |class_name|
        target_class = class_name.constantize
        lambda{Vehicle.create( inheritance_column => class_name)}.
          should change( target_class, :count ).by(1)
      end
    end

    it "should persist an instance of the specified class if no type attribute is supplied" do
      %w{Vehicle Car Truck MonsterTruck}.each do |class_name|
        target_class = class_name.constantize
        lambda{target_class.create}.should change( target_class, :count ).by(1)
      end
    end

    it "should persist the specified class if the value supplied in the type attribute is not a valid subclass of the base class" do
      %w{Vehicle Car Truck MonsterTruck}.each do |class_name|
        target_class = class_name.constantize
        lambda{target_class.create( inheritance_column => 'Book' )}.
          should change( target_class, :count ).by(1)
      end
    end
  end

  def inheritance_column
    Vehicle.inheritance_column.to_sym
  end
end

describe Koinonia::StiFactory do

  it "should provide an array of subclass names" do
    %w{Car Truck MonsterTruck}.each do |class_name|
      Vehicle.subclass_names.should include( class_name )
    end
  end

  it "should include the base class name in the list of subclass names" do
    Vehicle.subclass_names.should include( "Vehicle" )
  end

  describe 'with the default inheritance column' do
    it_should_behave_like "an STI class with a factory method"
  end

  describe 'with a non-standard inheritance column' do
    ActiveRecord::Schema.define do
      rename_column :vehicles, :type, :vehicle_type
    end

    Vehicle.class_eval "self.inheritance_column = 'vehicle_type'"

    it_should_behave_like "an STI class with a factory method"
  end

  context 'instantiated through an association' do
    before :all do
      Vehicle.class_eval "self.inheritance_column = 'type'"
      @manufacturer = Manufacturer.create :name => 'Ford'
    end

    context 'using assoc.build' do
      before :each do
        @vehicle = @manufacturer.vehicles.build(:type => 'Car', :name => 'Test')
      end

      it "should instantiate the correct class calling assoc.build" do
        @vehicle.should be_a_kind_of(Car)
      end

      it "should populate the assoc_id" do
        @vehicle.manufacturer_id.should eql(@manufacturer.id)
      end
    end

    context 'using assoc.create' do
      before :each do
        @vehicle = @manufacturer.vehicles.create(:type => 'Car', :name => 'Test')
      end

      it "should instantiate the correct class calling assoc.build" do
        @vehicle.should be_a_kind_of(Car)
      end

      it "should populate the assoc_id" do
        @vehicle.manufacturer_id.should eql(@manufacturer.id)
      end
    end
  end
end
