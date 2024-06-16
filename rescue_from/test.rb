require "./rescue_from"

class Test
  include RescueFrom

  rescue_from StandardError, with: :handle_exception

  def do_stuff(stuff)
    p "Doing #{stuff}"
    raise StandardError
  end

  def handle_exception(_error)
    p "Oops! There was an exception"
  end
end
