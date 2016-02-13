live_loop :time do
  use_random_seed (ring
                   200, 200, 100, 100,
                   200, 200, 100, 100,
                   200, 200, 100, 100,
                   200, 200, 300, 400,
                   ).tick(:cut)
  with_fx :lpf, cutoff: 60 do
    play scale(:Fs5, :minor_pentatonic).shuffle.choose, cutoff: 10, amp: 0.5
  end
  sleep (knit 0.25, 8).tick(:sleep)
end
_=nil
live_loop :time2, sync: :time do
  use_random_seed (ring
                   200, 200, 100, 100,
                   200, 200, 100, 100,
                   200, 200, 100, 100,
                   200, 200, 300, 400,
                   ).tick(:cut)


  with_fx(:reverb, room: 0.9, mix: 0.4, damp: 0.5) do |r_fx|
    with_fx :distortion, mix: 0.5 do
      n = (ring
           _, _, _, _,
           _, _, _, _,
           _, _, _, _,

           :FS3, :CS3, :D4, :E4,
           :A3, :E4, :Fs3, :E4,
           :A3, :E4, :Fs3, :E4
           ).tick(:n)
      synth :hollow, note: n, release: 0.125, amp: 1.5
    end
  end
  sleep (knit 0.25, 8).tick(:sleep)

end

live_loop :kick, sync: :time do
  sample Mountain[/kick/,[4,4]].tick(:sample), cutoff: 130, amp: 0.8
  sleep 1/2.0
  sample Mountain[/kick/,[4,4]].tick(:sample), cutoff: 100, amp: 0.5
  with_fx(:slicer, phase: (ring 0.25, 0.5,0.5,0.25).tick(:phase), probability: 0) do
    with_fx(:echo, decay: 0.5, mix: 1.0, phase: 0.25) do
      sample Mountain[/snare/,4], cutoff: 130, amp: 0.5
    end
  end
  sleep 1/2.0
end

live_loop :background, sync: :time do
  use_synth :dsaw
  d = (ring
       chord(:A2, :M),
       chord(:CS2, :m),
       chord(:A2, :M),
       chord(:Fs2, :m, invert: 1))
  d.tick
  #  play d.tick, decay: 2.0, release: 2.0, attack: 0.00001, detune: 12, cutoff: 90

  with_transpose 0 do
    synth :dsaw, note:    d.look, cutoff: 60, decay: 2.0, amp: 0.5
    synth :prophet, note: d.look, cutoff: 60, decay: 2.0, amp: 0.5
  end

  if spread(1,2).tick(:time)
    #synth :dark_sea_horn, note: d.look[0], decay: 4.0
  end
  sleep 4
end

live_loop :samples, sync: :time do
  sample Corrupt[/instrument/,/fx/, /f#/].tick(:sample), amp: 1.0
  sleep 32
end

live_loop :clickers, sync: :time do
  sleep 0.125
  if spread(7,11).tick
    sample Dust[/hat/,0..2].tick(:sample), cutoff: 50, amp: 1.0
  end
  if spread(3,8).tick
    sample Dust[/hats/,2..3].tick(:sample2), cutoff: 60, amp: 1.0
  end
end

live_loop :voices do
  #  with_fx :ixi_techno, phase: 0.25 do
  #sample Words[//,2], cutoff: 135, amp: 10.0
  # end
  sleep 32
end
