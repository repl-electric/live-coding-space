bar = 4.0 

def as_ring(pat)
 ring(*pat.split("\s"))
end

def pat(s, p, *args)
 sync :s
 if p == "x"
  sample *([s]+args)
 end
end

live_loop :beatz do
sync :foo
#density(-1) do
 32.times{
 cue :s
 sleep (bar/16.0) 
}
#end
end
 with_fx :lpf, cutoff: 73 do

         #1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8  
                                                                             live_loop(:kicker2)do; 32.times{pat(Ether[/click/i,11],      
(ring *%w{- - x x - - - - - - - - - - - -    x - - - - - - - - - - - - - - -}).tick(:a), amp: 1.0, start: 0.0,)};end
                                                                             live_loop(:kicker)do; 32.times{pat(Ether[/click/i,11],      
(ring *%w{x x - - - - - - x - - - - - - -    x - - - - - - - x - x - - - - -}).tick(:a), amp: 3.0, start: 0.1,)};end
                                                                               live_loop(:snare) do; 32.times{pat(Ether[/click/i,13],     
(ring *%w{- - - - x - - - - - - - x - - -    - - - - x - - - - - - - x - - -}).tick(:b), amp: 3.0)};end
                                                                               live_loop(:hats)do; 32.times{pat(Ether[/click/i,2],          
(ring *%w{x - x - x - x - - - x - x - x -    x - x - x - x - - - x x - x - -}).tick(:a), amp: 1.05)};end
                                                                               live_loop(:swish) do; with_fx :reverb, room: 0.7, mix: 0.3 do; 16.times{
                                                                               with_fx(:slicer, phase: 0.15, probability: 0.5){pat(Ether[/snare/i,12],  
(ring *%w{- - - - - x - - - - - - - x - -    - - - - - x - - - - - - - - - x}).tick(:c), amp: (knit 0.5,24, 1.9,8).tick(:amp), start: 0.0, rate: -1.0)}};end;end
end

live_loop :kick  do; 16.times{pat(Ether[/kick/i,5],  (ring *%w{x x - - - - - - - - - - - - - -}).tick(:d), amp: 0*0.5)};end

live_loop :kick2  do; 16.times{pat(Ether[/kick/i,4], bar, (ring *%w{- - x x - - - - - - - - - - - -}).tick(:e), amp: 0*0.9, rate: rrand(0.9,1.0))};end
