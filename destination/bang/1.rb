set_volume! 1.0

use_bpm 60

set_mixer_control! hpf: 40, lpf: 60,  lpf_slide: 16, hpf_slide: 16

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
  with_fx :slicer, phase: 2.0, invert_wave: 1, wave: 1, smooth: 0.2  do
    sample ChillD[/drum_loop/, 10], beat_stretch: 8.0, amp: 2.0
  end

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
  sample Corrupt[/kick/,[1,1]].tick(:sample), cutoff: 120, amp: 1.8
  #  sample Corrupt[/drum_loop/,10], beat_stretch: 2.0

  # sync :kick
  #sample Fraz[/loop/, 3], beat_stretch: 8.0, amp: 1.0
  #  sample Fraz[/loop/, 3], beat_stretch: 2.0, amp: 2.0
  #  sample Corrupt[/loop/,8], beat_stretch: 4.0
  #sample Corrupt[/loop/,8], beat_stretch: 2.0

  sleep 2
  #with_fx(:slicer, phase: 0.25*2, probability: 0) do
  sample Corrupt[/drum_loop/,10], beat_stretch: 8.0
  sample Corrupt[/drum_loop/,10], beat_stretch: 16.0

  #end
  sample Corrupt[/kick/,[1,1]].tick(:sample), cutoff: rrand(80,100), amp: 1.8

  # sample Fraz[/loop/, 3], beat_stretch: 2.0, amp: 1.0
  sleep 2
end

live_loop :dark do
  #use_synth :dark_sea_horn
  #  play :fs3, decay: 0.01, attack: 0.001, amp: 1.0, cutoff: 70, attack: 0.001
  #sample Organ[/g#0/,0], amp: 4.0

  #  with_fx :krush do
  with_fx(:slicer, phase: 0.25*2, wave: 0, amp: 8.0) do
    sample Organ[/f#0/,0], amp: 2.0
  end

  with_fx(:slicer, phase: 0.25*4, invert_wave: 1.0, wave: 0, amp: 8.0) do
    sample Organ[/f#1/,0], amp: 2.0
  end

  #sample Corrupt[/acoustic guitar/, /f#m/], amp: 4.0

  #  with_fx :krush, pre_amp: 0.5 do
  #  with_fx(:slicer, phase: 0.25, wave: 1, amp: 8.0) do
  sample Organ[/a3/,0], amp: 2.0
  sample Organ[/c#3_/,0], amp: 2.0
  #    sample Organ[/_b3_/,0], amp: 4.0
  #  end
  # end

  with_fx(:slicer, phase: 0.25*2, wave: 0, amp: 8.0) do
    #   sample Organ[/c#2/,0], amp: 4.0
  end
  # end

  sleep 8
end

live_loop :break do
  #sample Corrupt[/f#/,[0,0]].tick(:sample), cutoff: 130, amp: 1.0
  sleep 8
end

live_loop :nextlevel do
  sleep 16
  #sample Fraz[/kick/, 0], amp: 4.0
  #sample Fraz[/coil/, /c#m/, 0], rate: 1.0, amp: 1.0, cutoff: 80
  sleep 16
end

live_loop :apeg, auto_cue: false do
  #sync :next
  #with_fx :reverb, room: 1, reps: 4 do |fx|
  use_synth :plucked
  use_random_seed (knit 100,4, 300,4).tick
  ns = (scale :fs3, :minor, num_octaves: 4).drop(0).take(3)
  #sample Dust[/kick/, 0], amp: 1.0
  #    with_fx :krush, mix: 0.1, distort: 0.4 do
  _=nil
  16.times do
    #sample Ether[/noise/, 4..8].tick(:sample), cutoff: 130, amp: 4.0 if spread(3,8).tick
    #sample Ether[/snare/, [4,4]].tick(:sample), cutoff: 130, amp: 1.0 if spread(7,11).look

    play (knit :fs3,4,_,4).tick(:gjhf)

    with_transpose((knit 0,0,12,1).tick(:r)) do
      play (knit ns.choose,1, _,0).tick(:notes), blip_rate: 10.9,
        delay_coef: 0.01, delay_time: 0.01, room: 200.0, attack: 0.0001, amp: 0.5, cutoff: 100
    end
    #control fx, damp: rand, mix: rand
    sleep 0.125*(ring 1,1).tick(:s)
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
        release: 0.1, amp: 4.0, attack: 0.001, detune: 12,
        cutoff: 75
    end
    sleep 0.25
  }

end
