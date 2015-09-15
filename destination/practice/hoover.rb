["log","experiments"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}


use_bpm 80

live_loop :samplz do
  #sample "/Users/josephwilk/Workspace/music/samples/loops/Sample Magic/synth & key loops/80bpm/am_syn80_clover_C#.wav", pitch_stretch: 16.0, pitch_dis: 0.0, time_dis: 0.1
  sleep 4.0
end

_=nil
with_fx(:reverb) do
live_loop :ambi do
    use_synth :hoover
sync :samplz

#C#, E, and G#

#(i, iio, III, iv, v, VI, VII)
# F♯, G♯, A, B, C♯, D, and E. F
#  Cm => A   C  G  B  D
8.times{
  notes2 = (knit 
#:Cs3,1, _,3,
                 :Cs3,1, _,3,
#                 :Cs3, 1, _,3,
#                 :B3,1, _,3,
).tick(:note1)
  sample Ambi[/perc/,Range.new(2, (ring 4,8).tick(:a))].tick(:perc), cutoff: 100
  play notes2, decay: 1.0, release: 2.0, attack: 0.01, amp: 0.5, cutoff: 100

  note = (knit :Cs4,1, :As3,1,  :Cs4,1, :Ds4,1,
               :Cs4,1, :As3,1,  :Cs3,1, :Fs3,1, 
               :Cs4,1, :As3,1,  :Ds4,1, :Fs4,1,
               :Cs4,1, :As3,1,  :Cs3,1, :Fs3,1, 

).tick(:note)
  release = (ring 1.0/2.0, 1.0/2.0, 1.0/2.0, 1.0,  
                  1/4.0, 1/4.0, 1/4.0, 1/4.0
).tick(:r)

  play note, release: release, attack: 0.01
  sleep release
}
end
end

live_loop :blah do
  sample Ambi[/kick/,3]
  sleep 2

  sample Ambi[/kick/,4]
  sample Ambi[/clap/,0]
  sleep 2
end
