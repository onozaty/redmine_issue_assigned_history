require File.expand_path('../../test_helper', __FILE__)

class IssueAssignedHistoryTest < ActiveSupport::TestCase
  fixtures :projects, :users, :issues, :journals, :journal_details

  def setup
  end

  def test_find

    history = IssueAssignedHistory.find
    assert_not_nil history

  end

end
