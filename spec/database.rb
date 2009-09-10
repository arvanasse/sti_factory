require 'rubygems'
require 'active_record'
gem 'sqlite3-ruby'

require File.join(File.dirname(__FILE__), '..', 'init.rb')
ActiveRecord::Base.send(:include, Koinonia::StiFactory)

require 'spec'
  
ActiveRecord::Base.logger = Logger.new('/tmp/dj.log')
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => '/tmp/factories.sqlite')
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do

  create_table :vehicles, :force => true do |table|
    table.string :type, :name
  end

  create_table :book, :force => true do |table|
    table.string :name
  end

end

class Vehicle < ActiveRecord::Base
  has_sti_factory
end

class Book < ActiveRecord::Base
end
