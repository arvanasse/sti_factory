require File.join(File.dirname(__FILE__), 'database')

class Car < Vehicle
end

class Truck < Vehicle
end

class MonsterTruck < Vehicle
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

end
