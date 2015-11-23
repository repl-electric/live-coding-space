live_loop :meta_programming do
  with_fx :reverb, room: 0.5 do
    with_fx(:pitch_shift, mix: 0.8, window_size: 0.1, pitch_dis: 0.05) do
      with_fx(:flanger, feedback: 0.8, decay: 0.5, mix: 0.4) do |r_fx|
                sample Words[/guy/,0], amp: 2.5
      end
    end
  end
  sleep 32
end


with_fx(:reverb, room: 0.8, mix: 0.9, damp: 0.5) do |r_fx|
  live_loop :warm_up do
    #    sample Corrupt[/acoustic guitar/, /fx/].tick, cutoff: 75, amp: 1.5, beat_stretch: 8.0
    #sync :organ
    with_fx(:slicer, phase: 0.25*1, probability: 0) do

      with_synth :dark_sea_horn do
        play :e3, cutoff: 74, decay: 8.1, amp: 1.6
      end
    end

    sleep 8
  end
end
