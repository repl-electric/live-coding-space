["log","experiments"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}
_=nil
hold     = (ring *%w{1  0 0 0 0 0 0 0 0 0   0  1  0   1 0  0}.map(&:to_i))
tranpose = (ring *%w{-5 0 0 0 -5 0 0 0 0 -12 0 -2 -12 -2 0 -12}.map(&:to_i))
velocity = (ring *%w{100 100 49 100 118 78 110 114 100 127 100 127 115 100 100 100}.map(&:to_i))

live_loop :apeg do
  use_synth :saw
  root = (knit :Fs3, 16, :As3, 16, :Ds3, 16).tick(:notes)
  with_transpose(-24){
    with_synth(:dsaw){play (knit root,1, _, 15).tick(:bass), release: 1.5, decay: 2.5, amp: 0.5, cutoff: 70}
    with_synth(:prophet){play (knit root,1, _, 15).look(:bass), release: 1.5, decay: 2.0, amp: 0.2, cutoff: 70}
  }
  sleep 0.25 * 1
end

with_fx(:pitch_shift, time_dis: 4.0){
  with_fx(:distortion, mix: 0.3){
    live_loop :args do
      2.times{sync :apeg}
      with_synth(:string){ 
 with_transpose(0){

with_fx(:lpf, cutoff: 90, mix: 0.0){
        play (ring
                       :Fs4, :Cs4, :Fs3, :Cs4,  :Fs4,   :Cs4,   :Es4, :Es4,
                       :As4, :Cs4, :As3, :Cs4, :As4,  :Cs4,   :Es4, :Es4,                        #
                        :Ds4, :Gs4, :Ds4, :Gs4, :Ds4, :Gs4,   :Es4, :Es4,

                        :Fs4, :Cs4, :Fs3, :Cs4,   :Fs4,  :Cs4,   :Es4, :Es4,
                       :As4, :Cs4, :As3, :Cs4,  :As4,  :Cs4,   :Fs4, :Cs4,                        #A  C   E      G
                        :Ds4, :Cs4, :Ds4, :Cs4,  :Ds4,  :Cs4,   :Es4, :Es4
).tick(:notes), wave: 6, attack: 0.04, release: 0.25, saw_cutoff: 100, noise_level: 0.05, amp: 0.0
}
}
#4 :amp 0.00 :saw-cutoff 2000 :wave 0 :attack 1.0 :release 5.0 :noise-level 0.05 :beat-trg-bus (:beat time/beat-1th) :beat-bus (:count time/beat-1th)))
}
#      puts note_inspect(notes.look(:thing), :DEG)
#} 
end
}}

_=nil
with_fx(:distortion, mix: (ring 0.0, 0.0, 0.1, 0,1,  0.2,  0.2,  0.2, 0.4).tick(:dis)+0.1) do
live_loop :arse do
1.times{  sleep 0.25}
with_fx(:lpf, cutoff: 60){
with_synth(:plucked){
  play (ring :Fs4, :Fs4, _,  _,   :Cs4, _ , _,    :Fs3,  _,  :Cs4, _, :Es4,_, :Es4,_, _,
                  :Gs4, :Gs4,_,  _,   :As4, _ ,_,     :Fs4,  _,  :As3,_,  :Fs4,_, :Fs4,_, _,   #A C E G
                  :Fs4, :Fs4, _,  _,   :Cs4, _ , _,    :Cs4, _, _, _,        :Es4,_,  :Es4,_, _   #D F  A C 
 ).tick(:a), release: 1.4, attack: 0.01, amp: (ring 1.0,0.9,0.8,0.8 ).tick(:amps)*0
}}
end
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
         chord(:Ds3, "m7")[1..-1], 8,   #D F A C
      )
      4.times{control r_fx, dry: rrand(0.0,1.0) ; sleep 0.25/4.0}
      play notes.tick(:h), amp: (knit 1.0,4, 0.0,4).tick(:amp), release: 0.5, decay: 0.5, cutoff: (ring 80,100,110,130).tick(:cut)
      puts note_inspect(notes.look(:h), "CHORD")
    

if(notes.look(:h) == chord(:Ds3, "m7")[1..-1])
    #sample (knit Frag[/coils/, /F#/,0] ,1,   _,7).tick(:s)
