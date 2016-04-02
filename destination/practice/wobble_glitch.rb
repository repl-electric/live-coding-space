use_bpm 60
with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
  live_loop :warming do
    sample Frag[/f#m/,[0,0]].tick(:sample), cutoff: 60, amp: 0.3
    
    synth :dark_ambience, note:
      (ring chord(:A4, :M7), chord(:Cs4, :m11), chord(:As4, :M7), chord(:Fs4, :m11)).tick(:c), decay: 8.0, attack: 2.0, cutoff: 70, amp: 0.7
    shader  :iConstrict, rand
    sleep 8
  end
end


live_loop :bass, sync: :warming do
  synth :dark_sea_horn, note: chord(:Fs1, :m)[0], cutoff: 50, decay: 8.0, amp: 0.2
  shader  :iBeat, rand*1
  #shader :iR, rand*8
  sleep 16
end

live_loop :frag, sync: :warming do
  with_fx :wobble, phase: 8, pulse_width: 8 do
    sample Frag[/coil/,/f#/,8],
      amp: 0.4, beat_stretch: 64
  end
  shader :decay, :iMotion, 0.1, 0.001
  shader :iPointSize, rand
  sleep 12
end

live_loop :percussion, sync: :warming do
  shader :iWave, rand*10
  sleep 0.25
  if spread(7,11).tick(:s)
    #sample Frag[/coil/, /f#/,1], amp: 2.5, start: 0.7, finish: 0.85
  end
  if spread(3,8).tick(:s)
    with_fx :lpf, cutoff: 100 do
      sample Frag[/coil/, /f#/,3], amp: 0.2, start: 0.1, finish: 0.0
    end
  end
  
end

live_loop :kick, sync: :warming do
  #I'm bored of kicks
  sample Frag[/kick/,[0,0]].tick(:sample), cutoff: 60, amp: 0.5
  sample Fraz[/loop/, 1], beat_stretch: 16, amp: 0.3
  
  with_fx (ring :none, :none, :none, :echo).tick(:r) do
    #    sample Frag[/coil/,8], cutoff: 60, amp: 0.1, start: 0.0, finish: 0.1
  end
  with_fx :wobble, phase: (ring 8.0, 4.0).tick(:w), mix: 0.2, wave: 8, cutoff_max: 100, invert_wave: (ring 1,0).tick(:i) do
    sample Frag[/coil/,0], cutoff: 60, amp: 0.1, start: 0.0, finish: 0.1, rpitch: -32
  end
  shader :decay, :iForm , 20.0, 0.025
  sleep 2
  
  sample Frag[/kick/,[0,0]].tick(:sample), cutoff: 60, amp: 0.5
  sleep 2
end
