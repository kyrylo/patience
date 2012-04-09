module Patience
  # Handles all the animations of the game.
  #
  # Examples
  #
  #   Animation.call_off(ace_of_hearts, Ray::Vector2[0, 0])
  module Animation
    include Ray::Helper

    extend self

    attr_reader :animations, :moving_cards

    # The Array of cards, that are involved in animation.
    @moving_cards = []

    # The Ray::AnimationList of animations to be executed.
    @animations   = Ray::AnimationList.new

    # Animate EventHandler::Drop#call_off event.
    #
    # card     - The Card for animation.
    # init_pos - The Ray::Vector2 position of the card.
    #
    # Examples
    #
    #   Animation.call_off(ace_of_hearts, Ray::Vector2[0, 0])
    #
    # Returns nothing.
    def call_off(card, init_pos)
      call_off = translation(
        :from => card.pos,
        :to => init_pos,
        :duration => 0.15
      )

      @moving_cards << card
      @animations   << call_off.start(card)

      on :animation_end, call_off do
        @moving_cards.delete_at(0)
        @animations.animations.delete_at(0)
      end
    end

  end
end