with_fx(:flanger){
    sample (knit "/Users/josephwilk/Dropbox/repl-electric/samples/Bowed Notes/G#_HarmBow_01_SP.wav" ,1,   _,7,
                         "/Users/josephwilk/Dropbox/repl-electric/samples/Bowed Notes/D#_BowedGuitarNote_01_SP.wav",1,_,7,
                         "/Users/josephwilk/Workspace/music/samples/Mountain/One Shots/Bowed Notes/G#_BowedHarmSoft_01_SP.wav",1,_,7
).tick(:s), cutoff: 90, amp: 0.0
}
#   sample (knit Sop[/F#4/,/down/,1] ,1,   _,7).tick(:s)
end
}
end
}

live_loop :highlight do
  16.times{sync :apeg}
  i_deter(deg_seq(%w{Fs4 1*3 3*3  5*3   1*3  3*3   5*3 }).tick,
              deg_seq(%w{Fs4 3    5      6      3      5      2 }).stretch(3).tick, amp: 0.8*0,  damp_time: 0.25*2)
end

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
#  sample Ether[/coil/i, /f#/i], amp: 1.0
end

live_loop :drums do |d_idx|
  if d_idx % 4 == 0
    #sample Fraz[/kick/i,16], amp: 0.5, start: 0.2
  end

  with_fx((knit :none, 3, :echo, 1, :none, 4).tick(:fx), decay: 0.5, phase: 0.25, mix: 0.4){
    sample Fraz[/kick/i,[0,0]].tick(:kick), cutoff: (knit 130, 1, 115, 3).tick(:kcut)
    #sample Dust[/TDDC_Voice_Hit/,16], amp: 1.0, cutoff: (knit 85,3,90,1).tick(:thing), rate: -1
#   sample Fraz[/kick/,0] #if (spread 3, 8, rotate: 1).tick(:pat)

  }
  #sample "/Users/josephwilk/Dropbox/Music/samples/Chillstep\ Vocals/PBB_CHILLSTEP_VOCALS_WAV/WAV/VOCAL_HITS_AND_FX/BREATH_NOISES/CV_FE_BREATH_029.wav", amp: 0.1, rate: 0.8

  4.times{sync :apeg}
  sample Fraz[/kick/i,[1,2]].tick(:kick2), cutoff: (knit 0,1,120,1).tick(:kick2) 
 #  sample Dust[/Voice_Hit/,5], amp: 1.0, cutoff: 70
      
   sample Dust[/TDDC_Voice_Hit/,16], amp: 0.5, cutoff: (knit 85,3,100,1).tick(:thing), rate: (ring 1.0,  -1.0).tick(:r)
#   sample Sop[/F#/,4], amp: 3.0, cutoff: 100

with_fx(:flanger){
#  sample Sop[/F#4/,/Oo/, /down/, 0]

#  sample Sop[/F#4/,/Oo/, /down/, 1] if spread(4,11).tick(:spread)
  #sample Sop[/F#4/,/Oo/, /down/, 0] if spread(1,8).look(:spread)
 # sample Sop[/A#4/,/Oo/, /down/, 0] if spread(3,8).look(:spread)
}
  with_fx(:reverb, room: 0.5, mix: 0.3, phase: 0.025){
  with_fx(:slicer, probability: 0.5){
  sample Fraz[/snap/i,[0,0,0,0,1,1,1,1]].tick(:snap), amp: 0.2, rate: rrand(1.01,0.99), cutoff: (knit 100,2, 100,1, 110,1).tick(:cutoff)
  }
  }
 sample Vocals[/breath/], amp: 0.1, rate: 1.0, cutoff: 70 
    
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

    sample Frag[/hat/i, Range.new(0,(ring 2,4).tick(:r))].tick(:hats), amp: 0.1, cutoff: (knit 105,3,115,3).tick(:hats) if (spread 7, 11).tick(:spread)
     #sample Dust[/banton/,0], amp: (knit 1,3,0,1).tick(:k), cutoff: (knit 80,3,100,3).tick(:c)
  }
 #  sample Dust[/perc/, [8,10]].tick(:perc) if (spread 3, 8).look(:spread)

  sample Mountain[/microperc/, [5,5,6]].tick(:perc) if (spread 3, 8).look(:spread)
 

  # sample Dust[/voice/, [3,4]].tick(:perc), start: (ring 0.0, 1.0-0.25).tick(:start), finish: (ring 0.25, 1.0).tick(:fin) if (spread 3, 8).look(:spread)
  
 #sample Frag[/hat/, [13,13,15]].tick(:erc) if (spread 3, 8).look(:spread)


# sample Dust[/voice/, [7,12]].tick(:perc), start: (ring 0.0, 1.0-0.25).tick(:start), finish: (ring 0.25, 1.0).tick(:fin) if (spread 3, 8).look(:spread)


end
