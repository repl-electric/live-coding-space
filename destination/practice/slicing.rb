shader :shader, "voc.glsl", "bits.vert", "points", 5000
shader :iSpaceLight, 0.4
shader :iStarLight, 0.6
shader :iStarMotion, 0.1
shader :iSpaceLight, 0.4
shader :iStarLight, 0.3
#shader [:iR, :iB, :iG], 3.0
shader :iForm, 1.0
#shader :iDir, 1.0
shader :iMotion, 0.1
#shader :iWave, 0.9
shader :iSize,10.1
shader :iDistort, 100.0
@cells = 10000
live_loop :do, sync: :slept_but do
  #  shader :iPointSize, rand*2.5
  with_fx(:bitcrusher, mix: 0.05, bits: 14, sample_rate: 20000) do
    with_fx :distortion, mix: 0.5 do
      #      shader :vertex_settings,"lines", [@cells+=50,1000].min, 1.0
      puts "cells:#{@cells}"
      shader :decay, :iBeat, 1.2
      with_fx(:slicer, phase: 0.25*4, probability: 0) do
        sample Mountain[/subkick/,[0,0]].tick(:sample), cutoff: 50, amp: 0.2
      end
      if !spread(1,4).look(:s)
        sleep 0.25
        #       sample Fraz[/kick/,[0,0]].tick(:sample), cutoff: 40+rand, amp: 0.5
        sleep 2-0.25
      else
        sleep 2
      end

      #      shader :growing_uniform, :iForm, rrand(0.1,0.5), 0.0001

      if spread(1,4).tick(:s)
        sleep 2-0.25
        #shader :decay, :iDistort, rrand(0.005,0.1), 0.00001
        with_fx :gverb, mix: 0.01 do
          #          sample Fraz[/kick/,[1,1]].tick(:sample), cutoff: 40, amp: 0.5+rand*0.1
        end
        sleep 0.25
      else
        sleep 2
      end
    end

  end
end

live_loop :looping_sea do
  with_fx(:pitch_shift, time_dis: 0.8) do
    sample_and_sleep Mountain[/cracklin/],rate: 0.9, amp: 0.05, cutoff: 100
  end
end

live_loop :perc, sync: :slept_but do
  sleep 0.25*2
  # with_fx(:slicer, phase: 0.25, probability: 0.5) do
  #    with_fx(:reverb, room: 0.9, mix: 0.9, damp: 0.5) do |r_fx|
  #    sample Dust[/hat/,0..6].tick(:sample), cutoff: 80, amp: 0.5
  #   end

  #end
end

live_loop :slept_but do

  with_fx(:reverb, room: 0.5, mix: 1.0, damp: 0.5) do |r_fx|

    data = (ring
            (chord :FS3, :m), #FAC
            (chord :D3, :M),  #DFA
            (chord :E3, :M),
            )

    bass = (ring
            :Fs3, :E2, :A3, :E3).tick(:bass)

    c = data.tick(:main)
    puts "Chord:#{note_inspect(c)}"
    #shader :iSize, (rand*100)+100

    with_fx(:reverb, room: 0.8, mix: 0.9, damp: 0.5) do |r_fx|
      #sample Mountain[/bow/, ring(/F#/, /C#/).tick(:bow)], cutoff: 65, amp: 0.1
    end

    with_transpose -24 do
      with_fx(:slicer, phase: 0.25*4, smooth: 0.4, probability: 0, wave: 0) do
        synth :dark_sea_horn,
          note: c[0], decay: 4.0, cutoff: 70, amp: 0.35
      end

      with_transpose -12 do
        with_fx(:slicer, phase: 0.25*4, smooth: 0.4, probability: 0, invert_wave: 1, wave: 0) do
          synth :dark_sea_horn,
            note: c[0], decay: 4.0, cutoff: 70, amp: 0.35
        end
      end
    end

    with_transpose 0 do
      with_fx(:reverb, room: 0.8, mix: 1.0, damp: 0.5) do |r_fx|
        at do
          sleep 4
          #Look to the next chord. Anticipation
          synth :hollow, note: c[0], decay: 4.5, attack: 2.0, amp: 0.0
          # synth :dark_ambience, note: data.look(:main, offset: 1)[0], decay: 4.5, attack: 2.0, amp: 0.05
        end
      end
    end

    with_fx(:reverb, room: 0.8, mix: 0.4, damp: 0.5) do |r_fx|
      with_transpose -12 do
        #  synth :prophet, note:  c[0], cutoff: 60, amp: 0.25, decay: 4.0
        #  synth :dsaw, note: c[0], cutoff: 55, amp: 0.25, decay: 4.0
      end
    end
    shader :iHorse, c[0]

    with_fx(:slicer, phase: 0.25*4, probability: 0, wave: 0, smooth: 0.1) do
      #     synth :dark_sea_horn, note: c[1], decay: 4.0, cutoff: 65, amp: 0.1, noise1: 0.1

    end
    sleep 1

    with_fx(:slicer, phase: 0.25*2, probability: 0, wave: 0, smooth: 0.1, invert_wave: 1) do
      #      synth :dark_sea_horn, note: c[2], decay: 8.0, cutoff: 60, amp: 0.1
    end
    sleep 1
    #  synth :dark_sea_horn, note: c[0], decay: 8.0, cutoff: 60, amp: 0.1

    if c.length > 3
      #      synth :dark_sea_horn, note: c[-1], decay: 4.0, cutoff: 60, amp: 0.1
    end

    sample Corrupt[/instrument/,/fx/,/f#/,[0,0,0,1]].tick(:sample), cutoff: 60, amp: 0.05
    #sample Fraz[/interference/,/f#m/,[2,2]].tick(:sample), cutoff: 60, amp: 0.01, beat_stretch: 16
    6.times{sleep 1; control r_fx, damp: rand}
  end
end
