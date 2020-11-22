class IssueAssignedHistory

  attr_reader :issue_id, :issue_subject, :project_id, :journal_id, :changed_on, :old_login_id, :new_login_id

  def initialize(issue_id:, issue_subject:, project_id:, journal_id:, changed_on:, old_login_id:, new_login_id:)
    @issue_id = issue_id
    @issue_subject = issue_subject
    @project_id = project_id
    @journal_id = journal_id
    @changed_on = changed_on
    @old_login_id = old_login_id
    @new_login_id = new_login_id
  end

  def self.after(changed_on)

    login_id_cache = {}

    created_issues = Issue.visible.where("#{Issue.table_name}.created_on >= ?", changed_on)

    journals = Journal.
                select("#{Journal.table_name}.*, #{JournalDetail.table_name}.old_value, #{JournalDetail.table_name}.value, #{Issue.table_name}.subject as issue_subject, #{Issue.table_name}.project_id").
                joins(:issue => :project).
                joins(:details).
                where(Issue.visible_condition(User.current)).
                where("#{Journal.table_name}.journalized_type = 'Issue'").
                where("#{Journal.table_name}.created_on >= ?", changed_on).
                where("#{JournalDetail.table_name}.property = 'attr'").
                where("#{JournalDetail.table_name}.prop_key = 'assigned_to_id'").
                order("#{Journal.table_name}.created_on ASC")

    histories = journals.map do |journal|
      IssueAssignedHistory.new(
        issue_id: journal.journalized_id,
        issue_subject: journal.issue_subject,
        project_id: journal.project_id,
        journal_id: journal.id,
        changed_on: journal.created_on,
        old_login_id: to_login_id(journal.old_value, login_id_cache),
        new_login_id: to_login_id(journal.value, login_id_cache))
    end

    # Issue作成時の情報も追加
    created_issues.each do |issue|
      history = histories.find{|history| history.issue_id == issue.id }

      if history.nil? && issue.assigned_to_id.present?
        # Journalでの履歴になくて、Issueでアサインされている場合
        histories.push(
          IssueAssignedHistory.new(
            issue_id: issue.id,
            issue_subject: issue.subject,
            project_id: issue.project_id,
            journal_id: nil,
            changed_on: issue.created_on,
            old_login_id: nil,
            new_login_id: to_login_id(issue.assigned_to_id, login_id_cache)))
            
      elsif history.present? && history.old_login_id.present?
        # Journalでの履歴にあって、変更前の値が設定されていた場合
        histories.push(
          IssueAssignedHistory.new(
            issue_id: issue.id,
            issue_subject: issue.subject,
            project_id: issue.project_id,
            journal_id: nil,
            changed_on: issue.created_on,
            old_login_id: nil,
            new_login_id: history.old_login_id))
      end
    end
    
    histories.sort_by{|history| [history.changed_on, history.journal_id]}
  end

  def ==(other)
    issue_id == other.issue_id && issue_subject == other.issue_subject && journal_id == other.journal_id &&
      changed_on == other.changed_on && old_login_id == other.old_login_id && new_login_id == other.new_login_id
  end

  private

  def self.to_login_id(user_id, login_id_cache)

    if user_id.blank?
      return nil
    end

    login_id = login_id_cache[user_id]

    if login_id.nil?
      user = User.find_by_id(user_id.to_i)
      login_id = user.login
      login_id_cache[user_id] = user.login
    end
    
    login_id
  end
end
