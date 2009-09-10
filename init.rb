$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'sti_factory.rb'
ActiveRecord::Base.send(:include, Koinonia::StiFactory)
