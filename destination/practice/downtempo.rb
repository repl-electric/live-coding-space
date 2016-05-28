_=nil
set_volume! 1.0

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
    score = (ring
             [chord(:fs3, 'm'), 8], [chord(:D3, :M), 8], [chord(:E3, :M), 8],
             [chord(:fs3, 'm+5'), 8], [chord(:D3, :M), 8], [chord(:Cs3, :m), 16])
    n = score.tick
    puts n
    #s = synth :beep, note: n[0]
    #s = synth :hollow, note: n[0], release: n[-1]/2.0, decay: n[-1]/2.0 + 5, amp: 1.0, amp_slide: 0.5, attack: 0.2
    with_transpose -12 do
      #synth :dark_sea_horn, note: :Cs4, release: 16, amp: 0.5
    end
    
    n[-1].times{control r_fx, damp: rand, mix: rand; s.sub_nodes.each{|sy| control sy, amp: rrand(0.5,1.0)}; sleep 1}
  end
end

live_loop :texture2 do
  #sample Corrupt[/instrument/,/fx/,/f#/,[0,3]].tick(:sample), amp: 0.2, pan: (ring 0.25,-0.25).tick
  sleep 16
end

live_loop :coilsz, sync: :kick do
  with_fx(:slicer, phase: 0.5, smooth: 0.5, mix: 0.0) do
    puts Corrupt[/_e_/,0]
    #sample Corrupt[/_e_/,0], amp: 1.0, beat_stretch: 32
  end
  
  e = Corrupt[/_Bass_/,/_e_/,[0,0]].tick
  #synth :prophet, note: :B2, release:  8, amp: 3.0, cutoff: 60
  puts e
  sleep 32
  #sample_and_sleep e, amp: 4.0, beat_stretch: 32
end
live_loop :dust, sync: :kick do
  s= (range 0.0, 1.0, 0.05).tick(:r)
  if spread(6,8).tick(:notes)
    #sample MagicDust[/notes/, /_E\./,[5,3]].tick(:sample), rpitch: -12*4
  end
  s= (ring
      0.125, 0.125, 0.125, 0.125,
      0.25, 0.5, 0.25, 0.5).tick
  with_fx :echo, decay: 0.125, mix: (range 0.0,1.0,0.1).tick(:d) do
    #synth :plucked, note: (ring :E3, _, _, _).tick(:n), decay: 0.5, amp: 0.2
    # sample Corrupt[/_e_/,[6,_,_,_]].tick(:sample), amp: 8.0,
    #   start: s, finish: s+(knit 0.0125,5,0.125,1,0.0125,2).tick(:l),
    #   cutoff: (range 80,135).tick(:p), pan: (ring 0.25,-0.25).tick(:pan),
    #   rpitch: -8
    #    sample Fraz[/c#|f#/,/atmos/].tick(:sample), cutoff: 135, amp: 2.5, start: 0.0, finish: 0.00125, rpitch: (knit -32, 2, -16,2, -8,2, 0,2).tick(:rp)
  end
  sleep s
end

live_loop :percussion, sync: :kick do
  tick
  suspects = (ring
              MagicDust[/ORGANIC_HIT_HI/,25],
              MagicDust[/ORGANIC_HIT_HI/,17],
              MagicDust[/ORGANIC_HIT_LO/,28])
  x = (knit :reverb,31, :echo, 1).tick(:fx)
  with_fx x, mix: (range 0.0, 0.4, 0.4/64).look do
    if (ring
        1, 1, 1,   1, 0, 0,
        1, 0, 0,   0, 0, 0).look != 0
      sample suspects.look, amp: 0.5, pan: (ring 0.25,-0.25).look
    end
  end
  
  sleep 1/4.0
end

live_loop :high, sync: :kick do
  score = (knit :E3,8, :D2,8).tick
  with_fx :reverb, mix: 0.1 do
    #synth :gpa, note: score, decay: 0.5, release: 0.01, amp: 0.2, attack: 0.1, wave: 4
  end
  sleep 2
  #synth :plucked, note: score, decay: 0.5, release: 0.01, amp: 0.5, attack: 0.02
  sleep 1
  with_transpose 12 do
    #synth :plucked, note: score, decay: 0.5, release: 0.01, amp: 0.8, attack: 0.1
  end
  sleep 2- 1
end

