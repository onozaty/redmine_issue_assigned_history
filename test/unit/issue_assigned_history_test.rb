require File.expand_path('../../test_helper', __FILE__)

class IssueAssignedHistoryTest < ActiveSupport::TestCase
  fixtures :projects, :users, :issues, :journals, :journal_details

  def setup
    @history_issue2_created = IssueAssignedHistory.new(
      issue_id: 2,
      issue_subject: "assigned(1)",
      journal_id: nil,
      changed_on: Time.parse("2020-11-01 11:00:00 +00:00"),
      old_login_id: nil,
      new_login_id: "admin")
    @history_issue3_journal2 = IssueAssignedHistory.new(
      issue_id: 3,
      issue_subject: "not_assign -> assigned(1)",
      journal_id: 2,
      changed_on: Time.parse("2020-11-01 13:00:00 +00:00"),
      old_login_id: nil,
      new_login_id: "admin")
    @history_issue4_created = IssueAssignedHistory.new(
      issue_id: 4,
      issue_subject: "assigned(1) -> assigned(2)",
      journal_id: nil,
      changed_on: Time.parse("2020-11-02 00:00:00 +00:00"),
      old_login_id: nil,
      new_login_id: "admin")
    @history_issue5_created = IssueAssignedHistory.new(
      issue_id: 5,
      issue_subject: "assigned(1) -> not_assign",
      journal_id: nil,
      changed_on: Time.parse("2020-11-02 01:00:00 +00:00"),
      old_login_id: nil,
      new_login_id: "admin")
    @history_issue4_journal3 = IssueAssignedHistory.new(
      issue_id: 4,
      issue_subject: "assigned(1) -> assigned(2)",
      journal_id: 3,
      changed_on: Time.parse("2020-11-03 11:00:00 +00:00"),
      old_login_id: "admin",
      new_login_id: "jsmith")
    @history_issue5_journal4 = IssueAssignedHistory.new(
      issue_id: 5,
      issue_subject: "assigned(1) -> not_assign",
      journal_id: 4,
      changed_on: Time.parse("2020-11-03 11:00:00 +00:00"),
      old_login_id: "admin",
      new_login_id: nil)
    @history_issue6_journal5 = IssueAssignedHistory.new(
      issue_id: 6,
      issue_subject: "not_assign -> assigned(3) -> assigned(1) -> not_assgin -> assigned(3)",
      journal_id: 5,
      changed_on: Time.parse("2020-11-03 12:00:00 +00:00"),
      old_login_id: nil,
      new_login_id: "dlopper")
    @history_issue6_journal6 = IssueAssignedHistory.new(
      issue_id: 6,
      issue_subject: "not_assign -> assigned(3) -> assigned(1) -> not_assgin -> assigned(3)",
      journal_id: 6,
      changed_on: Time.parse("2020-11-03 20:00:00 +00:00"),
      old_login_id: "dlopper",
      new_login_id: "admin")
    @history_issue6_journal7 = IssueAssignedHistory.new(
      issue_id: 6,
      issue_subject: "not_assign -> assigned(3) -> assigned(1) -> not_assgin -> assigned(3)",
      journal_id: 7,
      changed_on: Time.parse("2020-11-04 00:00:00 +00:00"),
      old_login_id: "admin",
      new_login_id: nil)
    @history_issue6_journal8 = IssueAssignedHistory.new(
      issue_id: 6,
      issue_subject: "not_assign -> assigned(3) -> assigned(1) -> not_assgin -> assigned(3)",
      journal_id: 8,
      changed_on: Time.parse("2020-11-05 19:00:00 +00:00"),
      old_login_id: nil,
      new_login_id: "dlopper")
  end

  def test_after

    expected = [
      @history_issue2_created,
      @history_issue3_journal2,
      @history_issue4_created,
      @history_issue5_created,
      @history_issue4_journal3,
      @history_issue5_journal4,
      @history_issue6_journal5,
      @history_issue6_journal6,
      @history_issue6_journal7,
      @history_issue6_journal8]

    histories = IssueAssignedHistory.after(Time.parse("2020-11-01 11:00:00 +00:00"))

    assert_equal expected, histories
  end

  def test_after_narrow_down

    expected = [
      @history_issue4_journal3,
      @history_issue5_journal4,
      @history_issue6_journal5,
      @history_issue6_journal6,
      @history_issue6_journal7,
      @history_issue6_journal8]

    histories = IssueAssignedHistory.after(Time.parse("2020-11-03 11:00:00 +00:00"))

    assert_equal expected, histories
  end

end
