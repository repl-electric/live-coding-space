["instruments","shaderview","experiments", "log","samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil
set_volume! 0.4
live_loop :meloyd2 do
  sleep 1.125
  synth :dark_ambience, note: (ring :Gs2, _, _, _).tick, amp: 4.0
end

with_fx :reverb do
  live_loop :thing do
    _=nil
    l = (ring
         1.0, 0.5, 0.5, 0.5, 0.5, 1.0, 0.5).tick/4.0   #4.5  1.125
    #l = (ring 1.0, 0.5, 0.5, 1.0, 0.5).tick/4.0
    n = (ring
         :fs3, :Fs3, _,:Fs3, :Cs3, :E4, :E4,
         :fs3, :Fs3, _,:Fs3, :Cs3, :E4,
         :fs3, :Gs3, _,:Fs3, :Cs3, :E4,
         :fs3, :Gs3, _,:Fs3, :Cs3, :fs4,

         :fs3, :E3, _,:Fs3, :Cs3, :E4, :E4,
         :fs3, :E3, _,:Fs3, :Cs3, :E4,
         :fs3, :E3, _,:Fs3, :Cs3, :E4,
         :fs3, :Gs3, _,:Fs3, :Fs4, :fs4,
         ).tick(:note)
    n2 = (ring
          _, _, _,_, _, _,
          _, _, _,_, _, _,
          _, _, _,_, _, _,
          _, _, _,:FS4, _, _,
          ).tick(:note2)
    with_transpose [5,0].choose do
      synth :hollow, note: n2, release: 1.0, amp: 4.0
    end

    with_fx :distortion, mix: 0.1, distort: (range 0.2, 0.4).tick(:r) do
      with_fx :bitcrusher, bits: (range 4,16,1).tick(:b), mix: 0.0 do
        synth :dsaw, note: n, release: l, cutoff: (rrand 95,100)
      end
    end
    synth :tri, note: n, release: l
    synth :gpa, note: n, release: l*2
    sleep l
  end
end

live_loop :voice2, sync: :thing do
  with_fx :slicer, phase: 0.25, wave: 0 do
    synth :dark_sea_horn, note: (ring :Fs2, :E2).tick(:c), decay: 4.5, attack: 0.001, amp: 2.0
  end
  with_fx :slicer, phase: 0.25, invert_wave: 1, wave: 0 do
    synth :dark_sea_horn, note: (ring :Fs1, :E1).look(:c), decay: 4.5, attack: 0.001, amp: 2.0
  end
  sleep 4.5
end

live_loop :boice3, sync: :thing do
  with_transpose 0 do
    use_synth :dull_bell
    # play (knit chord(:Fs3, :m),8, chord(:A3, :M),8, chord(:D3, :M),8, chord(:E3, :M),8).tick, decay: 0.25, amp: 2.0
  end
  sleep 1/2.0
end

live_loop :bass, sync: :thing do
  synth :dsaw, note: (ring :FS1, :A1, :D1, :E1).tick, decay: 0.2, cutoff: 70, attack: 0.001
  sleep 0.25
  with_transpose 12*2 do
    synth :growl, note: (ring :FS1, :A1, :D1, :E1).look, decay: 1.0, cutoff: 60
  end
  sleep (1.125*2)- 0.25
end
live_loop :hats do
  sleep 0.25
  if spread(7,11).tick
    sample Dust[/hat/,[0,0,0,1]].tick(:sample), cutoff: 85, amp: 0.9
  end
  if spread(3,7).look
    sample Dust[/hat/,[1,2]].tick(:sample2), cutoff: 85, amp: 0.9
  end

end

live_loop :beat, sync: :thing do
  sample Frag[/kick/,[1,0]].tick(:sample), cutoff: 100, amp: 1.0
  sleep 1/2.0
  sample Frag[/kick/,[1,0]].tick(:sample), cutoff: 100, amp: 1.0
  sample Ether[/snare/,[0,0]].tick(:sample), cutoff: 100, amp: 1.0
  sleep 1/2.0
end

live_loop :fuzz, sync: :thing do
  synth :dark_sea_horn, note: chord(:FS1, :m), release: 8.0, cutoff: 60
  sleep 8
end
