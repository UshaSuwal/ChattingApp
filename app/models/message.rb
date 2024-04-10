class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  after_create_commit { broadcast_append_to room }
  before_create :confirm_participant, :bodychange
  # profanity_filter! :body, method: 'vowels'

  private
  def confirm_participant
    return unless room.is_private
    is_participant = Participant.where(user_id: user.id, room_id: room.id).first
    throw :abort unless is_participant
  end
  def bodychange
    if !room.is_private
      ProfanityFilter::Base.clean(read_attribute(:body), "hollow")
    end
  end



  # def filter_profanity
  #   return if room.is_private?
  #   self.body = ProfanityFilter::Base.clean(body, "hollow")
  # end

end
