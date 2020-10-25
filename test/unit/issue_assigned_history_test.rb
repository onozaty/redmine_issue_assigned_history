require File.expand_path('../../test_helper', __FILE__)

class IssueAssignedHistoryTest < ActiveSupport::TestCase
  # fixtures :view_customizes, :projects, :users, :issues, :custom_fields, :custom_values

  def setup
  end

  def test_find

    history = IssueAssignedHistory.find
    assert_not_nil history

  end

end
