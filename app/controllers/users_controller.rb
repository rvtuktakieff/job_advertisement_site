class UsersController < ApplicationController
  def create
    User.create
  end
end
