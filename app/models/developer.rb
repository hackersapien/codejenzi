class Developer
  include DataMapper::Resource
  
  property :id, Serial

  property :cvtext, Text
  property :otherphone, String
  property :middlename, String
  property :lastname, String
  property :firstname, String
  property :mobile, String
  property :cvname, String
  property :picture, String
  property :email, String

end
