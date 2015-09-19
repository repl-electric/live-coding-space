["log","experiments"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}
_=nil
hold     = (ring *%w{1  0 0 0 0 0 0 0 0 0   0  1  0   1 0  0}.map(&:to_i))
tranpose = (ring *%w{-5 0 0 0 -5 0 0 0 0 -12 0 -2 -12 -2 0 -12}.map(&:to_i))
velocity = (ring *%w{100 100 49 100 118 78 110 114 100 127 100 127 115 100 100 100}.map(&:to_i))

with_fx(:reverb, room: 1.0, mix: 1.0) do
live_loop :vocals do
#sample Sop[/F#/,0], amp: 1.0, cutoff: 100
32.times{sync :apeg}
#sample Sop[/F#/,0], amp: 0.5, cutoff: 100
#sample Sop[/A#/,0], amp: 0.5, cutoff: 100
32.times{sync :apeg}
#sample Sop[/A#/,0], amp: 1.0, cutoff: 100
32.times{sync :apeg}
end
end

live_loop :apeg do
  use_synth :saw
  root = (knit :Fs3, 16, :As3, 16, :Ds3, 16,  
               :Fs3, 16, :As3, 16, :Gs3, 16,
               :Fs3, 16, :As3, 16, :Es3, 16,
               :Fs3, 16, :As3, 16, :Cs3, 16
).tick(:notes)
  with_transpose(-24){
    with_synth(:dsaw){play (knit root,1, _, 15).tick(:bass), release: 1.5, decay: 2.5, amp: 0.5, cutoff: 70}
    with_synth(:prophet){play (knit root,1, _, 15).look(:bass), release: 1.5, decay: 2.0, amp: 0.2, cutoff: 70}
  
    if (knit root,1, _, 15).look(:bass)
      sample Fraz[/coil/,4], amp: 1, cutoff: (ring 70,80).tick(:cu)
    end
}
  sleep 0.25 * 1
end

