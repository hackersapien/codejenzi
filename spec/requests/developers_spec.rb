require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a developer exists" do
  Developer.all.destroy!
  request(resource(:developers), :method => "POST", 
    :params => { :developer => { :id => nil }})
end

describe "resource(:developers)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:developers))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of developers" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a developer exists" do
    before(:each) do
      @response = request(resource(:developers))
    end
    
    it "has a list of developers" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Developer.all.destroy!
      @response = request(resource(:developers), :method => "POST", 
        :params => { :developer => { :id => nil }})
    end
    
    it "redirects to resource(:developers)" do
      @response.should redirect_to(resource(Developer.first), :message => {:notice => "developer was successfully created"})
    end
    
  end
end

describe "resource(@developer)" do 
  describe "a successful DELETE", :given => "a developer exists" do
     before(:each) do
       @response = request(resource(Developer.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:developers))
     end

   end
end

describe "resource(:developers, :new)" do
  before(:each) do
    @response = request(resource(:developers, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@developer, :edit)", :given => "a developer exists" do
  before(:each) do
    @response = request(resource(Developer.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@developer)", :given => "a developer exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Developer.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @developer = Developer.first
      @response = request(resource(@developer), :method => "PUT", 
        :params => { :developer => {:id => @developer.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@developer))
    end
  end
  
end

