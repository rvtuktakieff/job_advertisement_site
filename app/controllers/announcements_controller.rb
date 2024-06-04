class AnnouncementsController < ApplicationController
  before_action :authenticate_user
  before_action :head_unauthorized, except: :active

  def my
    announcement = Announcement.where(user_id: current_user.id)

    if announcement.empty?
      head(:forbidden)
    else
      render(json: announcement, status: :ok)
    end
  end

  def active
    announcements = Announcement.active

    render(json: announcements, status: :ok)
  end

  def create
    announcement = Announcement.new(announcement_params)
    announcement.user_id = current_user&.id

    if announcement.save
      render(json: announcement, status: :created)
    else
      head(:bad_request)
    end
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
