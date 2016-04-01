["instruments","shaderview","experiments", "log","samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil
set_volume! 0.5
use_bpm 140
live_loop :beat do
  if spread(6,12, rotate: 4).tick(:s)
    p = ([0,11, -64, 1] + [[2,1],[5,1],[2,1],[-2,1]].shuffle).flatten
    sample CineElec[/f#m/, /WrongPiano/, 0], amp: 0.45, start: 0.0, finish: 0.1,
      rpitch: (knit *p).tick(:high)
  end
  if spread(4,8).look(:s)
    start = (knit 0.2,3, 0.9,1).tick
    #sample CineElec[/f#m/, /WrongPiano/, 0], amp: (ring 0.8, 0.4,0.5, 0.9).tick(:amp), start: start, finish: 1.0
  end
  if spread(1,8, rotate: 1).look :s
    with_fx :pitch_shift, mix: 0.1 do
      sample CineElec[/f#m/, /WrongPiano/, 0], amp: 1.0+rand, rpitch: (ring -32.0, -12.0).tick(:p),
        start: (ring 0.5, 0.5, 0.5, 0.6).tick(:bass), finish: 0.48
    end
  end
  if spread(1, 12).look :s
    sample CineElec[/f#m/, /WrongPiano/, 0], rpitch: (ring -12, -12).tick(:r), start: 0.9, finish: 1.0
  end
  
  if spread(1, 64).look(:s)
    #sample CineElec[/f#m/, /WrongPiano/, 0], amp: 0.45, start: 0.0, finish: 1.0
  end
  
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    if spread(3, 7).tick :s2
      sample CineElec[/f#m/, /WrongPiano/, 0], finish: 0.9, start: 0.88, amp: 0.2, cutoff: 100
    end
    if spread(7, 11).look :s2
      with_fx :distortion, mix: 0.9, distort: (range 0.0, 0.5, 0.01).tick(:dis) do
        sample CineElec[/f#m/, /WrongPiano/, 0], start:0.9, finish: 0.88, amp: 0.2, cutoff: 130,
          rpitch: ([2,2,2,0,5].choose - [12,12,12].choose)
      end
    end
  end
  
  sleep 0.25
end
