_=nil
bar=1
live_loop :warm do
  notes = ring([:FS2]).tick
  sleep 1
  s1 = synth :dark_sea_horn, note: notes[0], cutoff: 60, decay: 8.0
  s2 = synth :dark_sea_horn, note: notes[1], cutoff: 50, decay: 8.0
  s3 = synth :dark_sea_horn, note: notes[2], cutoff: 45, decay: 8.0

  7.times{
    candidate = scale(:FS3, :minor_pentatonic, num_octaves: 1).drop(1).shuffle.choose
    control s1, note: (ring :FS4, :A4, :Cs4).tick, noise1: ring(32.25).tick(:n1), noise2: 0, amp: 1.0,  max_delay: 0.5
    synth :gpa, note: (ring :E3, _, :Gs3).tick, decay: 1.0, wave: 6

    sleep 1
  }
end

live_loop :go do
  sync :warm
  i_hollow((ring :FS4, :E4), amp: 2.0)
end
