class Country
  include DataMapper::Resource
  
  property :id, Serial

  property :country, String

  has n, :developers

end
