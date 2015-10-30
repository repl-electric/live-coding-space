#
#
#

shader :iColor, 0.5
shader :iZoom, 1.1
shader :iIt, 20.0

live_loop :play2 do
  shader :iIt, 30.0
  shader :decay, :iBeat, 1.0, 0.001

  #  with_fx(:echo, decay: 0.5, mix: 1.0, phase: 0.25) do
  #sample Corrupt[/kick/,[2,2]].tick(:sample), cutoff: 70, amp: 0.8
  #  end

  #with_fx(:slicer, phase: 4.0, probability: 0, mix: 1.0) do
  #sample Corrupt[/organic/,9], cutoff: 50, amp: 1.0, beat_stretch: 8.0
  #end

  with_fx(:slicer, phase: 4.0, probability: 0, mix: 1.0) do
    #  sample Corrupt[/organic/,9], cutoff: 135, amp: 1.0, beat_stretch: 8.0*2, rate: -1.0
  end

  with_fx :pan, pan: Math.sin(vt*13)/1.5 do
  with_fx(:echo, decay: 1.0, mix: 1.0, phase: 0.25*4) do
    with_fx(:slicer, phase: 0.25, probability: 0.0, smooth: 0.5) do
      #sample Corrupt[/f#m/,11], beat_stretch: 4, cutoff: 80
end
end
end
sleep 8
end

live_loop :bass do
  sync :play2
  #with_fx(:krush, mix: 1.0) do
  #sample Corrupt[/bass/,/f#m/,3], amp: 2.0, beat_stretch: 8*2, cutoff: 135
  #end
  with_fx(:slicer, phase: 0.25, probability: 0) do
    # sample Corrupt[/bass/,/f#m/,3], amp: 1.5, beat_stretch: 8*2, rate: -1.0
  end
  sleep 8
end

live_loop :perc do
  #  sample Corrupt[/violin/,4], cutoff: 100, amp: 0.5, beat_stretch: 16
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    #sample Corrupt[/f#m/,/fx/,0], cutoff: 100, amp: 0.5, beat_stretch: 16
  end
  sleep 16
end

live_loop :keys do
  #sync :play2
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    #sample Corrupt[/keys/, /f#m/, 7], beat_stretch: 16, cutoff: 100, amp: 0.5
  end
  sleep 16
end

live_loop :one_shots do
  #  sample Corrupt[/one shot/,/B_/]
  #  sample Corrupt[/Mbira/].tick
  sleep 8
end

with_fx(:reverb, room: 1.0, mix: 0.4, damp: 0.5) do |r_fx|
  live_loop :hum do
    #4.times{sync :play2}
    #  sample Corrupt[/Mic Hum/,/f#/].tick(:sample), cutoff: 130, amp: 0.5
    #sample Corrupt[/F#/, /Kalimba/, /texture/, /fx/, [1,4,2]].tick, amp: 2.0
    sleep 12
  end
end

with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
  live_loop :guitar do
    #sample Corrupt[/acoustic guitar/,/fx/, /f#/].tick(:sample),
    #  cutoff: 80, amp: 0.5
    sleep 8
  end
end

_=nil
live_loop :bells do
  #sync :keys
  #use_random_seed (ring 100, 200).tick
  use_synth :dsaw

  #with_fx(:krush, mix: 0.0, cutoff: 70) do
  with_fx(:reverb, room: 1.0, mix: 0.4, damp: 0.5, reps: 4.0, damp_slide: 1.0) do |r_fx|
    notes = scale(:Fs3, :minor_pentatonic, num_octaves: 1).shuffle.drop(1).take(3).shuffle
    synth :dsaw, note: (ring :D2, :Fs2, :Cs2).tick(:bass), cutoff: 50, decay: 8, amp: 0.0, detune: 12
    32.times{
      comment do
        play (knit notes.choose, 1, _,2, notes.choose,5),
          release: 0.05, sustain: 0.1, attack: 0.001,
          cutoff: rrand(70,80), amp: (rand+0.1)*0.0
        control r_fx, damp: rand, detune: 12
        synth :prophet, note: (knit notes.choose, 1, _,2, notes.choose,5).choose, cutoff: 55, release: 0.05, attack: 0.001, sustain: 0.1, amp: 0.5
      end
      sleep 0.25
    }

  end
  #end
end
