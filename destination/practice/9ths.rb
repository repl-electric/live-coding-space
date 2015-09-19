["log","experiments", "shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}
_=nil
live_loop :apeg do
  sleep (0.25 * 1)
end

live_loop :coils do
  with_synth(:dark_ambience){
    play (ring
              chord(:Fs3, :M),
              chord(:As3, 'm+5'),
              chord(:Ds3, 'm'),  
              chord(:Cs3, :M),
              chord(:Cs3, :maj9)

).tick(:c), release: 8, attack: 4.0, amp: 20.0
  }
  32.times{sync :apeg}
end

with_fx(:reverb, room: 1.0, mix: 1.0) do
live_loop :test do
  use_synth :tb303
    notes = (ring chord(:Fs3, '7'), chord(:As3,'m7+5'), 
                        chord(:Ds3, 'm7+5'), 
                        chord(:Cs3, 'maj9') ).tick(:m)
    (32).times{
    sync :apeg
      play notes[-1], attack: 0.001, amp: 0.5, cutoff: (range 50,70,5).tick(:c)
    }
end
end

with_fx(:reverb) do |fx_r|
live_loop :stability do
 sync :apeg
 use_synth :dsaw
notes = (knit :Fs2, 1, nil,31,
                :As2, 1, nil,31,
                :Ds2, 1, nil,31,
                :Cs3, 1, nil,31) 
play notes.tick, release: 4, decay: 10, cutoff: 60, detune: 12, attack: 2.0
with_synth(:prophet){ 
    play notes.look, attack: 0.5, release: 4, decay: 10, cutoff: 75, detune: 12, attack: 2.0
}
control fx_r, damp: rrand(0.0,1.0)
end
end

live_loop :kicker do
 sync :apeg
  with_fx((knit :none,3, :echo,1, :none, 4).tick(:fx), phase: 0.25) do
    sample Mountain[/subkick/,[1,2]].tick, cutoff: 120 if spread(1,4).tick(:a)
  end
#  with_fx(:reverb, room: 1.0){
    sample Mountain[/snare/,1], cutoff: 85 if spread(1,8, rotate: 1).look(:a)
 # }

  sample Mountain[/micro/,5], cutoff: (range 70,100, 10).tick    if spread(7,11).look(:a)
  sample Mountain[/micro/,6], cutoff: (range 100,70, 10).tick    if spread(3,8).look(:a)
end
