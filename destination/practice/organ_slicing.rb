  set_volume! 0.1

use_bpm 60

live_loop :other do
  #  sample ChillD[/.*_loop/, 10]
  sleep 16
end

live_loop :kickit do
  # sync :beat
  sample ChillD[/drum_loop/, 10], beat_stretch: 8.0
  sleep 8.0
end

live_loop :next do
  sample Corrupt[/kick/,[1,1]].tick(:sample), cutoff: 120, amp: 1.8
  sample Corrupt[/drum_loop/,10], beat_stretch: 2.0

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
  play :fs3, decay: 0.01, attack: 0.001, amp: 1.0, cutoff: 70, attack: 0.001
  #sample Organ[/g#0/,0], amp: 4.0

  #  with_fx :krush do
  with_fx(:slicer, phase: 0.25*2, wave: 0, amp: 8.0) do
    sample Organ[/f#0/,0], amp: 4.0
  end

  with_fx(:slicer, phase: 0.25*2, invert_wave: 1.0, wave: 0, amp: 8.0) do
    sample Organ[/f#1/,0], amp: 4.0
  end

#sample Corrupt[/acoustic guitar/, /f#m/], amp: 4.0

with_fx :krush, pre_amp: 0.5 do
#  with_fx(:slicer, phase: 0.25, wave: 1, amp: 8.0) do
    sample Organ[/a3/,0], amp: 4.0
    sample Organ[/c#3_/,0], amp: 4.0
#    sample Organ[/_b3_/,0], amp: 4.0
#  end
end

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
#  use_random_seed (knit 100,4, 300,4).tick
  ns = (scale :fs3, :minor_pentatonic, num_octaves: 4).drop(0).take(4)
  #sample Dust[/kick/, 0], amp: 1.0
  #    with_fx :krush, mix: 0.1, distort: 0.4 do
  _=nil
  16.times do
    #sample Ether[/noise/, 4..8].tick(:sample), cutoff: 130, amp: 4.0 if spread(3,8).tick
    #sample Ether[/snare/, [4,4]].tick(:sample), cutoff: 130, amp: 1.0 if spread(7,11).look

    with_transpose(12) do
      play (knit ns.choose,1, _,0).tick(:notes), blip_rate: 10.9,
        delay_coef: 0.01, delay_time: 0.01, room: 500.0, attack: 0.0001, amp: 1.0
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

live_loop :onehits do
  stop
  sleep 12.75/4
  with_fx(:flanger, feedback: 0.5) do |r_fx|
    #sample Sink[/_E_/, 3], cutoff: 70, amp: 0.7, attack: 1.0
  end
  #sample Sink[/DWD_128_E_Stand/, 0], cutoff: 100
  #sample Sink[/_E_/, 160]

  #  play :B3, decay: 1.0

  #sample Sink[/Augmented5th_E_Texture_SP01/]
  sustains = [Sop[/vor_sopr_sustain_ee_p_0#{1}/,0],
              Sop[/vor_sopr_sustain_ah_p_0#{3}/,0],
              Sop[/vor_sopr_sustain_mm_p_0#{5}/,0],
              #Sop[/vor_sopr_sustain_eh_p_0#{note}/,0],
              #  Sop[/vor_sopr_sustain_oh_p_0#{note}/,0]
              ]

  with_fx(:echo, decay: 8.0, mix: 1.0, phase: 0.25) do
    sample sustains.choose, amp: 2.0
  end

  with_fx(:reverb, room: 1.0, mix: 1.0, damp: 0.5) do |r_fx|
    #sample Sink[/_E_/, 50], amp: 1.0, cutoff: 100

    note = "4"
    #    with_fx(:krush, room: 0.1) do |r_fx|
    sample sustains.choose, amp: 1.0
    shader :iKick, 4.0
    shader "vertex-settings", "lines", 100
    #   end
    sleep 0.25
    #  with_fx(:bitcrusher, mix: 0.1) do
    shader :iKick, 2.5
    shader "vertex-settings", "lines", 1000

    sample sustains.choose, amp: 1.0
    #  end
    sleep 0.25*2
    shader  :iKick, 2.0
    shader "vertex-settings", "lines", 5000


    with_fx(:echo, decay: 4.0, mix: 1.0, phase: 0.25) do
      sample sustains.choose, amp: 1.5
    end

    sleep 0.25*4
    shader "vertex-settings", "fan", 9000

    shader :iKick, 1.0

    #with_fx(:reverb, room: 1.0, mix: 0.4, damp: 0.5) do |r_fx|
    sample sustains.choose, amp: 1.0
    #end
    #sample Sink[/vor_sopr_sustain_ee_p_06/,0], amp: 8.0
    #sample Sink[/vor_sopr_sustain_ah_p_06/,0], amp: 8.0
    #sample Sink[/vor_sopr_sustain_mm_p_06/,0], amp: 8.0


    #  sample Sink[/vor_sopr_sustain_ee_p_04/,0], amp: 8.0

  end
  sleep 1
  shader :decay, :iKick, 1.0
  shader "vertex-settings", "points", 8000
  sleep (10.25/4)-1
end
