module ObjectCreationMethods
  def create_user(attributes = {})
    defaults = {}
    User.create!(attributes.merge(defaults))
  end

  def create_make(attributes = {})
    defaults = {}
    Make.create!(attributes.merge(defaults))
  end

  def create_car(attributes = {})
    defaults = {}
    Car.create!(attributes.merge(defaults))
  end
end