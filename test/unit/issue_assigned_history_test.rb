require File.expand_path('../../test_helper', __FILE__)

class IssueAssignedHistoryTest < ActiveSupport::TestCase
  fixtures :projects, :users, :issues, :journals, :journal_details

  def setup
  end

  def test_after

    histories = IssueAssignedHistory.after(Time.parse("2020-11-01 11:00:00 +09:00"))

    p histories
    assert_equal 10, histories.size

  end

end
