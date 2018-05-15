require 'test_helper'

class ScoresControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get scores_new_url
    assert_response :success
  end

  test "should get edit" do
    get scores_edit_url
    assert_response :success
  end

end
