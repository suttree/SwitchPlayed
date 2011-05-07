class Score < ActiveRecord::Base
  belongs_to :game

  class << self
    def reward_players
      time = Time.now
      game = Game.in_progress
      Activity.all_chatroom_members.each do |row|
        unless Activity.user_quit_chat?(row.user.id, time)
          row.user.credit(Settings.chatroom_reward, :game_id => game.id)
          str = "try {Element.insert(\"chat_data\", { top: \"<span class='score'><li>#{game.current_score}</li></span>\" });} catch (e) { alert('RJS error:' + e.toString()); alert('Element.insert(\"chat_data\", { top: \"<li>#{game.current_score}</li>\" });'); throw e }"
          Juggernaut.send_to_all(str)
        end
      end
    end
  end
end
