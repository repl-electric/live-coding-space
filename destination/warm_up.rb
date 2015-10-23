["instruments","shaderview","experiments", "log"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil

with_fx(:reverb, room: 1.0, mix: 1.0, damp: 0.5, damp_slide: 1) do |r_fx|
  live_loop :guitar do
    use_random_seed 300
    sample Corrupt[/Guitar/, /Gm/, /fx/].take(5).shuffle.tick(:sample),
      cutoff: 100, amp: 1.0, beat_stretch: 16
    16.times{sleep 1; control r_fx, damp: rand}
  end
end

live_loop :atoms do
  sample Ether[/interference/, /Gm/, 0], cutoff: 100,
    beat_stretch: 16
  sleep 16
end
