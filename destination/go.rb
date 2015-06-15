
["experiments"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}"}
#                          \:o/
#     π=-    π=-   π=-      █
#    π=-   π=-   π=-      .||.  
_ = nil#.go
bar = 1.0
use_bpm 60
set_volume! 3.0
@polyrhythm = [2,3]

live_loop :intro do
sync :foo
with_fx :distortion, mix: (knit 0.0,3,1.0,1).tick(:v) do
#  sample Ether.all(/F#/)[2], amp: 3.0+rrand(0.0,0.2), rate: -1.0
end
end

live_loop :bells do
8.times{sync :foo}
with_fx :distortion, amp: 0.3, mix: 0.3 do
with_synth :beep do
with_fx (knit :echo,2, :reverb,2).tick(:fx), decay: 4.0, room: 1.0 do
  n = play (knit :Fs4, 7, _, 1,
                 :As4, 7, _, 1
).tick, amp: 0.3


  if dice(32) == 1
     with_fx :pan, pan: Math.sin(vt*13)/1.5 do
     with_fx :bitcrusher, bits: 7, sample_rate: 32000 do
       sample Mountain[/bow/i, /f#/i, 0],amp: 0.4 
  end;end;end

  sleep bar/4.0
  control n, note: (knit :As4, 4, :B4, 4,
                         :Cs4, 4, :B4, 4).tick
  sleep bar/2.0
end;end;end;end 

live_loop :bass do |m_idx|;with_fx :level, amp: 0.5 do
   sync :foo
    case (m_idx%8)
    when 0,4,2,6
     if m_idx%16 == 0
       with_fx(:echo, decay: 2, pre_amp: 0.3){
         sample Ether["noise",(ring 12).tick(:noise)], amp: 0.5+rrand(0.0,0.1), rate: (ring 0.7,0.8,1.0).tick
       }
       sample Mountain["subkick",1], amp: 1.0+rrand(0.0,0.2), rate: rrand(0.9,1.0)
     else
     sample Mountain["subkick",0], amp: 1.0+rrand(0.0,0.2), rate: rrand(0.9,1.0)
     end
    when 1,3,4,5
      #sample Ether["snare",3], amp: 0.5+rrand(0.0,0.2), rate: rrand(0.9,1.0)
    when 7
      sample Mountain["Impact_0#{(stretch (1..5).to_a, 16).tick(:b)}"], rate: -1.0,amp: 0.2
    end
    m_idx+=1
end;end

live_loop :ghost do;with_fx :level, amp: 0.1 do
sync :foo
#comment do
2.times{sleep bar/2.0;sample knit(Mountain["MICROPERC",3],8, Mountain["MICROPERC",5],2).tick(:asd),
        amp: rrand(0.55,0.6), attack: rrand(0.0,0.05)}
#end
comment do
2.times{sleep bar/2.0;sample knit(Ether[/f#_/i,7],2).tick(:asd),
        amp: rrand(0.55,0.6), attack: rrand(0.0,0.05)}
end
end; end

live_loop :beats do;with_fx :level, amp: 0.6 do
    sync :foo
    sample Mountain["Cracklin_01"], rate: 0.95, amp: 0.2
    sleep sample_duration(Mountain["Cracklin_01"], rate: 0.95)
end;end

live_loop :foo do;with_fx :level, amp: 0.5 do
    density(@polyrhythm.sort.first) do
      sample Mountain["pebble",0], start: rrand(0.0,0.01), rate: -1.0, amp: 0.4

comment do
      with_synth(:dark_ambience){play (knit
       "Fs4",1,_,1,"Fs2",6,
       "B4", 1, "Ds5",1, "Bs2",6,
       "Ds5",1,_,1,"Ds2",6
).tick(:a), cutoff: 80, amp: 0.5, release: 2*bar, attack: 0.01}
end

##       "Fs4",1,_,1,"Fs2",6,
#         "Fs3",1
#).tick(:a), cutoff: 80, amp: 0.5, release: 2*bar, attack: 0.01}

      #play (knit "Fs2",2).tick(:a), amp: 1.5, release: bar/6.0, attack: 0.1
      
      with_fx (knit :echo,1,:none, 7).tick(:o), decay: bar*8 do
#      with_synth(:hollow){ play deg_seq(*%w{FS1 111}).tick(:asd)}
      end
sleep bar
end;end;end

#(knit :As4, 4, :B4, 4,:Cs4, 4, :B4, 4).tick
#(ring "Fs4", "As4", "Cs4")
#(knit :Fs4, 7, _, 1,:As4, 7, _, 1)


 # control n, note: (knit :As4, 4, :B4, 4,
 #                        :Cs4, 4, :B4, 4).tick
 # sleep bar/2.0

# 3 ->  4   AS4 - > B4

# 1    3    1    4    3    5    3     4  
#FS4->AS4  FS4->B4   AS4->CS4  *AS4->B4*

live_loop :drifty do; with_fx :level, amp: 1.0 do
  1.times {sync :foo}
  density(@polyrhythm.sort.last) do
  with_fx :reverb, room: 1.0, mix: 1.0, damp: 0.1 do |fx_r|
    with_fx (knit :none,7, :echo, (ring 7).tick(:d)).tick(:r2), mix: 0.8, phase: bar/2.0 do
      n = (knit
        (stretch invert_chord(chord(:As3,:m)[0..1], 0),1), 12,              #3
        (stretch invert_chord(chord(:As3,:m), 0),1), 12,                    #3
#HIT 1 3 FS3-AS4
        (stretch invert_chord(chord(:Cs3,:M)[1..-1], 1),1), 12,             #5
        (stretch invert_chord(chord(:Cs3,:M), 1),1), 12,                    #5
#HIT FS3-AS4
        (stretch invert_chord(chord(:Ds4,:m), -2),1), 20,                   #6
         _, 4,
#HIT FS4-B4
        (stretch invert_chord(chord_degree(7, :Fs3, :major,3), -2),1), 20,  #7
         _, 4,
#HIT FS4-B4
        (stretch invert_chord(chord(:Es3,'dim'), 1),1), 10,                 #7
        (stretch invert_chord(chord(:Es3,'dim'), 1),1), 10,                 #7
         _, 4,
#HIT AS4-CS4
        (stretch invert_chord(chord(:Fs3,'sus4'), -1),1), 20,               #1
         _, 4,    
#HIT AS4-CS4
        (stretch invert_chord(chord(:Fs3,:M), -1),1), 20,                   #1 
         _, 4,
#HIT AS4-B4
        (stretch invert_chord(chord(:B4,:M), -2)[0..2],1), 10,              #4 
        (stretch invert_chord(chord(:B4,:M), -3)[0..2],1), 10,              #4 
         _,4,
#HIT AS4-B4
).tick(:asb)
  puts (n||[]).map{|a|note_info(a).midi_string}
      #n = (stretch chord(:Fs3, 'sus4'),1, chord(:Fs3, "M"),1,
      #             chord(:As3, 'sus4'),1, chord(:As3, 'M'),1)

puts "#{(n||[]).map{|a|note_info(a).midi_string}  ==  (ring "Fs4", "B4", "Eb4")}"

if (n||[]).map{|a|note_info(a).midi_string} == (ring "Fs4", "B4", "Eb4")
  cue :bhit 
end
#with_transpose(-12){with_synth(:sine){play (n ? n.sort[0] : n), cutoff: 60, pan: (Math.sin(vt*13)/1.5), amp: (ring 0.25).tick(:sdf), decay: 0.1 + rrand(0.1,0.2), release: 0.01}}
      with_synth(:beep){play n, pan: (Math.sin(vt*13)/1.5), amp: (ring 0.25).tick(:sdf), decay: 0.1 + rrand(0.1,0.2), release: 0.3} #, release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)
      sleep bar
    end
  end
end
end
end
live_loop :bithit do
  9.times{sync :bhit}
  with_fx (ring :none, :echo).tick, decay: bar*8 do
    sample Frag[/coil/i,/f#/i,1], amp: 0.5
  end
end

live_loop :bassline do |idx|;with_fx :level, amp: 0.5 do
with_fx :reverb, mix: 0.2, damp: 0.3 do |fx_reverb|; with_fx :distortion, mix: 0.1  do
    3.times{sync :foo}
     notes = (knit 
                   chord(:As1,:m,    invert: 2)[0], 1,
                   :Cs2, 2,
                   chord(:Ds2,:m,    invert: 0)[0], 2,
                   chord(:Es1, 'dim',invert: 0)[0], 2,
                   chord(:Es1,'dim', invert: 2)[0],2,
                   :Fs1,2,_,1,
                   :Fs2,1,
                   chord(:B1,:M,     invert: -1)[0],3,
)

    n = notes.tick(:a)

    sleep bar/2.0

    (ring 1,0).tick(:double).times do
      sample Mountain["kick",(ring 7,8).tick(:kicker)], amp: 3.0
       with_synth [:pnoise, :prophet][0] do
      play n, amp: 0.7, release: (knit bar,1).tick(:Bass), attack: 0.01, cutoff: 60
    end
    end

    1.times{sync :foo}

    with_transpose(12) do
    with_synth(:beep){
      play n, cutoff: 60, res: 0.5, release: (knit 2.5*bar,10, 8.0*bar,1,    5.0*bar,2,     5.0*bar,1, 2.5*bar,1, 2.5*bar,1).tick(:sd), 
                                     attack: (knit 0.01,10,    0.15,1,        0.15,2,        0.25,1,    0.25,1,     0.01,1,).tick(:att),
                                     amp:    (knit 0.5,13, 0.2, 3).tick(:ampe)
   }
    end

    with_transpose(0) do
    with_synth :beep do
      play n, amp: 1.0, release: (knit 2.01*bar, 9, 8.02*bar, 2, 2.1*bar,5).tick(:Bass), attack: 0.05, cutoff: 60,  res: 0.5
    end;end
    #use_synth :prophet
    6.times{
    control fx_reverb, damp: (rrand 0.0,1.0) 
    sleep bar/8.0
    }
comment do
notes = (knit
"Cs3",2, "Gs2",2, "As2",2,
"Cs3",2, "Gs2",2, "As2",2,
"B2",2,  "Gs2",2, "As2",2,
).tick(:a)
 play notes, amp: 0.3, release: (knit 3.9*bar,5, bar*4.1,1).tick(:lpo), attack: 0.01
 with_transpose(-12) do
   with_synth(:beep){play notes, amp: 0.2, release: 4*bar, attack: 0.01, cutoff: 60}
 end;end;end
end
idx+=1
end;end

live_loop :highlight do |idx|;with_fx :level, amp: 1.0 do
    n = chord_seq(*%w{Cs3 7 Fs3 M B3 M7})
    with_fx (ring :none, :echo).tick(:a), phase: bar/4.0, decay: (knit bar*8, 3, bar*6,1).tick(:q) do
      with_synth :hollow do
        2.times{sync :foo}
        play n.tick(:f),  attack: 0.5, amp: 2.0
#        with_synth(:pnoise){play n.hook(:f), amp: 0.001}
      end
      1.times{sync :foo}
      with_fx(:slicer, mix: 0.1){
      play n.tick(:f), attack: 0.01, amp: 0.4, release: ring(2.0,0.5).tick(:r3)
      }
      1.times{sync :foo}
    end
end;end

live_loop :high do;with_fx :level, amp: 0.5 do
    2.times{sync :start}
    #with_fx :echo, decay: 16 do  
      sample (knit Mountain["microperc_06"],3,Mountain["microperc_07"],1).tick(:s)
    #end
end;end
