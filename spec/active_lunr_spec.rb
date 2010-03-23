require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

class Advertise
  include ActiveLunr
end

describe ActiveLunr do
  it "should be intialized without params" do
    lambda { Advertise.new }.should_not raise_error
  end

  it "should respond to quoted_table_name" do
    lambda { Advertise.quoted_table_name }.should_not raise_error
  end
  
  context "on create" do
    it "should create a document in the Lunr server" do
      expect_http(:post).with("#{documents_url}.json", :document => {'name' => "Tito", 'lastname' => "Ortiz", '_type' => 'Advertise'}).and_return(document_json)
      Advertise.create! :name => "Tito", :lastname => "Ortiz"
    end
    
    it "should take the generated id" do
      stub_http(:post).and_return(document_json)
      Advertise.create!.id.should eql('1312')
    end
  end

  context "on update" do
    it "should update a document in the Lunr server" do
      stub_http(:post).and_return(document_json)
      advertise = Advertise.create! :name => "Vanderlei"
      expect_http(:put).with("#{documents_url}/#{advertise.id}.json", :document => hash_including({'name' => "Lyoto"}))
      advertise.update_attributes! :name => "Lyoto"
    end
  end

  context "on search with an string" do
    it "should search for documents in the Lunr server" do
      expect_http(:get).with("#{root_url}/search/_type:Advertise%20AND%20do%20find%20this.json").and_return(search_json)
      Advertise.search("do find this")
    end

    it "should return an array of the documents found in the Lunr server" do
      stub_http(:get).and_return(search_json)
      Advertise.search("a query string").last.lastname.should eql("Lima")
    end

    it "should return the highlight" do
      stub_http(:get).and_return(search_json)
      Advertise.search("anything").first.highlight.should eql('marilyn')
    end
  end

  context "on paginate" do
    it "should get documents from Lunr for the param page" do
      expect_http(:get).with("#{root_url}/documents.json?page=5").and_return(documents_json)
      Advertise.paginate(:page => 5)
    end

    it "should return the paginated documents" do
      stub_http(:get).and_return(documents_json)
      Advertise.paginate(:page => 6).last.id.should eql("1313")
    end
  end
  
  context "on save" do
    it "should create a document if the document is new" do
      expect_http(:post).with("#{documents_url}.json", :document => {'language' => "ruby", '_type' => 'Advertise'}).and_return(document_json)
      Advertise.new(:language => "ruby").save
    end
    
    it "should return true" do
      stub_http(:post).and_return(document_json)
      Advertise.new(:language => "ruby").save.should be_true
    end

    it "should update the attributes with the response" do
      stub_http(:post).and_return(document_json)
      advertise = Advertise.new
      advertise.save
      advertise.lastname.should eql("Monroe")  
    end
  end
  
  context "on update attributes" do
    before :each do
      stub_http(:post).and_return(document_json)
      @advertise = Advertise.create! :name => "Vanderlei"
    end
    
    it "should update a document if it already exists" do
      expect_http(:put).with("#{documents_url}/#{@advertise.id}.json", :document => hash_including({'name' => "Rogerio"}))
      @advertise.update_attributes :name => "Rogerio"
    end
    
    it "should return true" do
      stub_http(:put)
      @advertise.update_attributes(:name => "Rogerio").should be_true
    end
  end
end
