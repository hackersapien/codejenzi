class Developers < Application
  # provides :xml, :yaml, :js

  def index
    @developers = Developer.all
    display @developers
  end

  def show(id)
    @developer = Developer.get(id)
    raise NotFound unless @developer
    display @developer
  end

  def new
    only_provides :html
    @developer = Developer.new
    display @developer
  end

  def edit(id)
    only_provides :html
    @developer = Developer.get(id)
    raise NotFound unless @developer
    display @developer
  end

  def create(developer)
    @developer = Developer.new(developer)
    if @developer.save
      redirect resource(@developer), :message => {:notice => "Developer was successfully created"}
    else
      message[:error] = "Developer failed to be created"
      render :new
    end
  end

  def update(id, developer)
    @developer = Developer.get(id)
    raise NotFound unless @developer
    if @developer.update_attributes(developer)
       redirect resource(@developer)
    else
      display @developer, :edit
    end
  end

  def destroy(id)
    @developer = Developer.get(id)
    raise NotFound unless @developer
    if @developer.destroy
      redirect resource(:developers)
    else
      raise InternalServerError
    end
  end

end # Developers
