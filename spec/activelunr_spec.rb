require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

class Advertise < ActiveRecord::Base
  include ActiveLunr
end

describe ActiveLunr do
  context "on creation" do
    it "should post a Lunr document with the attributes, the type and the id" do
      RestClient.should_receive(:post).with("http://host:1234/context", :document => {'name' => "Tito", 'lastname' => "Ortiz", '_type' => 'Advertise', 'id' => 1})
      Advertise.create! :name => "Tito", :lastname => "Ortiz"
    end
  end
end