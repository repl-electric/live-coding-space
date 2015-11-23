_=nil
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
  with_fx :slicer, phase: 1.0, invert_wave: 1, wave: 1, smooth: 0.2  do
    #sample ChillD[/drum_loop/, 10], beat_stretch: 8.0, amp: 1.1, cutoff: 80
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
  #sample Frag[/kick/,[1,1]].tick(:sample), cutoff: 50, amp: 1.2
  #sample Corrupt[/drum_loop/,10], beat_stretch: 2.0

  #sample Fraz[/loop/, 3], beat_stretch: 8.0, amp: 1.0
  #sample Fraz[/loop/, 3], beat_stretch: 2.0, amp: 2.0
  #sample Corrupt[/loop/,8], beat_stretch: 4.0
  #sample Corrupt[/loop/,8], beat_stretch: 2.0

  sleep 2
  with_fx(:slicer, phase: 0.25*2, probability: 0) do
    #sample Corrupt[/drum_loop/,10], beat_stretch: 8.0
    #sample Corrupt[/drum_loop/,10], beat_stretch: 16.0
  end

  with_fx (ring :none, :none, :reverb, :none).tick(:fx) do
    #sample Frag[/kick/,[1,1]].tick(:sample), cutoff: rrand(30,40), amp: 1.2
  end

  #sample Corrupt[/kick/,[1,1]].tick(:sample), cutoff: rrand(80,90), amp: 1.2
  #sample Fraz[/loop/, 3], beat_stretch: 2.0, amp: 1.0
  sleep 2
end

live_loop :dark do
  with_fx :lpf, cutoff: 130 , mix: 1.0, cutoff_slide: 10 do
    use_synth :dark_sea_horn
    #play :fs3, decay: 0.01, attack: 0.001, amp: 1.5, cutoff: 70, attack: 0.001
    #sample Organ[/_g#0_/,0], amp: 2.0

    #  with_fx :krush do
    with_fx(:slicer, phase: 0.25*2, wave: 0, amp: 8.0) do
      #sample Organ[/_f#0_/,1], amp: 2.0
      #sample Organ[/_f#1_/,0], amp: 2.0
    end

    with_fx(:slicer, phase: 0.25*4, invert_wave: 1.0, wave: 0, amp: 8.0) do
      #sample Organ[/_c#2_/,0], amp: 2.0

      #sample Organ[/_a2_/,1], amp: 2.0
      #sample Organ[/_a1_/,1], amp: 2.0

      #sample Organ[/_c#0_/,0], amp: 2.0
      #sample Organ[/_a2_/,1], amp: 2.0
    end

    #sample Corrupt[/acoustic guitar/, /f#/], amp: 9.0
    #sample Organ[/_e1_/,0], amp: 2.0

    with_fx(:slicer, phase: 0.25*2, wave: 0, amp: 8.0) do
      #sample Organ[/_f#1_/,1], amp: 2.0
    end
    with_fx :flanger, feedback: 0.5  do
      #sample Organ[/_c#1_/,1], amp: 1.0
    end
    with_fx(:slicer, phase: 0.25*2, wave: 0, amp: 8.0,invert_wave: 1) do
      sample Organ[/_f#2_/,1], amp: 2.0
      #sample Organ[/_e2_/,1], amp: 1.0
      #sample Organ[/_b2_/,0], amp: 1.0
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
