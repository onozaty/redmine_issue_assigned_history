class IssueAssignedHistory

  attr_reader :type, :issue, :journal_id, :changed_on, :old_assigned_to, :new_assigned_to

  def initialize(type:, issue:, journal_id:, changed_on:, old_assigned_to:, new_assigned_to:)
    @type = type
    @issue = issue
    @journal_id = journal_id
    @changed_on = changed_on
    @old_assigned_to = old_assigned_to
    @new_assigned_to = new_assigned_to
  end

  def self.after(changed_on)

    user_cache = {}

    created_issues = Issue.visible.
                eager_load(:status).
                where("#{Issue.table_name}.created_on >= ?", changed_on)

    journals = Journal.
                eager_load(:details).
                eager_load(:issue => :project).
                eager_load(:issue => :status).
                where(Issue.visible_condition(User.current)).
                where("#{Journal.table_name}.journalized_type = 'Issue'").
                where("#{Journal.table_name}.created_on >= ?", changed_on).
                where("#{JournalDetail.table_name}.property = 'attr'").
                where("#{JournalDetail.table_name}.prop_key = 'assigned_to_id'").
                order("#{Journal.table_name}.created_on ASC")

    histories = journals.map do |journal|
      IssueAssignedHistory.new(
        type: 'change',
        issue: journal.issue,
        journal_id: journal.id,
        changed_on: journal.created_on,
        old_assigned_to: to_user(journal.details[0].old_value, user_cache),
        new_assigned_to: to_user(journal.details[0].value, user_cache))
    end

    # Issue作成時の情報も追加
    created_issues.each do |issue|
      history = histories.find{|history| history.issue.id == issue.id }

      if history.nil? && issue.assigned_to_id.present?
        # Journalでの履歴になくて、Issueでアサインされている場合
        histories.push(
          IssueAssignedHistory.new(
            type: 'new',
            issue: issue,
            journal_id: nil,
            changed_on: issue.created_on,
            old_assigned_to: nil,
            new_assigned_to: to_user(issue.assigned_to_id, user_cache)))
            
      elsif history.present? && history.old_assigned_to.present?
        # Journalでの履歴にあって、変更前の値が設定されていた場合
        histories.push(
          IssueAssignedHistory.new(
            type: 'new',
            issue: issue,
            journal_id: nil,
            changed_on: issue.created_on,
            old_assigned_to: nil,
            new_assigned_to: history.old_assigned_to))
      end
    end
    
    histories.sort_by{|history| [history.changed_on, history.journal_id]}.reverse
  end

  def ==(other)
    type == other.type && issue == other.issue && journal_id == other.journal_id && changed_on == other.changed_on &&
      old_assigned_to == other.old_assigned_to && new_assigned_to == other.new_assigned_to
  end

  private

  def self.to_user(user_id, user_cache)

    if user_id.blank?
      return nil
    end

    user = user_cache[user_id]

    if user.nil?
      user = User.find_by_id(user_id.to_i)
      user_cache[user_id] = user
    end
    
    user
  end
end
