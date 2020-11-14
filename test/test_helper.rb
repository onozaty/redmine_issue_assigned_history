# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
ActiveRecord::FixtureSet.create_fixtures(File.dirname(__FILE__) + '/fixtures/', 'issues')
ActiveRecord::FixtureSet.create_fixtures(File.dirname(__FILE__) + '/fixtures/', 'journals')
ActiveRecord::FixtureSet.create_fixtures(File.dirname(__FILE__) + '/fixtures/', 'journal_details')
