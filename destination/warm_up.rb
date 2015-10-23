["instruments","shaderview","experiments", "log"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil

with_fx(:reverb, room: 1.0, mix: 1.0, mix_slide: 0.1, damp: 0.5, damp_slide: 1) do |r_fx|
  live_loop :guitar do
    mix = rrand(0.5, 1.0)
    use_random_seed 300
    sample Corrupt[/Guitar/, /Gm/, /fx/].take(5).shuffle.tick(:sample),
      cutoff: 100, amp: rand, beat_stretch: 16
    32.times{ sleep 1; control r_fx, damp: rand, mix: [1.0, mix+0.01].min}
  end
end

live_loop :atoms do
  sleep 6
  sample Ether[/interference/, /Gm/, 0], cutoff: rrand(80,100),
    beat_stretch: 32, amp: rand+0.1
  sleep 10
end

live_loop :dark do
  with_fx(:reverb, room: 1.0, mix: 1.0, damp: 0.0, reps: 4) do
    n = scale(:G3, :minor_pentatonic, num_octaves: 3).take(3).shuffle.choose
    16.times{
      sleep 8
      synth :dark_ambience, note: n, decay: 4, attack: 1.0, amp: 0.8, cutoff: 120, detune1: 12, 
      detune2: 12
    }
  end
end
