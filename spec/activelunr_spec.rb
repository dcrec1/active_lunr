require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

class Advertise < ActiveRecord::Base
  include ActiveLunr
end

def stub_post
  RestClient.stub!(:post)
end

def expect_post_with(*params)
  RestClient.should_receive(:post).with(*params)
end

def expect_put_with(*params)
  RestClient.should_receive(:put).with(params)
end

describe ActiveLunr do
  context "on create" do
    it "should post a Lunr document with the attributes, the type and the id" do
      expect_post_with("http://host:1234/context/documents", :document => {'name' => "Tito", 'lastname' => "Ortiz", '_type' => 'Advertise', 'id' => 1})
      Advertise.create! :name => "Tito", :lastname => "Ortiz"
    end
  end
  
  context "on update" do
    it "should put a Lunr document with the attributes" do
      stub_post
      advertise = Advertise.create! :name => "Vanderlei"
      expect_put_with("http://host:1234/context/documents/#{advertise.id}", :document => {'city' => "São Paulo"})
      advertise.update_attributes! :city => "Lyoto"
    end
  end
end