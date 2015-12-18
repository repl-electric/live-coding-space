["samples","instruments","experiments", "log", "shaderview"].each{|f| load"/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil


shader :shader, "voc.glsl", "bits.vert", "points", 15000
shader :iMotion, 0.011
shader :iStarLight, 0.1
shader :iSpaceMotion, 0.0

live_loop :percussion do
  #  sync :warmup
  #  sample Abstract[/perc/,/loop/,[1,1]].tick(:sample), cutoff: 75, amp: 0.5, beat_stretch: 16
  sleep 16
end

live_loop :shats do
  #  sync :warmup
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    #    sample Frag[/hat/,0..16].tick(:sample), cutoff: 60, amp: 0.8
  end
  sleep 0.25
end

live_loop :main do
  with_fx(:reverb, room: 0.8, mix: 0.4, damp: 0.5) do |r_fx|
    with_fx(:echo, decay: 8.0, mix: 0.3, phase: 0.25) do
      shader :decay, :iMotion, rrand(0.01,0.1)
      #sample Instruments[/double-bass/,/_1_/, ring(/Cs3/, /Fs3/)].tick(:2sample), cutoff: 100, amp: 1.0
      # sample Instruments[/double-bass/,/_1_/, ring(/Cs3/, /Fs3/).tick(:oboe)].tick(:sample), cutoff: 100, amp: 1.0
    end
  end

  chord_notes = ring(
    #                 chord(:FS3, :sus4),

    #                chord(:D3, :major),
    #               chord(:D3, :major7),
    #              chord(:E3, :major),

    chord(:FS3, :m),
    #chord(:B3, :M),

    chord(:Cs3, :m),
    chord(:Gs3, :m),
    chord(:Cs3, :minor7)
  ).tick
  with_synth :leadsaw do
    play chord_notes, cutoff: 130, decay: 8.0, amp: 6.0
  end
  with_synth :dsaw do
    play chord_notes, cutoff: 80, decay: 8.0, amp: 0.2, detune: 12
  end

  at do
    with_transpose 12 do
      with_synth :dark_sea_horn do
        8.times{
          play ring(
            chord_notes[-1]+ring( 5,3,0).tick(:fifth),_,chord_notes[-2],
          chord_notes[-1], chord_notes[-1] ).tick(:d), cutoff: 130, decay: 1.0, amp: 0.7, noise1: 0, noise1: 2
        sleep 0.5}
      end
    end
  end


  with_transpose(12) do
    with_synth :leadsaw do
      #       play chord_notes[-1], cutoff: 100, decay: 8.0, amp: 0.3
    end
  end

  with_transpose(-12) do
    with_synth :leadsaw do
      #   play :Fs2, cutoff: 135, decay: 8.1, amp: 0.5,
    end
  end

  sleep 8
end


live_loop :everything_is_better_with_sop do
  #  sync :warmup
  with_fx(:bitcrusher, mix: 0.1) do
    with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
      with_fx(:echo, decay: 8, mix: 1.0, phase: 1) do
        #        sample Sop[/release/,/ye/,[3,4]].tick(:sample), cutoff: 80, amp: 0.4
      end
    end

  end
  sleep 16
end

live_loop :kicker do
  sync :warmup
  shader :decay, :iKick, rand
  #sample Frag[/kick/,[0,0]].tick(:sample), cutoff: 50, amp: 0.5
  sleep 4

end

set_mixer_control! lpf: 10

live_loop :ending_thingey do
  #QUICK FINISH>>>>>
  sample_and_sleep Mountain[/cracklin/,[0,0]].tick(:sample), cutoff: 40, amp: 6.5, rate: 0.1
end

with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5, damp_slide: 0.5) do |r_fx|
  live_loop :warmup do
    #    synth :hollow, note: ring( :E3, :E4).tick(:notes), amp: 0.5, attack: 4.0, decay: 8.0

    with_fx :bpf, centre: :Fs3, mix: 0.0 do
      with_synth :dark_sea_horn do

        with_fx(:echo, phase: 0.25*4, decay: 16) do
          #       sample Organic[/kick/,[0,0]].tick(:sample), cutoff: 80, amp: 1.0
        end

        with_fx(:slicer, phase: 0.25*4, wave:0, probability: 0) do

          #          s2 = play :CS3, cutoff: 65, amp: 0.5, sustain: 4.0, decay: 16.0

        end

        with_fx(:slicer, phase: 0.25, probability: 0) do
          #sample Organ[/_f#3_/,0], cutoff: 80, amp: 3.0
        end

        with_fx(:slicer, phase: 0.25*2, wave: 0, probability: 0, invert_wave: 1.0) do
          #         s2 = play :Fs3, cutoff: 60, amp: 0.5, sustain: 4.0, decay: 16.0
        end

        s= nil
        with_fx(:pitch_shift, pitch_dis: 0.1, window_size: 0.4, amp: 0.2) do
          s = play :CS2, cutoff: 50, amp: 0.1, sustain: 4.0, decay: 12.0, note_slide: 0.01, cutoff_slide: 0.2

        end
        sleep 1
        #This is controling the visuals                                                      #
        shader :iWave, rrand(0.0,0.5), 0.0001
        14.times{
          sleep 1
          control s, note: scale("fs#{[3,3,4].choose}", :minor_pentatonic, num_octaves: 1).shuffle.choose, cutoff: 70
          control r_fx, damp: rand
        }
end;end;end;end
