require File.expand_path('../../test_helper', __FILE__)

class IssueAssignedHistoryTest < ActiveSupport::TestCase
  fixtures :projects, :users, :enabled_modules, :roles, :members, :member_roles, :issue_statuses

  fixture_dir = File.dirname(__FILE__) + '/../fixtures/unit'
  ActiveRecord::FixtureSet.create_fixtures(fixture_dir, 'issues')
  ActiveRecord::FixtureSet.create_fixtures(fixture_dir, 'journals')
  ActiveRecord::FixtureSet.create_fixtures(fixture_dir, 'journal_details')

  def setup

    issue2 = Issue.find_by_id(2)
    issue3 = Issue.find_by_id(3)
    issue4 = Issue.find_by_id(4)
    issue5 = Issue.find_by_id(5)
    issue6 = Issue.find_by_id(6)

    user1 = User.find(1)
    user2 = User.find(2)
    user3 = User.find(3)

    @history_issue2_created = IssueAssignedHistory.new(
      type: 'new',
      issue: issue2,
      journal_id: nil,
      changed_on: Time.parse("2020-11-01 11:00:00 +00:00"),
      old_assigned_to: nil,
      new_assigned_to: user1)
    @history_issue3_journal2 = IssueAssignedHistory.new(
      type: 'change',
      issue: issue3,
      journal_id: 2,
      changed_on: Time.parse("2020-11-01 13:00:00 +00:00"),
      old_assigned_to: nil,
      new_assigned_to: user1)
    @history_issue4_created = IssueAssignedHistory.new(
      type: 'new',
      issue: issue4,
      journal_id: nil,
      changed_on: Time.parse("2020-11-02 00:00:00 +00:00"),
      old_assigned_to: nil,
      new_assigned_to: user1)
    @history_issue5_created = IssueAssignedHistory.new(
      type: 'new',
      issue: issue5,
      journal_id: nil,
      changed_on: Time.parse("2020-11-02 01:00:00 +00:00"),
      old_assigned_to: nil,
      new_assigned_to: user1)
    @history_issue4_journal3 = IssueAssignedHistory.new(
      type: 'change',
      issue: issue4,
      journal_id: 3,
      changed_on: Time.parse("2020-11-03 11:00:00 +00:00"),
      old_assigned_to: user1,
      new_assigned_to: user2)
    @history_issue5_journal4 = IssueAssignedHistory.new(
      type: 'change',
      issue: issue5,
      journal_id: 4,
      changed_on: Time.parse("2020-11-03 11:00:00 +00:00"),
      old_assigned_to: user1,
      new_assigned_to: nil)
    @history_issue6_journal5 = IssueAssignedHistory.new(
      type: 'change',
      issue: issue6,
      journal_id: 5,
      changed_on: Time.parse("2020-11-03 12:00:00 +00:00"),
      old_assigned_to: nil,
      new_assigned_to: user3)
    @history_issue6_journal6 = IssueAssignedHistory.new(
      type: 'change',
      issue: issue6,
      journal_id: 6,
      changed_on: Time.parse("2020-11-03 20:00:00 +00:00"),
      old_assigned_to: user3,
      new_assigned_to: user1)
    @history_issue6_journal7 = IssueAssignedHistory.new(
      type: 'change',
      issue: issue6,
      journal_id: 7,
      changed_on: Time.parse("2020-11-04 00:00:00 +00:00"),
      old_assigned_to: user1,
      new_assigned_to: nil)
    @history_issue6_journal8 = IssueAssignedHistory.new(
      type: 'change',
      issue: issue6,
      journal_id: 8,
      changed_on: Time.parse("2020-11-05 19:00:00 +00:00"),
      old_assigned_to: nil,
      new_assigned_to: user3)

    # ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  def test_after

    User.current = User.find(1)

    expected = [
      @history_issue6_journal8,
      @history_issue6_journal7,
      @history_issue6_journal6,
      @history_issue6_journal5,
      @history_issue5_journal4,
      @history_issue4_journal3,
      @history_issue5_created,
      @history_issue4_created,
      @history_issue3_journal2,
      @history_issue2_created
    ]

    histories = IssueAssignedHistory.after(Time.parse("2020-11-01 11:00:00 +00:00"))

    assert_equal expected, histories
  end

  def test_after__narrow_down

    User.current = User.find(1)

    expected = [
      @history_issue6_journal8,
      @history_issue6_journal7,
      @history_issue6_journal6,
      @history_issue6_journal5,
      @history_issue5_journal4,
      @history_issue4_journal3
    ]

    histories = IssueAssignedHistory.after(Time.parse("2020-11-03 11:00:00 +00:00"))

    assert_equal expected, histories
  end

  def test_after__visible

    User.current = User.find(3) # project_id:1 しかみえない

    expected = [
      @history_issue4_journal3,
      @history_issue4_created,
      @history_issue3_journal2,
      @history_issue2_created
    ]

    histories = IssueAssignedHistory.after(Time.parse("2020-11-01 11:00:00 +00:00"))

    assert_equal expected, histories
  end

end
