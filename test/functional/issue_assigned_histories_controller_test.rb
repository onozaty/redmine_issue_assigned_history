require File.expand_path('../../test_helper', __FILE__)

class IssueAssignedHistoriesControllerTest < Redmine::ControllerTest
  include Redmine::I18n

  fixtures :projects, :users, :enabled_modules, :roles, :members, :member_roles, :issue_statuses

  fixture_dir = File.dirname(__FILE__) + '/../fixtures/functional'
  ActiveRecord::FixtureSet.create_fixtures(fixture_dir, 'issues')
  ActiveRecord::FixtureSet.create_fixtures(fixture_dir, 'journals')
  ActiveRecord::FixtureSet.create_fixtures(fixture_dir, 'journal_details')

  def setup
    @user1 = User.find(1)

    @issue1 = Issue.find(1)
    @issue2 = Issue.find(2)

    @journal1 = Journal.find(1)
    @journal2 = Journal.find(2)
    @journal3 = Journal.find(3)
    @journal4 = Journal.find(4)

    Setting.rest_api_enabled = '1'

    # ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  def test_index

    get :index, :format => :json, :params => { :key => @user1.api_key.to_s }

    assert_response :success
    assert_equal 'application/json', response.media_type

    data = ActiveSupport::JSON.decode(response.body)

    assert_equal 1, data['total_count']
    assert_equal(
      [
        {
          'type' => 'change',
          'issue' => {'id' => 2, 'subject' => 'issue2', 'status_id' => 1, 'status_name' => 'New'},
          'journal_id' => 4,
          'changed_on' => @journal4.created_on.iso8601,
          'old_assigned_to' => nil,
          'new_assigned_to' => {'id' => 3, 'login' => 'dlopper', 'firstname' => 'Dave', 'lastname' => 'Lopper'},
          'project' => {'id' => 2, 'identifier' => 'onlinestore'}
        }
      ],
      data['histories'])

  end

  def test_index_period

    get :index, :format => :json, :params => { :key => @user1.api_key.to_s, :period => 10}

    assert_response :success
    assert_equal 'application/json', response.media_type

    data = ActiveSupport::JSON.decode(response.body)

    assert_equal 3, data['total_count']
    assert_equal(
      [
        {
          'type' => 'change',
          'issue' => {'id'=> 2, 'subject'=> 'issue2', 'status_id'=> 1, 'status_name'=> 'New'},
          'journal_id'=> 4,
          'changed_on'=> @journal4.created_on.iso8601,
          'old_assigned_to'=> nil,
          'new_assigned_to'=> {'id'=> 3, 'login'=> 'dlopper', 'firstname'=> 'Dave', 'lastname'=> 'Lopper'},
          'project'=> {'id'=> 2, 'identifier'=> 'onlinestore'}
        },
        {
          'type' => 'change',
          'issue' => {'id'=> 2, 'subject'=> 'issue2', 'status_id'=> 1, 'status_name'=> 'New'},
          'journal_id'=> 3,
          'changed_on'=> @journal3.created_on.iso8601,
          'old_assigned_to'=> {'id'=> 1, 'login'=> 'admin', 'firstname'=> 'Redmine', 'lastname'=> 'Admin'},
          'new_assigned_to'=> nil,
          'project'=> {'id'=> 2, 'identifier'=> 'onlinestore'}
        },
        {
          'type' => 'new',
          'issue' => {'id'=> 1, 'subject'=> 'issue1', 'status_id'=> 2, 'status_name'=> 'Assigned'},
          'journal_id'=> nil,
          'changed_on'=> @issue1.created_on.iso8601,
          'old_assigned_to'=> nil,
          'new_assigned_to'=> {'id'=> 1, 'login'=> 'admin', 'firstname'=> 'Redmine', 'lastname'=> 'Admin'},
          'project'=> {'id'=> 1, 'identifier'=> 'ecookbook'}
        }
      ],
      data['histories'])

  end

  def test_index_period_max

    get :index, :format => :json, :params => { :key => @user1.api_key.to_s, :period => 100}

    assert_response :success
    assert_equal 'application/json', response.media_type

    data = ActiveSupport::JSON.decode(response.body)

    assert_equal 4, data['total_count']
    assert_equal(
      [
        {
          'type' => 'change',
          'issue' => {'id'=> 2, 'subject'=> 'issue2', 'status_id'=> 1, 'status_name'=> 'New'},
          'journal_id'=> 4,
          'changed_on'=> @journal4.created_on.iso8601,
          'old_assigned_to'=> nil,
          'new_assigned_to'=> {'id'=> 3, 'login'=> 'dlopper', 'firstname'=> 'Dave', 'lastname'=> 'Lopper'},
          'project'=> {'id'=> 2, 'identifier'=> 'onlinestore'}
        },
        {
          'type' => 'change',
          'issue' => {'id'=> 2, 'subject'=> 'issue2', 'status_id'=> 1, 'status_name'=> 'New'},
          'journal_id'=> 3,
          'changed_on'=> @journal3.created_on.iso8601,
          'old_assigned_to'=> {'id'=> 1, 'login'=> 'admin', 'firstname'=> 'Redmine', 'lastname'=> 'Admin'},
          'new_assigned_to'=> nil,
          'project'=> {'id'=> 2, 'identifier'=> 'onlinestore'}
        },
        {
          'type' => 'new',
          'issue' => {'id'=> 1, 'subject'=> 'issue1', 'status_id'=> 2, 'status_name'=> 'Assigned'},
          'journal_id'=> nil,
          'changed_on'=> @issue1.created_on.iso8601,
          'old_assigned_to'=> nil,
          'new_assigned_to'=> {'id'=> 1, 'login'=> 'admin', 'firstname'=> 'Redmine', 'lastname'=> 'Admin'},
          'project'=> {'id'=> 1, 'identifier'=> 'ecookbook'}
        },
        {
          'type' => 'change',
          'issue' => {'id'=> 2, 'subject'=> 'issue2', 'status_id'=> 1, 'status_name'=> 'New'},
          'journal_id'=> 2,
          'changed_on'=> @journal2.created_on.iso8601,
          'old_assigned_to'=> {'id'=> 3, 'login'=> 'dlopper', 'firstname'=> 'Dave', 'lastname'=> 'Lopper'},
          'new_assigned_to'=> {'id'=> 1, 'login'=> 'admin', 'firstname'=> 'Redmine', 'lastname'=> 'Admin'},
          'project'=> {'id'=> 2, 'identifier'=> 'onlinestore'}
        }
      ],
      data['histories'])

  end

  def test_index_anonymous

    get :index, :format => :json

    assert_response :success
    assert_equal 'application/json', response.media_type

    data = ActiveSupport::JSON.decode(response.body)

    assert_equal 0, data['total_count']
    assert_equal(
      [],
      data['histories'])

  end

end
