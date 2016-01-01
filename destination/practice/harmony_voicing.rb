# Practicing bass+chord voicing following harmony rules.

set_volume! 5.0
_=nil
live_loop :do do #E G B -   D  - F A C - E        F G A B C D E
  synth :dark_sea_horn, note: (ring chord(:Fs3, :m), chord(:D3, :M), chord(:E3, :M)).tick, decay: 4, cutoff: 80
  synth :dark_sea_horn, note: (ring
                               _,:Fs1, _,
                               _, _, _
                               ).tick(:bass), decay: (ring 12+2).tick(:R), amp: 1.0, cutoff: 120, noise1: 1.5, noise2: 1.5

  sleep 4
end
