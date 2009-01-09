class Countries < Application
  # provides :xml, :yaml, :js

  def index
    @countries = Country.all
    display @countries
  end

  def show(id)
    @country = Country.get(id)
    raise NotFound unless @country
    display @country
  end

  def new
    only_provides :html
    @country = Country.new
    display @country
  end

  def edit(id)
    only_provides :html
    @country = Country.get(id)
    raise NotFound unless @country
    display @country
  end

  def create(country)
    @country = Country.new(country)
    if @country.save
      redirect resource(@country), :message => {:notice => "Country was successfully created"}
    else
      message[:error] = "Country failed to be created"
      render :new
    end
  end

  def update(id, country)
    @country = Country.get(id)
    raise NotFound unless @country
    if @country.update_attributes(country)
       redirect resource(@country)
    else
      display @country, :edit
    end
  end

  def destroy(id)
    @country = Country.get(id)
    raise NotFound unless @country
    if @country.destroy
      redirect resource(:countries)
    else
      raise InternalServerError
    end
  end

end # Countries
