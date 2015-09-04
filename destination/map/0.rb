["experiments"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}
_=nil
hold     = (ring *%w{1  0 0 0 0 0 0 0 0 0   0  1  0   1 0  0}.map(&:to_i))
tranpose = (ring *%w{-5 0 0 0 -5 0 0 0 0 -12 0 -2 -12 -2 0 -12}.map(&:to_i))
velocity = (ring *%w{100 100 49 100 118 78 110 114 100 127 100 127 115 100 100 100}.map(&:to_i))

live_loop :apeg do
  use_synth :saw
  root = (knit :Fs3, 16, :As3, 16, :Ds3, 16).tick(:notes)
  
  with_fx(:distortion, mix: rrand(0.0,1.0)){
    with_synth(:hollow){
      play (knit :Fs4,1, :Cs4,1,:Fs3,1, :Cs4,1,:Fs3,1, :Cs4,1, :Fs3,1, :Es4,1,
                 :Fs4,1, :Cs4,1,:Fs3,1, :Cs4,1,:Fs3,1, :Cs4,1, :Fs3,1, :Es4,1,
                 :Fs4,1, :Cs4,1,:Fs3,1, :Cs4,1,:Fs3,1, :Cs4,1, :Fs3,1, :Es4,1,
                 :Fs4,1, :Cs4,1,:Fs3,1, :Cs4,1,:Fs3,1, :Cs4,1, _,1,    :As4,2
            ).tick(:thing), attack: 4.0, release: 0.1
    }
  }
  with_transpose(-24){
    with_synth(:dsaw){
      play (knit root,1, _, 15).tick(:bass), release: 1.5, decay: 2.5, amp: 0.5, cutoff: 70
    }
    with_synth(:prophet){
      play (knit root,1, _, 15).look(:bass), release: 1.5, decay: 2.0, amp: 0.2, cutoff: 70
    }
  }
  sleep 0.25
end

with_fx(:reverb, room: 1.0, mix: 1.0){ |r_fx|
live_loop :chorus do
  2.times{sync :apeg}
    with_synth(:hollow){
notes = (knit 
         chord_degree(1, :fs3, :major)[1..-1], 8,
         chord_degree(3, :fs3, :major)[1..-1], 8,
         chord(:Ds3, "m")[1..-1], 8,

         chord(:Fs3, 'sus4')[1..-1], 8,
         chord(:As3, 'm+5')[1..-1], 8,
         chord(:Ds3, "m7")[1..-1], 8,
      )
      4.times{control r_fx, dry: rrand(0.0,1.0) ; sleep 0.25/4.0}
      play notes.tick(:h), amp: (knit 1.0,4, 0.0,4).tick(:amp), release: 0.5, decay: 0.5
      puts (notes.look(:h))
    }
end
}

live_loop :sample_fun do
  32.times{sync :apeg}
#  sample Dust[/F/,3], rate: 1.0, amp: 0.5 
  #sample Dust[/F#/,3], rate: 1.0, amp: 0.5 
#  sample Dust[/A#/,4], rate: 1.0, amp: 1.0, cutoff: 80
  #sample Dust[/F#/,4], rate: 1.0, amp: 0.2, cutoff: 100

#  sample (ring Dust["Vapor_keys_topline",0], Dust["Vapor_keys_02"]).tick(:a) 
#sample Dust[/TDDC_Hit_Vapor_FullMix/]
#sample Dust[/VoxClarinet/].tick(:a)

#  (32-8).times{sync :apeg}
#  sample Dust[/TDDC_Voice_Hit/,6], amp: 1.0
  #sample Dust[/TDDC_Voice_Hit/,11], amp: 1.0

end

live_loop :coils do
  #play (ring chord("Cs3", "M7"), chord("Fs3", "M")).tick(:chords) , release: 8, attack: 4.0
  synth :dark_ambience, note: (ring :Es3, :Fs4).tick, release: 8, attack: 4.0, amp: 2.5
  32.times{sync :apeg}
  sample Ether[/coil/i, /f#/i], amp: 1.0
end

live_loop :drums do |d_idx|
  if d_idx % 4 == 0
    sample Fraz[/kick/i,16], amp: 0.5, start: 0.2
  end

  with_fx((knit :none, 3, :echo, 1, :none, 4).tick(:fx), decay: 0.5, phase: 0.25, mix: 0.4){
    #sample Fraz[/kick/i,[0,0]].tick(:kick), cutoff: (knit 130, 1, 115, 3).tick(:kcut)
    sample Dust[/TDDC_Voice_Hit/,16], amp: 1.0, cutoff: (knit 85,3,90,1).tick(:thing), rate: -1
    #sample Fraz[/kick/,0] if (spread 3, 8, rotate: 1).tick(:pat)

  }
  #sample "/Users/josephwilk/Dropbox/Music/samples/Chillstep\ Vocals/PBB_CHILLSTEP_VOCALS_WAV/WAV/VOCAL_HITS_AND_FX/BREATH_NOISES/CV_FE_BREATH_029.wav", amp: 0.1, rate: 0.8

  4.times{sync :apeg}
  #sample Fraz[/kick/i,[1,2]].tick(:kick2), cutoff: (knit 0,1,120,1).tick(:kick2) 
   #sample Dust[/Voice_Hit/,5], amp: 1.0, cutoff: 70
      
   #sample Dust[/TDDC_Voice_Hit/,16], amp: 1.0, cutoff: (knit 85,3,100,1).tick(:thing), rate: 1
   #sample Sop[/F#/,4], amp: 4.5, cutoff: 100

  with_fx(:reverb, room: 0.5, mix: 0.3, phase: 0.025){
  with_fx(:slicer, probability: 0.5){
#  sample Fraz[/snap/i,[0,0,0,0,1,1,1,1]].tick(:snap), amp: 0.2, rate: rrand(1.01,0.99), cutoff: (knit 100,2, 100,1, 110,1).tick(:cutoff)
  }
  }

  if(d_idx % 8 == 0)
    sample Vocals[/breath/], amp: 0.1, rate: 1.0, cutoff: 100  
    sleep 0.25
    sample Vocals[/breath/], amp: 0.1, rate: 1.0, cutoff: 100
  end

  4.times{sync :apeg}
  d_idx+=1
end

live_loop :texture do
  sample_and_sleep Mountain[/cracklin/i, 0], rate: 0.9, amp: 0.2                 
end

live_loop :hats do
  sync :apeg
  mix = [0.1,0.2,0.3,0.4,0.5].choose

#  sample (ring Fraz[/kick/,0], Fraz[/kick/,1]).tick(:s),  amp: 2.5  if (spread 1, 4).tick(:d)
 # sample Dust[/voice/,8],  amp: 2.5  if (spread 1, 8, rotate: 4).look(:d)
  #sample Dust[/voice/,16], amp: 2.5 if (spread 3, 8).look(:d)
  #sample Dust[/voice/,14],  amp: 1.2 if (spread 7, 11).look(:d)

  with_fx(:reverb, mix: mix, room: 0.8){
  #  sample Frag[/hat/i, Range.new(0,(ring 2,4).tick(:r))].tick(:hats), amp: 0.1, cutoff: (knit 105,3,115,3).tick(:hats)
     sample Dust[/banton/,0], amp: (knit 1,3,0,1).tick(:k), cutoff: (knit 80,3,100,3).tick(:c)
  }
end
