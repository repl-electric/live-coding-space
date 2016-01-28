use_synth :square
n = play :FS2, note_slide: 0.5, decay: 1.0
control n, note: :FS4, note_slide: 0.125
sleep 1
play :D4, decay: 0.5
#n = play :D4, note_slide: 0.5, decay: 1.0
#control n, note: :D3, note_slide: 0.12
8.times{
  sleep 0.25
  play :E4, release: 0.25

}
