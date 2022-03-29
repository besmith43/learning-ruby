# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :connected_user

    def connect
      self.connected_user = find_verified_user
    end

    protected

    def find_verified_user
      if connected_user = User.find_by(id: cookies.signed[:user_id])
        connected_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
