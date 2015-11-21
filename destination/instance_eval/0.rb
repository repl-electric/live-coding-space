["samples","instruments","experiments", "log", "shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil

with_fx(:reverb, room: 0.8, mix: 0.9, damp: 0.5) do |r_fx|
  live_loop :warm_up do
    #    sample Corrupt[/acoustic guitar/, /fx/].tick, cutoff: 75, amp: 1.5, beat_stretch: 8.0
    #sync :organ

    with_fx(:slicer, phase: 0.25*1, probability: 0) do
      with_synth :dark_sea_horn do
        play :e3, cutoff: 50, decay: 8.1, amp: 1.0
      end
    end

    sleep 8
  end
end
shader :iWave, 0.5
#--Log of activity---------------------------------------->

#The code here creates and controls the sounds you are hearing.

live_loop :Matz do
  with_fx :reverb, room: 1.0 do
    with_fx(:pitch_shift, mix: 0.8, window_size: 0.1, pitch_dis: 0.05) do
      with_fx(:flanger, feedback: 0.8, decay: 0.5, mix: 0.4) do |r_fx|
        sample Words[/guy/,0], amp: 2.0
      end
    end
  end
  sleep 32
end

live_loop :heart do
  sync :organ
  #New samples to play with...
  with_fx(:krush, mix: 0.1) do |r_fx|
    #sample Organic[/kick/,2], cutoff: 80, amp: 1.0
  end

  #  with_fx :slicer, phase: 2.0 do
  #sample ChillD[/drum_loop/,10], cutoff: 135, amp: 1.5, beat_stretch: 8.0
  # end
  #sample Organic[/drum_loops/,0],amp: 1.0



  #sample Dust[/f#m/,1], cutoff: 60, amp: 0.8, beat_stretch: 8.0
  #  sleep 2

  #New set of samples.... no idea what we will find in here.....
  sleep 8
end

live_loop :perc do
  with_fx(:krush, mix: 0.1) do |r_fx|
    with_fx(:slicer, phase: 0.25, probability: 0, mix: 0.0) do
      sample Organic[/loop/,/perc/, 2], cutoff: 75,
        beat_stretch: 16.0, amp: 1.5
    end
  end
  sleep 16
end

live_loop :apeg do
  use_synth :plucked
  with_synth :hollow do
    play :cs2
  end
  play (ring :Fs3,_, :Gs3,:gs3, _,
        :Fs3,_, :Gs3,:gs3, _,
        :Fs3,_, :Gs3,:gs3, _,
        :Gs3,_, :Gs3,:b3, _,

        :Gs3,_, :B3,:B3, _,
        :Gs3,_, :B3,:B3, _,
        :Gs3,_, :B3,:B3, _,
        :Gs3,_, :B3,:cs4, _).tick, decay: rand, amp: 0.0
  sleep (ring 0.25).tick(:l)
end

live_loop :breath do
  with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
    #  sync :organ
    sleep 16+4
    #sample Fraz[/coil/,/c#/,0], cutoff: 70, amp: 0.9, rate: 0.5
    sleep 16-4
  end
end


live_loop :fx do
  sync :organ
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    synth :dsaw, note: :Fs1, cutoff: 40, amp: 0.1, decay: 16, detune: 12
    synth :prophet, note: :Fs1, cutoff: 40, amp: 0.1, decay: 16, detune: 12
  end

  #sample Organic[/f#/,/strings/,0], amp: 0.5
  sleep 32
end

live_loop :sop do
  sync :organ
  sleep 16
  if spread(1,4).tick(:sop)
    with_fx(:echo, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
      sample Sop[/eh/,/release/, 3..4].tick(:sop), amp: 1.0, cutoff: 100
    end
  end
  sleep 16
end


#This is the Leeds organ. Its lovely...
live_loop :organ do
  synth :hollow, note: :e3, attack: 1.0, decay: 4.0, amp: 2.0
  slices = [1,2,4].shuffle
  notes = [[/f#2/, /a2/, /c#2/],
           [/a2/, /c#2/, /_e2_/],
           [/c#2/, /_e2_/, /g#2/]].choose

  #notes = [/f#2/, /b2/, /cs2/]

  sample Organ[/f#0/,[0,0]].tick(:sample), cutoff: 100, amp: 2.5
  with_fx(:slicer, phase: 0.25*slices[0], probability: 0) do
    sample Organ[notes[0],[0,0]].tick(:sample), cutoff: 100, amp: 3.5
  end

  with_fx :echo, phase: 0.25*2 do
    #sample Instruments[/violin/, /fs4_1|a4_1|cs4_1/].tick, amp: 1, attack: 0.5
  end

  synth :dark_ambience, note: :e3, decay: 8.0, amp: 2.5, attack: 0.001

  with_fx :slicer, mix: [0.0,0.2].choose do
    with_fx :echo, decay: 8.0 do
      with_fx(:distortion, mix: 0.1, distort: 0.4) do |r_fx|
        with_fx :reverb, room: 1.0 do
          sample Instruments[/cello/, /pianissimo_arco/, /fs2_1|a2_1|cs2_1/].tick, amp: 8
        end
      end
    end
  end

  with_fx(:echo, phase: 0.25*2, decay: 8.0) do
    sample Organic[/kick/,4], amp: 3.0
    #sample Organic[/kick/,4], amp: 2.0, rate

    #sample Instruments[/violin/, /fs4/].tick(:oboe), amp: 1

    #sample Instruments[/double-bass/, /fs1/].tick(:oboe), amp: 1

    #   sample Instruments[/oboe/, /fs5/].tick(:oboe), amp: 1
    #    sample Instruments[/oboe/, /fs6/].tick(:oboe), amp: 1

  end

  with_fx(:slicer, phase: 0.25*slices[1], probability: 0) do
    sample Organ[notes[1],[0,0]].tick(:sample), cutoff: 100, amp: 3.0
  end

  with_fx(:slicer, phase: 0.25*slices[2], probability: 0) do
    sample Organ[notes[2],[0,0]].tick(:sample), cutoff: 100, amp: 2.9
  end

  sleep 8
end


uncomment do
  live_loop :looper do
    sync :organ

    sample ChillD[/drum_loop/, 10], beat_stretch: 8.0, amp: 0.8, cutoff: 90
    sample Frag[/kick/,0], amp: 0.5
    sleep 1.0
    sample Frag[/kick/,1], amp: 0.5

    sleep 2.0
    sleep 1.0
    sample Frag[/kick/,0], amp: 0.5
    sleep 2.0
    sample Frag[/kick/,1], amp: 0.5
    sleep 8-6
  end

  live_loop :hat do
    sleep 0.25/2.0
    #sample Frag[/hat/,0], amp: 1.0, cutoff: rrand(80,100)
  end

  live_loop :clapper do
    #sync :looper
    6.times{
      sleep 1
      #      sample Ambi[/clap/,3], amp: 1.0

    }
    sleep 2

  end
end

set_volume! 0.2
use_bpm 60

set_mixer_control! hpf: 10, lpf: 50,  lpf_slide: 16, hpf_slide: 16, lpf_bypass: 1, hfp_bypass: 1

with_fx(:reverb, room: 1.0, mix: 0.9, damp: 0.5) do |r_fx|

  live_loop :start do
    sample Corrupt[/instrument fx/,[3,4]].tick(:sample), cutoff: (ramp *(50..70), 5).tick(:start), amp: 1.0
    sleep 4
  end
end

live_loop :other do
  #  sample ChillD[/.*_loop/, 10], amp: 1.0
  #sample Dust[/f#m/,1]
  #sample Dust[/f#m/,2], amp: 8.0
  #sample Dust[/f#m/,0], amp: 8.0
  sleep 16
end

live_loop :kickit do
  # sync :beat
  #with_fx(:krush, pre_amp: 10) do |r_fx|
  #with_fx :slicer, phase: 2.0, invert_wave: 1, wave: 1, smooth: 0.2  do
  #sample ChillD[/drum_loop/, 10], beat_stretch: 8.0, amp: 1.0, cutoff: 75
  #end

  #end
  #sample Dust[/f#m/,1], beat_stretch: 8.0, amp: 2.0

  #sample Corrupt[/loop/,8], amp: 8.0, beat_stretch: 8.0, pan: 0.25
  #sample Corrupt[/loop/,8], amp: 8.0, beat_stretch: 8.0, pan: -0.25

  with_fx(:echo, decay: 8.0, phase: (ring 1.0,2.0).tick(:phase)) do |r_fx|
    #sample Dust[/f#m/,/whale/].tick(:s),  amp: 2.0, cutoff: 100
  end


  with_fx(:slicer, phase: 0.25, probability: 0, wave: 1) do
    # sample Dust[/f#m/,1], beat_stretch: 8.0, amp: 2.0
  end
  sleep 8.0
end

live_loop :next do
  # sample Corrupt[/kick/,[1,1]].tick(:sample), cutoff: 120, amp: 1.2
  #sample Corrupt[/drum_loop/,10], beat_stretch: 2.0

  # sync :kick
  #sample Fraz[/loop/, 3], beat_stretch: 8.0, amp: 1.0
  #  sample Fraz[/loop/, 3], beat_stretch: 2.0, amp: 2.0
  #sample Corrupt[/loop/,8], beat_stretch: 4.0
  #sample Corrupt[/loop/,8], beat_stretch: 2.0

  sleep 2
  with_fx(:slicer, phase: 0.25*2, probability: 0) do
    # sample Corrupt[/drum_loop/,10], beat_stretch: 8.0
    #sample Corrupt[/drum_loop/,10], beat_stretch: 16.0
  end
  #sample Corrupt[/kick/,[1,1]].tick(:sample), cutoff: rrand(80,90), amp: 1.2

  # sample Fraz[/loop/, 3], beat_stretch: 2.0, amp: 1.0
  sleep 2
end

live_loop :dark do
  stop
  with_fx :lpf, cutoff: 80 do
    use_synth :dark_sea_horn
    #   play :fs3, decay: 0.01, attack: 0.001, amp: 1.5, cutoff: 70, attack: 0.001
    #    sample Organ[/g#0/,0], amp: 3.0

    #  with_fx :krush do
    with_fx(:slicer, phase: 0.25*2, wave: 0, amp: 8.0) do
      #    sample Organ[/_f#0_/,0], amp: 2.0

      #   sample Organ[/_f#1_/,0], amp: 2.0
    end

    with_fx(:slicer, phase: 0.25*4, invert_wave: 1.0, wave: 0, amp: 8.0) do
      #  sample Organ[/_f#2_/,0], amp: 2.0

      #      sample Organ[/_a1_/,0], amp: 2.0
    end

    #sample Corrupt[/acoustic guitar/, /f#/], amp: 9.0

    #sample Organ[/_a1_/,0], amp: 1.0

    with_fx(:slicer, phase: 0.25*2, wave: 0, amp: 8.0) do
      # sample Organ[/_c#2_/,0], amp: 2.0
      # sample Organ[/_a1_/,2], amp: 2.0
    end
    # end

    with_fx(:slicer, phase: 0.25*2, wave: 0, amp: 8.0,invert_wave: 1) do
      #      sample Organ[/_g#2_/,0], amp: 2.0
      #sample Organ[/_a1_/,0], amp: 2.0
    end



    sleep 8
  end
end

live_loop :break do
  #sample Corrupt[/f#/,[0,0]].tick(:sample), cutoff: 130, amp: 1.0
  sleep 8
end

live_loop :nextlevel do
  stop
  sleep 16
  #sample Fraz[/kick/, 0], amp: 4.0
  sample Fraz[/coil/, /c#m/, 0], rate: 1.0, amp: 1.0, cutoff: 80
  sleep 16
end

live_loop :apeg, auto_cue: false do
  stop
  #sync :next
  #with_fx :reverb, room: 1, reps: 4 do |fx|
  use_synth :plucked
  use_random_seed (knit 100,4, 300,4).tick
  ns = (scale :fs3, :minor_pentatonic, num_octaves: 4).drop(0).take(4)
  #sample Dust[/kick/, 0], amp: 1.0
  #    with_fx :krush, mix: 0.1, distort: 0.4 do
  _=nil
  16.times do
    #sample Ether[/noise/, 4..8].tick(:sample), cutoff: 130, amp: 4.0 if spread(3,8).tick
    #sample Ether[/snare/, [4,4]].tick(:sample), cutoff: 130, amp: 1.0 if spread(7,11).look

    play (knit :fs3,4,_,4).tick(:gjhf), amp: 0.0

    with_transpose((knit 12,1).tick(:r)) do
      play (knit ns.choose,1, _,0).tick(:notes), blip_rate: 400.9,
        delay_coef: 0.1, delay_time: 0.1, room: 100.0, attack: 0.0001, amp: 0.0, cutoff: 135
    end
    #control fx, damp: rand, mix: rand
    sleep 0.125*(ring 1).tick(:s)
    # end
  end
  #  end
end
_=nil
live_loop :bass do
  sync :kick
  32.times{
    with_synth :prophet do
      #      play (ring
      #            :fs1, _, :Fs1, _, :Fs1, :fs1, :FS1,:fs1,

      #           :fs5, :Fs5, :Fs1, _, :Fs1, _, :FS1, _,
      play  (knit :fs2,1,:a2,7,  _,(32-4)*0).tick(:zass),
        #      ).tick(:zass),
        decay: (ring 0.1,0.25,0.1,0.1).tick(:j),
        release: 0.1, amp: 0.5, attack: 0.001, detune: 12,
        cutoff: 75
    end
    sleep 0.25
  }

end
