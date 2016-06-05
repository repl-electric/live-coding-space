_=nil
set_volume! 1.0

with_fx :wobble, phase: 16 do
  live_loop :t2 do
    #synth :dark_sea_horn, note: (chord :Fs2, :m), release: 16, amp: 0.2
    #synth :dark_ambience, note: (chord :E5, :M7), release: 16, amp: 0.5, attack: 6
    sleep 16
  end
end
with_fx :gverb do
  live_loop :texture, sync: :soft do
    #sample MagicDust[/texture/].tick(:sample), amp: 0.2
    synth :dpulse, note: (knit :cs5,10, :d5,4, :e5,2).tick, amp: 0.01, attack: 0.1, detune: 0
    sleep 1
  end
end
with_fx(:reverb, room: 0.6, mix: 0.8, damp: 0.5, damp_slide: 1.0, mix_slide: 0.1) do |r_fx|
  live_loop :soft, sync: :kick do
    score = (ring
             [chord(:fs3, 'm'), 8], [chord(:D3, :M), 8], [chord(:E3, :M), 8],
             [chord(:fs3, 'm+5'), 8], [chord(:D3, :M), 8], [chord(:Cs3, :m, invert: 0), 16],
             [chord(:Fs3, :sus4), 8],[chord(:Cs3, :m), 8], [chord(:D3, :M), 8],
             [chord(:fs3, 'm+5'), 8], [chord(:D3, :M), 8], [chord(:Cs3, :m), 16])
    n = score.tick
    puts note_inspect(n[0])
    
    #    sample Instruments[/violin/,/f#/].tick(:sample), amp: 2.5
    
    with_fx :echo, decay: 16 do
      with_fx :bitcrusher, mix: 1.0, bits: (range 8, 32,1).tick(:dis) do
        #        sample Instruments[/violin/,(ring 'fs5', 'd4', 'E4').tick(:vn),/1/].tick(:sample), amp: 0.015, attack: 2.0
      end
    end
    
    s = synth :beep, note: n[0]
    s = synth :hollow, note: n[0], release: n[-1]/2.0, decay: n[-1]/2.0 + 5, amp: 1.0, amp_slide: 0.5, attack: 0.2
    d = nil
    with_transpose -12 do
      #d = synth :dark_sea_horn, note: (ring n[0][0],_).tick(:dark), release: 16, amp: 1.5, cutoff: 100, note_slide: 2.0
    end
    
    n[-1].times{|idx|
      if s.respond_to? :sub_nodes
        control r_fx, damp: rand, mix: rand; s.sub_nodes.each{|sy| control sy, amp: rrand(0.5,1.0)}
        #control(d, note: n[0].choose-12*2) if d && idx % 8 == 0
      end
      sleep 1
    }
  end
end

live_loop :texture2 do
  #sample Corrupt[/instrument/,/fx/,/f#/,[0,3]].tick(:sample), amp: 0.2, pan: (ring 0.25,-0.25).tick
  sleep 16
end

live_loop :coilsz, sync: :kick do
  with_fx(:slicer, phase: 0.5, smooth: 0.5, mix: 0.0) do
    #sample Corrupt[/_e_/,0], amp: 5.0, beat_stretch: 32
  end
  
  e = Corrupt[/_Bass_/,/_e_/,[0,0]].tick
  #synth :prophet, note: :B2, release:  8, amp: 3.0, cutoff: 60
  puts e
  sleep 32
  #sample_and_sleep e, amp: 4.0, beat_stretch: 32
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
      sample suspects.look, amp: 0.25*1, pan: (ring 0.25,-0.25).look
    end
  end
  sleep 1/4.0
end

live_loop :skitter,sync: :kick do
  sample (ring MagicDust[/_HI/,[34,_,19,22]].tick(:sample), _, _).tick(:s),  amp: 1.0*0.25+rand*0.05, pan: Math.sin(vt*16)/2.0
#  with_fx :wobble, phase: 16 do
 #   sample Frag[/coil/,/f#/,3], amp: 2.5, beat_stretch: 32
  #end
  sleep 1/8.0
end

live_loop :skat, sync: :kick do
  sample Junk[/perc/,[0,0]].tick(:sample), amp: 0.25*1, rpitch: -8
  sleep 32.0
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
  with_fx :octaver do
    #sample Mountain[/bow/, ring(/f#/).tick(:bowing),[0,1,2,3,4]].tick(:sample), beat_stretch: 8, amp: 0.5
  end
  sleep 32
end

