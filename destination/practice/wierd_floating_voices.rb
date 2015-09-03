use_bpm 90

_=nil
live_loop :chords do
  with_synth(:dark_ambience){
    play (ring 
          chord(:Fs3, "M"),
          chord(:As3,  "M", invert: 0),
          chord(:Ds3,  "m"), 
          chord(:Cs3, rand(6) > 3 ? "7" : "M"), ).tick(:chords) , release: 10, attack: 4.0, detune1: (knit 5,3,12,1).tick(:d1), detune2: (knit 10,3,24,1).tick(:d2), amp: 8.0, 
    cutoff: 80
  }
  sleep 8.0
end

live_loop :drums do
  sync :chords
  2.times{sample (ring Dust[/kick/,5], Dust[/kick/,5]).tick, cutoff: (ring 130,100).tick(:c), amp: 2.0; sleep 8.0/2.0}
end

live_loop :voices do
  sync :chords
  sample_and_sleep Dust[/f#/,5], rate: 0.5
  sample_and_sleep Dust[/f#/,4]
end

live_loop :voice2 do
  sync :chords
  sample_and_sleep Dust[/f#/,7], cutoff: rand_i(120)
end

live_loop :voices do
  sync :chords
   4.times{                                                  
    sample Dust[/hat/,(ring 0,0,1,1)].tick
    sleep 8.0/4.0
   }
  #sample_and_sleep Dust[/f#/,4]
end

live_loop :growler do
  sync :chords
  synth :growl, note: (ring :Fs2, :Fs2, :Ds2, :Cs2).tick(:bass), release: 8.0
end
