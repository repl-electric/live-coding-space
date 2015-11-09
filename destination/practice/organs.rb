["instruments","shaderview","experiments", "log"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil

#-------------------Activity log-------------------------------->

shader :shader, "wave.glsl", "bits.vert", "points", 10000
#shader :vertex, "sphere.vert","points", 500
#shader :iColor, 10.0
#shader :iZoom, 0.2
shader :iZoom, 0.9
shader :iStarLight, 1.0
shader :iStar, 2.0
shader :iCells, 1.0

shader :iMotion, 0.02

shader :iDistort, 1000.0

#shader :vertex, "/Users/josephwilk/Workspace/c++/of_v0.8.4_osx_release/apps/myApps/shaderview/bin/data/sphere.vert",
#  :points, 1200

set_volume! 0.5

live_loop :go do
  #sample Ether[/f#/,[0,0]].tick(:sample), cutoff: 60, amp: 0.5
  sleep 8
  #  sample_and_sleep Sink[/f#/].tick
end

shader :iWave, 1.0

#load_snippets "~/.sonic-pi/"

live_loop :fours do
  #  sample Corrupt[/kick/,5]
  with_fx :reverb, room: 0.8, mix: 0.5 do |fx|
    with_fx :slicer, phase: 0.25/2.0 do
      #      sample Corrupt[/hat/,1], cutoff: 120, beat_stretch: 1.0, amp: 2.0
      #     sample Corrupt[/hat/,1], cutoff: 100, beat_stretch: 1.0, amp: 2.0

    end
    2.times{sleep 1;
            #       sample Ether[/hat/,1], cutoff: 100

            control fx, damp: rand}
  end

end

live_loop :tension do
  sleep 2.0/8.0
  #sample Down[/hat/,[0,0,0,0,0,_,1,0]].tick
end

live_loop :beat do
  #sync :synth
  #shader :decay, :iBeat, 4.0, 0.01
  #sample Fraz[/kick/,[0,0]].tick(:sample), cutoff: 50, amp: 2.0
  #  sample Sink[/f#m/].tick, amp: 0.5
  #  with_fx(:slicer, phase: 0.25*2, probability: 0) do
  #  end
  #  with_fx(:slicer, phase: 0.25) do


  # sample Fraz[/kick/,0], rate: 1.0, amp: 1.0, cutoff: 130
  shader :decay, :iKick, 0.5, 0.001

  #with_fx :slicer, phase: (knit 0.25,2, 0.5,2).tick(:p), wave: 0 do
  # sample Corrupt[/Programmed Beats/, 15], beat_stretch: 8.0, cutoff: 135, amp: 1.0

  with_fx :slicer, phase: 0.5 do
    #sample Corrupt[/Programmed Beats/, 15], beat_stretch: 4.0, cutoff: 135, amp: 1.0
  end

  #end
  #with_fx :reverb, room: 0.8, damp: 0.0 do
  #shader "curve-uniform", :iKick, 0.3, 0.001, 0.0000000001

  #  shader :iKick, 0.0

  #end

  #sample Dust[/beats/,9], beat_stretch: 8.0, amp: 0.1
  # end

  #with_fx(:slicer, phase: 0.25*4, probability: 0) do
  #sample Dust[/f#m/,1], cutoff: 130, amp: 0.5
  #end

  #with_fx(:slicer, phase: 0.0, probability: 0) do
  #sample Dust[/am/,0], cutoff: 135, amp: 0.5
  #end

  #with_fx(:echo, decay: 8.0, mix: 1.0, phase: 1.0) do
  # sample Dust[/whale/].tick, cutoff: 50
  #end

  #sample Dust[/f#m/,0], cutoff: 40, amp: 0.5, beat_stretch: 8.0
  sleep 8
end
_=nil

live_loop :super do
  x= nil
  #synth :blade, note: :FS3, decay: 8.0,
  #  cutoff: 65
  with_fx(:slicer, phase: 0.25, probability: 0) do
    with_synth :supersaw do
      #      x = play chord(:Fs3, :m), note_slide: 0.05, cutoff: 65, decay: 8.0
    end
  end
  8.times{
    sleep 1.0;
    # control x, note: chord(:Fs4, :m).choose}
  }
end

set_volume! 2.0

live_loop :onehits do
  sleep 12.75/2
  with_fx(:flanger, feedback: 0.5) do |r_fx|
    #sample Sink[/_E_/, 3], cutoff: 70, amp: 0.7, attack: 1.0
  end
  #sample Sink[/DWD_128_E_Stand/, 0], cutoff: 100
  #sample Sink[/_E_/, 160]

  #sample Sink[/Augmented5th_E_Texture_SP01/]

  with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
    #sample Sink[/_E_/, 50], amp: 1.0, cutoff: 100

    #   sustains = [Sink[/vor_sopr_sustain_ee_p_04/,0], Sink[/vor_sopr_sustain_ah_p_04/,0], Sink[/vor_sopr_sustain_mm_p_04/,0]]
    #sustains = sustains.shuffle

    #    sample sustains[0], amp: 2.0
    #    sleep 0.25
    #    sample sustains[1], amp: 2.0
    #    sleep 0.25
    #    sample sustains[2], amp: 2.0

    #sample Sink[/vor_sopr_sustain_ee_p_06/,0], amp: 8.0
    #sample Sink[/vor_sopr_sustain_ah_p_06/,0], amp: 8.0
    #sample Sink[/vor_sopr_sustain_mm_p_06/,0], amp: 8.0


    #  sample Sink[/vor_sopr_sustain_ee_p_04/,0], amp: 8.0

  end
  sleep 10.25/2
end

live_loop :go do
  use_synth :fm
  play (ring :Fs2).tick(:nptes), amp: 1, decay: 1.0
  sleep 32.0
end

live_loop :vio do
  use_synth :blade
  play (knit :E3, 32, :Cs3,32, :Ds3, 32).tick, wave: 9, attack: 0.01, amp: 0.01
  sleep 0.25;
end

live_loop :bow do
  #sleep 4
  #  with_fx(:distortion, amp: 1.0) do
  #  sample Corrupt[/kalimba/,4], cutoff: 100

  #  sample Corrupt[/HarmoniumRiddim/,3]

  #    sample Corrupt[/kalimba/,ring(/C#/, /F#/, /G#/,
  #                                  /E/, /C#/, /E/,
  #                                  /A/, /F#/, /G#/
  #                                  ).tick, 0]
  #attack: 0.01, attack_level: 0.5


  #              Organ[/c#2/,1], Organ[/a2/,1], Organ[/c#2,1/],
  #              Organ[/f#2/,1], Organ[/d2/,1], Organ[/e3,1/]


  #Organ[/a2/,1],  Organ[/d2/,1], Organ[/e3,1/],

  # end
  sleep 8
end

live_loop :synth do
  use_synth :hollow
  #shader :iConstrict, 1.0
  shader  :iRand, 0.0 + rand*0.1
  with_fx(:reverb, room: 1.0, mix: 0.4, damp: 0.5) do |r_fx|
    notes = (ring
             #        (ring :Fs3, :a3, :Cs3),
             #        (ring :D3, :Fs3, :A3),
             #        (ring :E3, :Gs3, :B3),

             #        chord(:Fs3, 'sus4'),
             #        chord(:Fs3, 'm'),
             #        chord(:D3, :M),

             chord(:fs3, :m),                        #1
             chord(:D3, :M),                         #6
             (ring :E3, :Gs3, :B3),                  #7 M

             chord(:Cs3, :m, invert: 0),              #5    m
             chord(:Cs3, :m, invert: 1),              #5    m
             chord(:A3, :M, invert: -1),                          #5    m

             chord(:A3, :M, invert: 0),              #5    m
             chord(:D3, :M, invert: 0),              #5    m
             #             chord(:B3, :m),              #6
             chord(:E3, :M, invert: 0),                 #7     M


             #             chord(:Fs3, 'm'),          #1


             #(ring :Fs3, :a3, :Cs3)
             ).tick(:chords)

    puts (notes).map{|n| note_info n}
    #(i, iio, III, iv, v, VI, VI

    #   with_fx :krush, amp: 0.5 do
    #      sample Organ[/f#1/,1], amp: 1.0
    #sample Organ[/f#0/,1], amp: 8.0
    #      sample Organ[/c#1/,1], amp: 1.0
    #   end

    sample Organ[/a2/,0], amp: 3.5

    with_fx :slicer, phase: 0.25, wave: 0 do
      sample (ring
              Organ[/a2/,1],  Organ[/d2/,1], Organ[/e3,1/],
              Organ[/c#2/,1], Organ[/a2/,1], Organ[/c#2,1/],
              Organ[/f#2/,1], Organ[/d2/,1], Organ[/e3,1/]
      ).tick(:oooo),
        amp: 3.0
    end

    with_fx :distortion, mix: 0.1 do
      synth :blade, note: notes.last, attack: 1.0, decay: 2.0, cutoff: 50
    end
    with_fx :slicer, phase: 0.25*2 do
      with_transpose(12*2) do
        synth :gpa,
          note: :fs3,
          cutoff: 135, amp: 2.5, decay: rrand(7.0,8.2),
          release: 0.01, sustain: 0.01, detune: 12, wave:2
      end
    end
    with_transpose(12) do
      with_synth :dark_sea_horn do
        #        play notes.first, cutoff: 100, amp: 0.6
      end
    end

    32.times{
      #      with_fx(:slicer, phase: 0.25/2.0, probability: 0.5) do
      #      play notes.tick,
      #     wave: 0, decay: 0.01,
      #    attack: 0.01, sustain: 0.1, amp: 0.5, cutoff: 135
      sleep 0.25
      #     end
    }
  end
end