live_loop :pl, sync: :kick do
  score = (ring [0.25], [0.25], [0.125], [0.125], [0.125], [0.125])
  note = score.tick
  with_fx :distortion, mix: (range 0.0, 0.1, 0.001).tick(:d) do
    #synth :plucked, note: (knit
    #                       chord(:FS3, :m11),32,
    #                       chord(:D3, :M7),32,
    #                       chord(:E3, :M7),32
    #).tick.choose,
    #  amp: 0.0, release: note[-1], attack: 0.05
  end
  sleep note[-1]
end

live_loop :bassline, sync: :kick do
  #synth :plucked, note: (knit :fs1,4, :D1,4, :E1,4).tick, cutoff: 60, release: 0.25, decay: 0.25, amp: 1.0, attack: 0.0001
  with_fx :octaver, phase: 32 do
    #sample Mountain[/bow/, /f#/,[0,_]].tick(:sample), beat_stretch: 8, amp: 0.05
  end
  sleep 1
end

live_loop :melody,sync: :kick do
  #synth :plucked, note: (ring :Fs4, :D3, :E3).tick(:n), release: (ring 0.125, 0.25, 0.125, 0.25).tick, amp: 0.0
  sleep 1/4.0
end

live_loop :kick do
  bass_note = (knit :D1, 4, :Fs1, 4, :Cs1, 4,
               :D1, 4, :Fs1, 4, :Cs1, 8).tick(:b)
  with_fx :lpf, cutoff: 50*1 do
    with_fx :distortion, mix: 0.8 do
      with_transpose -12 do
        synth :chipbass, note: bass_note
      end
      synth :growl, note: bass_note, attack: 0.001, amp: 2
    end
  end
  
  with_fx :lpf, cutoff: 100 do
    with_fx :distortion, mix: 0.0 do
      s = (knit
           [:Fs4,0.125],6, [:D4,0.125], 2, [:Fs4,0.125],4 #[:Fs2, 0.125], [:D2,0.25], [:D2,0.125], [:D3,0.125], [:D3,0.125],
           # [:D2,0.125], [:D2, 0.125], [:D3,0.125], [:D3,0.125], [:D2,0.125], [:D2,0.125],
           # [:E2,0.125], [:E2, 0.125], [:E3,0.125], [:E3,0.125], [:E2,0.125], [:E2,0.125],
           #:D4, :D4,  :E4, :E2, :E3, :E3,
           # :E4, :E4, :E4, :E4, :E4, :E4
           )
      if spread(1,8).look
        sample Corrupt[/kick/,7], amp: 2
      else
        sample Corrupt[/kick/,7], cutoff: 90
      end
      sy = :plucked
      #sample Fraz[/coil/,/c#/,[0,0]].tick(:sample), cutoff: 130, amp: 0.3, start: 0.2, finish: 0.15
      #synth sy, note: s.tick, wave: 4, release: 0.125, attack: 0.001
      sleep 1/4.0
      with_transpose 0 do
        with_fx :reverb, room: 1.0, mix: 1.0, cutoff: 131 do
          with_transpose 12 do
            #synth :beep, note: s.tick, release: 0.25, attack: 1.0, amp: 0.15, pan: (ring 0.25, -0.25).tick(:pan)
          end
          #synth :prophet, note: s.tick, release: 0.25, attack: 2.0, amp: 0.1, pan: (ring 0.25, -0.25).tick(:pan)
        end
        #synth :growl, note: s.look, release: 0.25, attack: 0.1, amp: 0.5
      end
      #  synth :gpa, note: s.look[0], wave: 1, release: s.look[-1], attack: 0.001, amp: 4
      sleep 1/4.0
      sample Corrupt[/GuitarThud/].tick(:hitit), amp: 0.5
      #synth :gpa, note: s.tick[0], wave: 1, release: s.look[-1], attack: 0.001, amp: 4
      sleep 1/4.0
      #synth :gpa, note: s.tick, wave: 4, release: 0.125, attack: 0.001
      sleep 1/4.0
      sample Corrupt[/snare/,0], amp: 0.2
      sample Corrupt[/hit/,9], amp: 2.8 if spread(1,32).look
      #        synth :gpa, note: s.tick[0], wave: 0, release: s.look[-1], attack: 0.001, amp: 1
      sleep 1/4.0
      #       synth :gpa, note: s.tick[0], wave: 0, release: s.look[-1], attack: 0.001, amp: 1
      sleep 1/4.0
      sample Corrupt[/GuitarThud/,0], amp: 0.8
      #    synth :gpa, note: s.tick[0], wave: 0, release: s.look[-1], attack: 0.001, amp: 1
      sleep 1/4.0
      #  synth :gpa, note: s.tick[0], wave: 0, release: s.look[-1], attack: 0.001, amp: 1
      sleep 1/4.0
    end
  end
end