live_loop :dis do
#sample "/Users/josephwilk/Workspace/music/samples/DeviantAcoustics_Wav_SP/One\ Shots/Instrument\ FX/F\#_KalimbaTextureFX_SP_02.wav"
#sample Corrupt[/f#/,0]
#sample Corrupt[/f#/,1], amp: 1.0, cutoff: 100
sync :apeg
with_fx(:slicer, phase: (range 1, 2, 0.1).tick(:ph), smooth_down: 2.0, smooth_up: 2.0){
  sample_and_sleep Ether[/f#/, /ambience/, 0], cutoff: 70
}
end

                         live_loop :coils do
                           #sample Fraz[/coil/, 3], amp: 1.0
                           sleep 1
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
# 
#F#maj	G#min	A#min	Bmaj	C#maj	D#min	E#dim
#F#maj7	G#min7	A#min7	Bmaj7	C#7	D#min7	E#m7b5
with_fx(:reverb, room: 1.0, mix: 1.0){ |r_fx|
live_loop :chorus do
notes = (knit 
         chord_degree(1, :fs3, :major)[1..-1], 8,
         chord_degree(3, :fs3, :major)[1..-1], 8,
         chord(:Ds3, "m")[1..-1], 8,

         chord(:Fs3, 'sus4')[1..-1], 8,
         chord(:As3, 'm+5')[1..-1], 8,
         chord(:Ds3, "m7")[1..-1], 8,   #D F A C

         chord(:Fs3, 'sus4')[1..-1], 8,
         chord(:As3, 'm+5')[1..-1], 8,

         chord(:Cs3, :M)[1..-1], 6,
         chord(:Cs3, :maj9)[1..-1],2
)

  1.times{sync :apeg}
    with_synth(:hoover)do
      play notes.tick(:h)[0], amp: 0.025
    end

 1.times{sync :apeg}
    with_synth(:hollow){
      4.times{control r_fx, dry: rrand(0.0,1.0) ; sleep 0.25/4.0}
      play notes.look(:h), amp: (knit 2.0,4, 0.0,4).tick(:amp), release: 0.5, decay: 0.5, cutoff: (ring 80,100,110,130).tick(:cut), res: (ring 0.98,0.99).tick(:xcut)
      puts note_inspect(notes.look(:h), "CHORD")
    

if(notes.look(:h) == chord(:Ds3, "m7")[1..-1])
 cue :lovely
    #sample (knit Frag[/coils/, /F#/,0] ,1,   _,7).tick(:s)
with_fx(:flanger){
    sample (knit "/Users/josephwilk/Dropbox/repl-electric/samples/Bowed Notes/G#_HarmBow_01_SP.wav" ,1,   _,7,
                 "/Users/josephwilk/Dropbox/repl-electric/samples/Bowed Notes/D#_BowedGuitarNote_01_SP.wav",1,_,7,
                 "/Users/josephwilk/Workspace/music/samples/Mountain/One Shots/Bowed Notes/G#_BowedHarmSoft_01_SP.wav",1,_,7
).tick(:s), cutoff: 80, amp: 0.15*1
}
#   sample (knit Sop[/F#4/,/down/,1] ,1,   _,7).tick(:s)
end
}
end
}

                           live_loop :arrrrrrr do #D F A C E
                             sync :lovely
                             sample Sop[/F#/,0]
                           end

with_fx(:lpf, cutoff: 100) do
live_loop :highlight do
  16.times{sync :apeg}
  with_transpose(0) do
  i_deter(deg_seq(%w{Fs4 1*3 3*3  5*3   1*3  3*3   5*3 }).tick,
          deg_seq(%w{Fs4 3   5    6     3    5     2 }).stretch(3).tick, amp: 0.8*1,  
          damp_time: 0.25*1.0)
  end
end
end

live_loop :sample_fun do
  32.times{sync :apeg}
  #sample Fraz[/coil/, 4], amp: 1.0, cutoff: 80
#  sample Dust[/F/,3], rate: 1.0, amp: 0.5 
  #sample Dust[/F#/,3], rate: 1.0, amp: 0.5 
#  sample Dust[/A#/,4], rate: 1.0, amp: 1.0, cutoff: 80
  #sample Dust[/F#/,4], rate: 1.0, amp: 0.2, cutoff: 100

#  sample (ring Dust["Vapor_keys_topline",0], Dust["Vapor_keys_02"]).tick(:a) 

with_fx(:echo, room: 1.0, mix: 1.0) do
#sample Dust[/TDDC_Hit_Vapor_FullMix/]
#sample Dust[/VoxClarinet/].tick(:a)
end
#  (32-8).times{sync :apeg}
#  sample Dust[/TDDC_Voice_Hit/,6], amp: 1.0
  #sample Dust[/TDDC_Voice_Hit/,11], amp: 1.0

end

live_loop :coils do
  #play (ring chord("Cs3", "M7"), chord("Fs3", "M")).tick(:chords) , release: 8, attack: 4.0
  #synth :dark_ambience, note: (ring :Es3, :Fs4).tick, release: 8, attack: 4.0, amp: 2.5
  32.times{sync :apeg}
#  sample Ether[/coil/i, /f#/i], amp: 1.0
end

live_loop :drums do |d_idx|
  if d_idx % 4 == 0
    #sample Fraz[/kick/i,16], amp: 0.5, start: 0.0
  end

  with_fx((knit :none, 3, :echo, 1, :none, 4).tick(:fx), decay: 0.5, phase: 0.25, mix: 0.4){
   # sample Fraz[/kick/i,[0,0]].tick(:kick), cutoff: (knit 100, 1, 115, 3).tick(:kcut)
    #sample Dust[/TDDC_Voice_Hit/,16], amp: 1.0, cutoff: (knit 85,3,90,1).tick(:thing), rate: -1
#   sample Fraz[/kick/,0] #if (spread 3, 8, rotate: 1).tick(:pat)

  }
  #sample Fraz[/coil/, 0], amp: 1.0, cutoff: 70
  #sample "/Users/josephwilk/Dropbox/Music/samples/Chillstep\ Vocals/PBB_CHILLSTEP_VOCALS_WAV/WAV/VOCAL_HITS_AND_FX/BREATH_NOISES/CV_FE_BREATH_029.wav", amp: 0.1, rate: 0.8

  4.times{sync :apeg}
 # sample Fraz[/kick/i,[1,2]].tick(:kick2), cutoff: (knit 0,1,100,1).tick(:kick2) 
 #  sample Dust[/Voice_Hit/,5], amp: 1.0, cutoff: 70
      
   sample Dust[/TDDC_Voice_Hit/,16], amp: 0.5, cutoff: (knit 85,3,100,1).tick(:thing), rate: (ring 1.0,  -1.0).tick(:r)

with_fx(:flanger){
}
  with_fx(:reverb, room: 0.5, mix: 0.3, phase: 0.025){
  with_fx(:slicer, probability: 0.5){
   # sample Fraz[/snap/i,[0,0,0,0,1,1,1,1]].tick(:snap), amp: 0.2, rate: rrand(1.01,0.99), cutoff: (knit 100,2, 100,1, 110,1).tick(:cutoff)
  }
  }
 #sample Vocals[/breath/,6], amp: 0.1, rate: 1.0, cutoff: 70 
    
  if(d_idx % 8 == 0)
  #  sample Vocals[/breath/,6], amp: 0.1, rate: 1.0, cutoff: 100  
    sleep 0.25
  #  sample Vocals[/breath/,6], amp: 0.1, rate: 1.0, cutoff: 100
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

 # sample (ring Fraz[/kick/,0], Fraz[/kick/,1]).tick(:s),  amp: 2.5  if (spread 1, 4).tick(:d)

  with_fx(:reverb, mix: mix, room: 0.8){

   # sample Frag[/hat/i, Range.new(0,(ring 2,4).tick(:r))].tick(:hats), amp: 0.1, cutoff: (knit 105,3,115,3).tick(:hats) if (spread 7, 11).tick(:spread)
     sample Dust[/banton/,[0,1]].tick(:b), amp: (knit 1,3,0,1).tick(:k), cutoff: (knit 80,3,100,3).tick(:c)
  }
  
end
