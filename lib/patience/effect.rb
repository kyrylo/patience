module Patience
  module Effect
    include Ray::Helper

    extend self

    attr_reader :animations

    @animations = Ray::AnimationList.new

    def call_off(card, init_pos)
      @animations << translation(:from     => card.pos,
                                 :to       => init_pos,
                                 :duration => 0.15).start(card)
    end


  end
end
