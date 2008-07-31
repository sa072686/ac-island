require File.dirname(__FILE__) + '/../test_helper'
require 'menu_controller'

# Re-raise errors caught by the controller.
class MenuController; def rescue_action(e) raise e end; end

class MenuControllerTest < Test::Unit::TestCase
  def setup
    @controller = MenuController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
