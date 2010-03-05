require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

class Advertise
  include ActiveLunr
end

describe ActiveLunr do
  context "on create" do
    it "should create a document in the Lunr server" do
      expect_http(:post).with("#{documents_url}.json", :document => {'name' => "Tito", 'lastname' => "Ortiz", '_type' => 'Advertise'}).and_return(document_json)
      Advertise.create! :name => "Tito", :lastname => "Ortiz"
    end
  end

  context "on update" do
    it "should update a document in the Lunr server" do
      stub_http(:post).and_return(document_json)
      advertise = Advertise.create! :name => "Vanderlei"
      expect_http(:put).with("#{documents_url}/#{advertise.id}.json", :document => {'name' => "Lyoto"})
      advertise.update_attributes! :name => "Lyoto"
    end
  end

  context "on search with an string" do
    it "should search for documents in the Lunr server" do
      expect_http(:get).with("#{root_url}/search/_type:Advertise%20AND%20do%20find%20this.json").and_return(documents_json)
      Advertise.search("do find this")
    end

    it "should return an array of the documents found in the Lunr server" do
      stub_http(:get).and_return(documents_json)
      Advertise.search("a query string").last.lastname.should eql("Lima")
    end

    it "should return the highlight" do
      stub_http(:get).and_return(documents_json)
      Advertise.search("anything").first.highlight.should eql('marilyn')
    end
  end

  it "should be intialized without params" do
    lambda { Advertise.new }.should_not raise_error
  end
end
