["experiments", "drums"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}"}
bar = 4.0
live_loop(:drum_timing_loop, auto_cue: false){ 
  sync :next
density(2){ 16.times{ cue :drum_hit; sleep (bar/16.0)}}}

with_fx :level, amp: 1.0 do
with_fx :bitcrusher, sample_rate: 44000, mix: 0.1, bits: 12 do
with_fx :pitch_shift, mix: 0.5 do
with_fx :hpf, mix: 0.0 do
with_fx :lpf, cutoff: 70, mix: 0.0 do
                                    #1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8
drum_loop(:highli, (ring *%w{- - - x x - - - - - - - - - - -    - - - r r - - - - - - - - - - -    -*16                               -*16                           }),  Ether[/noise/i,11],     amp: 0.2, start: 0.0, rate: (knit 1.0,64,1.1,64))
drum_loop(:kick,   (ring *%w{r - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -}),  Mountain[/impact/i,9],  amp: 0.0, rate: rrand(0.9,1.0))
drum_loop(:kick2,  (ring *%w{x x - - - - - - x - - - - - - -    x - - - - - - - x - - - - - - -    x - - - - - - - x - - - - - - -    x - - - - - - - x - - - - - - -}),  Mountain[/subkick/i,0], amp: (ring 0.5,0.2), start: (knit 0.01,1, 0.03,31), rate: pitch_to_ratio(note(:Fs1) - note(:E1)) )
drum_loop(:snare,  (ring *%w{- - - - - - - - x - - - - - - -    - - - - - - - - x - - - - - - -    - - - - - - - - x - - - - - - -    - - - - - - - - x - - - - - - -}),  Ambi[/clap/,13],        amp: 0.2, delta: 0.001, start: 0.0, rate: 1.0)
drum_loop(:snare2, (ring *%w{- - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -    - - - - - - - - x - - - - - - -    - - - - - - - - - - - - - - - -}),  Ambi[/clap/,17],        amp: 0.2, delta: 0.002, start: 0.0, rate: 1.0)
drum_loop(:clap,   (ring *%w{- - - - - - - - x - - - - - - -    - - - - - - - - x - - - x - - -}),                                                                        Ether[/noise/i,5],      amp: 0.2, start: 0.0, rate: 1.0)
drum_loop(:cchat,  (ring *%w{x - - x - - x - - x - - - - - -    - - x - - - x - x - x - - - - -    - - x - - - x - x - x - - - - -    x - - x - - x - - x - - x x - -}),  Ether[/click/i].shuffle.tick, amp: 1.0*rrand(0.5,0.3), rate: (knit 1.01,3,-1.1,2,-1.2,3), start: rrand(0.0,0.00001))
                                                                                                                                                                          with_fx(:reverb, mix: 0.3){with_fx(:slicer, phase: 0.025, probability: 0.5){
drum_loop(:ochat,  (ring *%w{- - - - x - - - - - - - x - - - }),                                                                                                          Down[/hat/i, [17, 16,15]], amp: 1.0);}}
drum_loop(:cymbal, (ring *%w{- - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -     - - - - - - - - - - - - - - - r}), Ether[/noise/i,7],  amp: 0.2)  
drum_loop(:swipe,  (ring *%w{- - - - - - - - - - - - x - - -    - - - - - - - - - - - - - - - -    - - - - - - - - - - - - x - - -    - - - - - - - - - - - - - - r -}),  Ether[/snare/i,12], delta: 0.01, amp: 1.0*(knit 0.5,24, 1.9,8).tick(:amp), start: 0.0, rate: (knit -0.8,16, -1.5,16).tick(:rate))
drum_loop(:fast,   (ring *%w{- - - - - - x - x - x - - - - - }), Ether[/click/i,20], amp: 0.0, rate: (knit -1.0, 2, 1.0,2))
end;end;end;end;end


## Extract bang -> drum_loop
def ring_gen(n, fn)
  (ring *((0..n).map{fn.()}))
end

with_fx(:level, amp: 0.5) do
                           #1 2 3 4 5 6 7 8
drum_loop(:bang,  (ring *%w{x - - - - - - -  -*8 -*8 -*8}), Mountain["subkick",4], amp: ring_gen(32, lambda{1.0 + rrand(0.0,0.2)}), 
                                                                                   rate: ring_gen(32, lambda{rrand(0.9,1.0)}))
                           #1 2 3 4 5 6 7 8
drum_loop(:bang2, (ring *%w{-*8 -*8
                            x - - - - - - -   -*8}), Mountain["subkick",0], amp: ring_gen(32, lambda{1.0 + rrand(0.0,0.2)}), 
                                                                           rate: ring_gen(32, lambda{rrand(0.9,1.0)}))
end