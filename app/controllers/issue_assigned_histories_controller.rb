class IssueAssignedHistoriesController < ApplicationController

  before_action :authorize, :except => [:index]
  accept_api_auth :index

  def index
    period = params[:period].present? ? params[:period].to_i : 5 # default 5min
    if period > 60
      period = 60 # max 60min
    end

    @histories = IssueAssignedHistory.after(Time.now - (period * 60))
    respond_to do |format|
      format.api
    end
  end
end
