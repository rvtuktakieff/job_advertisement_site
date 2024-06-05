class ResponsesController < ApplicationController
  before_action :authenticate_user
  before_action :head_unauthorized
  before_action :set_announcement
  before_action :set_response, only: [:cancel, :accept]

  def create
    return head(:bad_request) if @announcement.user_id == current_user.id || !@announcement.active?

    resp = Response.new(response_params.merge({ announcement_id: @announcement.id, user_id: current_user.id }))

    resp.save ? render(json: resp, status: :created) : head(:bad_request)
  end

  def accept
    return head(:forbidden) unless @announcement.user_id == current_user.id
    return head(:bad_request) unless @resp.may_accept?

    @resp.accept!
    @announcement.close!
    head(:ok)
  end

  def cancel
    return head(:forbidden) if @announcement.user_id == current_user.id
    return head(:bad_request) unless @resp.may_cancel?

    @resp.cancel!
    head(:ok)
  end

  private

  def response_params
    params.require(:response).permit(:price)
  end

  def set_announcement
    @announcement = Announcement.find_by(id: params[:announcement_id])
  end

  def set_response
    @resp = Response.find_by(id: params[:id])
  end
end
