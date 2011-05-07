class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  validates_presence_of :user_id, :game_id, :session_id, :remote_ip, :status

  class << self
    # Records a +user+ joining chat
    def juggernaut_join(user, game, remote_ip, session_id)
      transaction do
        create_with(user, game, remote_ip, session_id, 'juggernaut_join')
      end
    end

    # Records a +user+ disconnecting from chat
    def juggernaut_disconnect(user, game, remote_ip, session_id)
      create_with(user, game, remote_ip, session_id, 'juggernaut_disconnect')
    end

    # Records a +user+ leaving chat
    def juggernaut_close(user, game, remote_ip, session_id)
      create_with(user, game, remote_ip, session_id, 'juggernaut_close')
    end

    # Returns an array of all the +users+ to have joined the current chat room
    # Use find_in_batches if the number of users grows - http://afreshcup.com/2009/02/23/rails-23-batch-finding/
    def all_chatroom_members
      #all(:conditions => {:game_id => Game.in_progress.id, :status => 'juggernaut_join'}, :group => 'user_id')
      active_user_records = []
      users = all(:conditions => {:game_id => Game.in_progress.id, :status => 'juggernaut_join'})
      users.each do |row|
        active_user_records << row unless user_quit?(row.user_id, row.created_at)
      end
      active_user_records
    end

    # Has the user quit chat?
    def user_quit_chat?(user_id, timestamp)
      (Activity.user_disconnected?(user_id, timestamp) || Activity.user_closed?(user_id, timestamp))
    end

    # Same as +user_quit_chat?+ but with an OR, rather than two distinct queries.
    # Not sure which will perform better, or faster...
    def user_quit?(user_id, timestamp)
      Activity.exists?(["user_id = ? AND game_id = ? AND created_at >= ? AND (status = ? OR status = ?)", user_id, Game.in_progress.id, timestamp, 'juggernaut_disconnect', 'juggernaut_close'])
    end

    def user_disconnected?(user_id, timestamp)
      Activity.exists?(["user_id = ? AND game_id = ? AND created_at >= ? AND status = ?", user_id, Game.in_progress.id, timestamp, 'juggernaut_disconnect'])
    end

    def user_closed?(user_id, timestamp)
      Activity.exists?(["user_id = ? AND game_id = ? AND created_at >= ? AND status = ?", user_id, Game.in_progress.id, timestamp, 'juggernaut_close'])
    end

    protected
    # Will +remote_ip+ always return the ip of the chat server, not the user?
    def create_with(user, game, remote_ip, session_id, status)
      create(
        :user_id => user.id,
        :game_id => game.id,
        :session_id => session_id,
        :remote_ip => remote_ip,
        :status => status
      )
    end
  end
end
