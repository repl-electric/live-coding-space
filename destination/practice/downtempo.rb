_=nil
set_volume! 0.2

with_fx :wobble, phase: 16 do
  live_loop :t2 do
    #synth :dark_sea_horn, note: (chord :Fs2, :m), release: 16, amp: 0.2
    #synth :dark_ambience, note: (chord :E5, :M7), release: 16, amp: 0.5, attack: 6
    sleep 16
  end
end

live_loop :texture do
  #sample MagicDust[/texture/].tick(:sample), amp: 0.2
  sleep 16
end

with_fx(:reverb, room: 0.6, mix: 0.8, damp: 0.5, damp_slide: 1.0, mix_slide: 0.1) do |r_fx|
  live_loop :soft, sync: :kick do
    s = synth :beep, note: (ring chord(:Fs3, :m), chord(:D3, :M), chord(:E3, :M)).tick(:c)
    s = synth :hollow, note: (ring chord(:Fs3, :m), chord(:D3, :M), chord(:E3, :M)).look(:c), release: 8, decay: 12, amp: 1.0, amp_slide: 0.5, attack: 0.2
    16.times{control r_fx, damp: rand, mix: rand; s.sub_nodes.each{|sy| control sy, amp: rrand(0.5,1.0)}; sleep 1}
  end
end

live_loop :texture2 do
  #sample Corrupt[/instrument/,/fx/,/f#/,[0,3]].tick(:sample), amp: 0.2, pan: (ring 0.25,-0.25).tick
  sleep 16
end

live_loop :coils do
  #sample Fraz[/coil/,/f#/,[1,2]].tick(:sample), beat_stretch: 32, amp: 0.1
  sleep 32
end

live_loop :dust, sync: :kick do
  s= (range 0.0, 1.0, 0.05).tick(:r)
  if spread(6,8).tick(:notes)
    #sample MagicDust[/notes/, /_E\./,[5,3]].tick(:sample)
  end
  s= (ring
      0.125, 0.125, 0.125, 0.125,
      0.25, 0.5, 0.25, 0.5).tick
  with_fx :echo, decay: 0.125, mix: (range 0.0,1.0,0.1).tick(:d) do
    sample MagicDust[/notes/,/_Gb\./,[2,4]].tick(:sample), amp: 0.2,
      start: s, finish: s+(knit 0.125,5,0.25,1,0.125,2).tick(:l),
      cutoff: (range 80,135).tick(:p), pan: (ring 0.25,-0.25).tick(:pan),
      rpitch: (knit 8,16,-2,2).tick(:pith)
    #    sample Fraz[/c#|f#/,/atmos/].tick(:sample), cutoff: 135, amp: 2.5, start: 0.0, finish: 0.00125, rpitch: (knit -32, 2, -16,2, -8,2, 0,2).tick(:rp)
  end
  sleep s
end

live_loop :pl, sync: :kick do
  score = (ring [0.25], [0.25], [0.125], [0.125], [0.125], [0.125])
  note = score.tick
  with_fx :distortion, mix: (range 0.0, 0.1, 0.001).tick(:d) do
    synth :plucked, note: (knit
                           chord(:FS3, :m11),32,
                           chord(:D3, :M7),32,
                           chord(:E3, :M7),32
    ).tick.choose,
      amp: 0.015, release: note[-1], attack: 0.05
  end
  sleep note[-1]
end

live_loop :kick do
  with_fx :lpf, cutoff: 50*0 do
    with_fx :distortion, mix: 0.8 do
      synth :chipbass, note: :D1
      synth :growl, note: :D2, attack: 0.001
    end
  end
  
  with_fx :lpf, cutoff: 0 do
    with_fx :distortion, mix: 0.0 do
      s = (ring
           :FS1, :Fs1, :D2, :D2, :D3, :D3,
           :D1, :D1,  :E2, :E2, :E3, :E3,
           :E1, :E1, :E2, :E2, :E3, :E3)
      if spread(1,8).look
        sample Corrupt[/kick/,7]
      else
        sample Corrupt[/kick/,7], cutoff: 90
      end
      sy = :plucked
      sample Fraz[/coil/,/c#/,[0,0]].tick(:sample), cutoff: 130, amp: 0.4, start: 0.2, finish: 0.15
      synth sy, note: s.tick, wave: 4, release: 0.125, attack: 0.001
      sleep 1/4.0
      with_transpose 0 do
        with_fx :reverb, room: 1.0, mix: 1.0, cutoff: 131 do
          with_transpose 12 do
            synth :beep, note: s.tick, release: 0.25, attack: 1.0, amp: 0.15, pan: (ring 0.25, -0.25).tick(:pan)
          end
          #synth :prophet, note: s.tick, release: 0.25, attack: 2.0, amp: 0.1, pan: (ring 0.25, -0.25).tick(:pan)
        end
        synth :growl, note: s.look, release: 0.25, attack: 0.1, amp: 0.5
      end
      synth :gpa, note: s.look, wave: 1, release: 0.25, attack: 0.001, amp: 2
      sleep 1/4.0
      #sample Corrupt[/GuitarThud/].tick(:hitit), amp: 0.1
      synth :gpa, note: s.tick, wave: 1, release: 0.25, attack: 0.001, amp: 2
      sleep 1/4.0
      #synth :gpa, note: s.tick, wave: 4, release: 0.125, attack: 0.001
      sleep 1/4.0
      #sample Corrupt[/snare/,0], amp: 0.2
      #sample Corrupt[/hit/,9], amp: 2.8 if spread(1,32).look
      synth :gpa, note: s.tick, wave: 0, release: 0.125, attack: 0.001, amp: 2
      sleep 1/4.0
      synth :gpa, note: s.tick, wave: 0, release: 0.125, attack: 0.001, amp: 2
      sleep 1/4.0
      #sample Corrupt[/GuitarThud/,0], amp: 0.2
      synth :gpa, note: s.tick, wave: 0, release: 0.125, attack: 0.001, amp: 2
      sleep 1/4.0
      synth :gpa, note: s.tick, wave: 0, release: 0.125, attack: 0.001, amp: 2
      sleep 1/4.0
    end
  end
end
