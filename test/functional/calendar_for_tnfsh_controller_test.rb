require File.dirname(__FILE__) + '/../test_helper'
require 'calendar_for_tnfsh_controller'

# Re-raise errors caught by the controller.
class CalendarForTnfshController; def rescue_action(e) raise e end; end

class CalendarForTnfshControllerTest < Test::Unit::TestCase
  def setup
    @controller = CalendarForTnfshController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
