live_loop :beat do
  with_fx :reverb, room: 0.0, damp: 0.0 do
    sample Frag[/kick/,2], rate: (ramp *range(0.1, 1.0,0.1)).tick, start: 0.0, amp: 0.1
  end
  sleep 8
end

live_loop :beat2 do
  sync :beat
  #  with_fx(:slicer, phase: 0.25*1, probability: 0) do
  #sample Dust[/f#/,2], cutoff: (ramp *(range 100, 130,1)).tick(:cut), amp: 1.0
  #  sample Dust[/f#/,1], amp: 1.0

  #  end
  #  sample Frag[/kick/,[0,0]].tick(:sample), cutoff: 130, amp: 2.5
  # sample Dust[/beat/,6], cutoff: 135, amp: 1.5, beat_stretch: 8.0
  sample Dust[/beat/,1], cutoff: 135, amp: 1.5, beat_stretch: 8.0
  # sample Dust[/beat/,3], cutoff: 135, amp: 1.5, beat_stretch: 8.0

  #sample Dust[/f#/,0], cutoff: 135, amp: 0.5, beat_stretch: 8.0*2.0

  #  with_fx(:slicer, phase: 0.25*1, probability: 0) do
  #sample Dust[/f#/,1], cutoff: 135, amp: 0.5, beat_stretch: 8.0*2.0
  # with_fx(:krush) do
  #sample Dust[/f#/,1], cutoff: 130, amp: 1.5, beat_stretch: 8.0
  # end
  with_fx(:echo, decay: 8.0, mix: 1.0, phase: 1.0, max_phase: 0.5) do
    #    sample Dust[/whale/,1], cutoff: 130, amp: 0.5
  end
end

live_loop :drums do
  #sync :beat
  #sample Frag[/kick/,[0,0,0,1]].tick(:sample), cutoff: 120, amp: 2.5
  sleep 2
end
_=nil
live_loop :synths do
  sync :beat
  use_synth :hollow
  use_random_seed 300
  notes = #scale(:fs4, :minor_pentatonic).shuffle.take(4)

  with_fx(:reverb, room: 1.0, mix: 0.5, damp: 0.5, reps: 4.0) do |r_fx|
    with_fx(:pitch_shift, window_size: 0.1, pitch_dis: 0.005, time_dis: 0.001, mix: 0.0) do
      #synth :dark_ambience, note: (ring :Fs3), decay: 8.0, attack: 1.0, amp: 8.0
      16.times{
        notes = (knit
                 :fs2, 1, _, 3,
                 :e2,  1, _, 1,
                 :cs2, 1, _, 0,
                 :d2,  1, _, 3,
                 :cs2, 1, _, 0,
                 :e2,  1, _, 3)

        synth :prophet, note: notes.tick(:n), cutoff: 90, amp: 0.5, decay: 0.5
        with_transpose(-12) do
          play notes.look(:n),
            attack: 0.01, cutoff: 80,
            detune: 12,
            release: (knit 1.0, 6, 0.5, 5, 1.0, 5).tick(:s),
            amp: 1.5
          sleep 0.25*2
        end
      }
    end
  end
end
