class AnnouncementsController < ApplicationController
  before_action :authenticate_user
  before_action :head_unauthorized, except: :active

  def my
    announcement = Announcement.where(user_id: current_user.id)

    announcement.empty? ? head(:forbidden) : render(json: announcement, status: :ok)
  end

  def active
    announcements = Announcement.active

    render(json: announcements, include: [], status: :ok)
  end

  def create
    announcement = Announcement.new(announcement_params)
    announcement.user_id = current_user&.id

    announcement.save ? render(json: announcement, status: :created) : head(:bad_request)
  end

  def cancel
    announcement = Announcement.find_by(id: params[:id])

    return head(:forbidden) unless current_user == announcement.user

    announcement.cancel!
    head(:ok)
  end

  private

  def announcement_params
    params.require(:announcement).permit(:description)
  end
end
