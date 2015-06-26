["experiments"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}"}
bar = 4.0
define :pat do |s, p, delta=0, *args|
 sync :s
 case p
   when  "x" #hit
    sleep(delta) if delta != 0
    sample *([s]+args)
   when  "r" #random
    sleep(delta) if delta != 0
    sample *([s]+args) if dice(6) > 3
  end
end

live_loop :beatz, auto_cue: false do
sync :foo
density(2) do
 16.times do
 cue :s
 sleep (bar/16.0)
end;end;end

define :drum_loop do |name, state, sample, *args|
  state = expand_pattern(state)
  live_loop name, auto_cue: false do  
     pat(sample.is_a?(SonicPi::Core::RingVector) ? sample.tick("#{name}_sample".to_sym) : sample, state.tick(name), 
         delta=(args[0][:delta] || 0),
         *[args[0].reduce({}){|a,(k,v)|
     v.is_a?(SonicPi::Core::RingVector) ? a[k]=v.tick("#{name}_#{k}".to_sym) : a[k]=v
     a}])
  end
end

define :expand_pattern do |pat|
  pat.to_a.map{|slice| 
  case slice
  when "-*16"
    ("-"*16).split("")
  else
    slice
  end
  }.flatten.ring
end

#Dance music generic
with_fx :bitcrusher, sample_rate: 44000, mix: 0.15, bits: 12 do
with_fx :pitch_shift, mix: 0.5 do
with_fx :hpf, mix: 0.1 do
with_fx :level, amp: 0.3 do
with_fx :lpf, cutoff: 70, mix: 0.2 do
                            #1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8
drum_loop(:highli, (ring *%w{- - - x x - - - - - - - - - - -    - - - r r - - - - - - - - - - -    -*16                               -*16                           }),  Ether[/noise/i,11],  amp: 0.2, start: 0.0, rate: (knit 1.0,64,1.1,64))
drum_loop(:kick,   (ring *%w{r - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -}),  Mountain[/impact/i,9],  amp: 0.0, rate: rrand(0.9,1.0))
drum_loop(:kick2,  (ring *%w{x x - - - - - - x - - - - - - -    x - - - - - - - x - - - - - - -    x - - - - - - - x - - - - - - -    x - - - - - - - x - - - - - - -}),  Mountain[/subkick/i,0], amp: (ring 0.5,0.2), start: (knit 0.01,1, 0.03,31), rate: (ring rrand(0.9,1.0)))
drum_loop(:snare,  (ring *%w{- - - - - - - - x - - - - - - -    - - - - - - - - x - - - - - - -    - - - - - - - - x - - - - - - -    - - - - - - - - x - - - - - - -}),  Ambi[/clap/,13], delta: 0.001,  amp: 0.1, start: 0.0, rate: 1.0)
drum_loop(:snare2, (ring *%w{- - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -    - - - - - - - - x - - - - - - -    - - - - - - - - - - - - - - - -}),  Ambi[/clap/,17], delta: 0.002,  amp: 0.1, start: 0.0, rate: 1.0)
drum_loop(:clap,   (ring *%w{- - - - - - - - r - - - - - - -    - - - - - - - - r - - - r - - -}),                                                                        Ether[/noise/i,5], amp: 0.3, start: 0.0, rate: 1.0)
drum_loop(:cchat,  (ring *%w{x - - x - - x - - x - - - - - -    - - x - - - r - x - r - - - - -    - - x - - - x - x - - - - - - -    x - - r - - x - - r - - x x - -}),  Ether[/click/i].shuffle.tick, rate: (knit 1.01,3,-1.1,2,-1.2,3), amp: rrand(0.5,0.3), start: rrand(0.0,0.00001))
                                                                                                                                                                          with_fx(:reverb, mix: 0.3){with_fx(:slicer, phase: 0.025, probability: 0.5){
drum_loop(:ochat,  (ring *%w{- - - - x - - - - - - - x - - -    - - - - x - - - - - - - x - - - }),                                                                       Down[/hat/i, [17, 16,15]], amp: 0.2);}}
drum_loop(:cymbal, (ring *%w{- - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -    - - - - - - - - - - - - - - - -     - - - - - - - - - - - - - - - r}), Ether[/noise/i,7], amp: 0.5)  
drum_loop(:swipe,  (ring *%w{- - - - - - - - - - - - x - - -    - - - - - - - - - - - - - - - -    - - - - - - - - - - - - x - - -    - - - - - - - - - - - - - - r -}),  Ether[/snare/i,12], delta: 0.01, amp: 0.3*(knit 0.5,24, 1.9,8).tick(:amp), start: 0.0, rate: (knit -0.8,16, -1.5,16).tick(:rate))
drum_loop(:fast,   (ring *%w{- - - - - - x - x - x - - - - -    - - - - - - x - x - x - - - - -}), Ether[/click/i,20], amp: 0.2, rate: (knit -1.0, 2, 1.0,2))
end;end;end;end;end