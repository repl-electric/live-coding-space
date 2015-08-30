["experiments"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}

hold     = (ring *%w{1  0 0 0 0 0 0 0 0 0   0  1  0   1 0  0}.map(&:to_i))
tranpose = (ring *%w{10 0 0 0 5 0 0 0 0 -12 0 -2 -12 -2 0 -12}.map(&:to_i))
velocity = (ring *%w{100 100 49 100 118 78 110 114 100 127 100 127 115 100 100 100}.map(&:to_i))

_=nil
live_loop :apeg do
  use_synth :blade
  root = (knit :Fs3, 16, :As3, 16, :Ds4, 16).tick(:root)
  with_fx(:reverb){
  with_fx(:distortion){
  with_transpose(tranpose.tick(:t)){
    play root, release: hold.tick(:h) == 1 ? 0.8 : 0.5, attack: 1-(velocity.tick(:v)/100), cutoff: 80
  }
  }
  }

  with_transpose(-24){
    with_synth(:dsaw){
      play (knit root,1,  _,1, root,1, _, 14).tick(:bass), release: 0.5, cutoff: 80, attack: 0.01, decay: 2.0, amp: 0.5
    }
    with_synth(:prophet){
      play (knit root,1,  _,1, root,1, _, 14).tick(:bass), release: 0.5, cutoff: 80, attack: 0.01, decay: 2.0, amp: 0.5
    }
  }
  sleep 0.25
end

live_loop :harmony do
  sync :apeg
  with_fx(:reverb){
    with_synth(:hollow){
      play chord(:Fs4, 'M'), amp: (knit 5.0,6, 0.0,2).tick(:amp) 
    }
  }
end

live_loop :beat do |b_idx|
  if b_idx % 32 == 0
    sample Fraz[/kick/i,3]
  end
  
  with_fx((knit :none, 3, :reverb, 1, :none, 4).tick(:fx), decay: 0.1){
    sample Fraz[/kick/i,[0,1]].tick(:kick)
  }
  4.times{sync :apeg}
  sample Fraz[/snap/i,[0,0,0,0, 1,1,1,1]].tick(:s), cutoff: 100
  4.times{sync :apeg}
  b_idx+=1
end


