require File.dirname(__FILE__) + '/../test_helper'
require 'local_mailer_controller'

# Re-raise errors caught by the controller.
class LocalMailerController; def rescue_action(e) raise e end; end

class LocalMailerControllerTest < Test::Unit::TestCase
  def setup
    @controller = LocalMailerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