with_fx :gverb, room: 300, mix: 1.0, spread: 2.0, damp: 0.0, dry: 1.0 do
  live_loop :melody,sync: :kick do
    with_fx :distortion, distort: 0.0 do
      synth :plucked, note: (knit
                             (ring :Cs5, :Fs4, _, :Fs4), 32,
                             (ring :B4,  :D4,  _, :D4), 32,
                             (ring :Cs5, :E4,  _, :E4), 32,
                             
                             (ring :Fs5, :Fs4, _, :Fs4), 32,
                             (ring :B4,  :D4,  _, :D4), 32,
                             (ring :A4, :Cs4,  _, :Cs4), 32
                             
                             ).tick.tick(:n), release: (ring 0.125, 0.25, 0.125, 0.25).tick, amp: 0.1*1
      sleep 1/4.0
    end
  end
end

live_loop :kick do
  #  FAC        DFA        EGB                                         CEG
  #chord(:fs3, 'm'), 8], [chord(:D3, :M), 8], [chord(:E3, :M)     chord(:Cs3, :m), 16]
  bass_note = (ring
               :D1,:D1,:E1,:Fs1, :Cs1, :Cs1,:D1,:Cs1,  :B0,:B0,:Cs1,:A0,
               :gs0,:gs0,:B0,:Fs0, :Fs0,:Fs0,:A0,:B0,  :Cs1,:Cs1,:E1,:E1, :E1,:Cs1,:B0,:B0).tick(:b)
  puts note_inspect(bass_note)
  with_fx :lpf, cutoff: 50*2, mix_slide: 0.5, mix: 1.0 do |lpf_fx|
    (bass_note == :Fs0 || bass_note == :Fs1) ? control(lpf_fx, mix: 0.0) : control(lpf_fx, mix: 1.0)
    with_fx :distortion, mix: 0.8 do
      with_fx :reverb, decay: 8.0 do
        with_transpose -12 do
          #synth :chiplead, note: bass_note+0.0, amp: 0.2*1, decay: 0.5
          synth :chipbass, note: bass_note+0.0, amp: 0.5*1, decay: 0.5
        end
        with_transpose 12*1 do
          synth :gpa, wave: 4, note: bass_note, amp: 1, decay: 0.125
          synth :growl, note: bass_note, attack: 0.001, amp: 0.6*1, decay: 0.25
        end
      end
    end
  end
  
  with_fx :slicer, phase: 1.0, mix: 0.0 do
    with_fx :lpf, cutoff: 100, mix: 0.0 do
      with_fx :distortion, mix: 0.0 do
        s = (knit
             [:Fs4,0.125],6, [:D4,0.125], 2, [:Fs4,0.125],4 #[:Fs2, 0.125], [:D2,0.25], [:D2,0.125], [:D3,0.125], [:D3,0.125],
             # [:D2,0.125], [:D2, 0.125], [:D3,0.125], [:D3,0.125], [:D2,0.125], [:D2,0.125],
             # [:E2,0.125], [:E2, 0.125], [:E3,0.125], [:E3,0.125], [:E2,0.125], [:E2,0.125],
             #:D4, :D4,  :E4, :E2, :E3, :E3,
             # :E4, :E4, :E4, :E4, :E4, :E4
             )
        if spread(1,8).look
          sample Corrupt[/kick/,7], amp: 1*1
        else
          sample Corrupt[/kick/,7], cutoff: 90, amp: 1.2
        end
        sy = :plucked
        sample Fraz[/coil/,/c#/,[0,0]].tick(:sample), cutoff: 130, amp: 0.3, start: 0.2, finish: 0.15
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
        #synth :gpa, note: s.tick[0], wave: 1, release: s.look[-1], attack: 0.001, amp: 4
        sleep 1/4.0
        #synth :chiplead, note: :Fs1, cutoff: 60,amp: 0.1
        sample Corrupt[/GuitarThud/].tick(:hitit), amp: 0.5#, cutoff: 40
        #synth :gpa, note: s.tick[0], wave: 1, release: s.look[-1], attack: 0.001, amp: 4
        sleep 1/4.0
        #synth :gpa, note: s.tick, wave: 4, release: 0.125, attack: 0.001
        sleep 1/4.0
        sample Corrupt[/snare/,0], amp: 0.2#, cutoff: 40
        #sample Corrupt[/hit/,9], amp: 0.8 if spread(1,32).look
        #        synth :gpa, note: s.tick[0], wave: 0, release: s.look[-1], attack: 0.001, amp: 1
        sleep 1/4.0
        #       synth :gpa, note: s.tick[0], wave: 0, release: s.look[-1], attack: 0.001, amp: 1
        sleep 1/4.0
        #synth :chiplead, note: :Fs1, cutoff: 65,amp: 0.2
        sample Corrupt[/GuitarThud/,0], amp: 0.8#, cutoff: 40
        #    synth :gpa, note: s.tick[0], wave: 0, release: s.look[-1], attack: 0.001, amp: 1
        sleep 1/4.0
        #  synth :gpa, note: s.tick[0], wave: 0, release: s.look[-1], attack: 0.001, amp: 1
        sleep 1/4.0
      end
    end
  end
end
