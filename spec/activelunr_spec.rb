require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

class Advertise < ActiveRecord::Base
  include ActiveLunr
end

def stub_http(verb)
  RestClient.stub!(verb)
end

def expect_http(verb)
  RestClient.should_receive(verb)
end

def documents_url
  "http://host:1234/context/documents.json"
end

def documents_json
 '[{"highlight":"marilyn","attributes":{"name":"Marilyn","lastname":"Monroe","_type":"Advertise"},"id":"1312"},{"highlight":"adriana","attributes":{"name":"Adriana","lastname":"Lima","_type":"Advertise"},"id":"1212"}]'
end

describe ActiveLunr do
  context "on create" do
    it "should create a document in the Lunr server" do
      expect_http(:post).with(documents_url, :document => {'name' => "Tito", 'lastname' => "Ortiz", '_type' => 'Advertise', 'id' => 1})
      Advertise.create! :name => "Tito", :lastname => "Ortiz"
    end
  end

  context "on update" do
    it "should update a document in the Lunr server" do
      stub_http :post
      advertise = Advertise.create! :name => "Vanderlei"
      expect_http(:put).with("#{documents_url}/#{advertise.id}", :document => {'name' => "Lyoto"})
      advertise.update_attributes! :name => "Lyoto"
    end
  end

  context "on search with an string" do
    it "should search for documents in the Lunr server" do
      expect_http(:get).with(documents_url + "/search?q=_type:Advertise%20AND%20do%20find%20this").and_return(documents_json)
      Advertise.search("do find this")
    end

    it "should return an array of the documents found in the Lunr server" do
      stub_http(:get).and_return(documents_json)
      Advertise.search("a query string").last.lastname.should eql("Lima")
    end
  end
end
