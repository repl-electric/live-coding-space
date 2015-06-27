["experiments.rb"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}"}
#                        \:o/
#   π=-    π=-   π=-      █
#  π=-   π=-   π=-      .||.
_ = nil#.go
bar = 1.0
use_bpm 60
set_volume! 3.0
@polyrhythm = [2,3]

def sam(n, oct=1)
  if n
 n = n.is_a?(Integer) ? note_info(n).midi_string : n
 n = n.to_s
 n = n.split(/\d/)[0]
 n = n == "Eb" ? "Ds" : n
 n = n.gsub("s","#")
    /#{n}#{oct}/i
  else
   false
  end
end

live_loop :begin, auto_cue: false do
  sync :next
  with_fx :distortion, mix: (knit 0.0,3,1.0,1).tick(:v) do
  #sample Ether.all(/F#/)[2], amp: 3.0+rrand(0.0,0.2), rate: -1.0
  end
end

live_loop :bits, auto_cue: false do;with_fx :level, amp: 0.6 do
    sync :next
    sample Mountain["Cracklin_01"], rate: 0.95, amp: 0.2
    sleep sample_duration(Mountain["Cracklin_01"], rate: 0.95)
end;end

live_loop :indeterminism, auto_cue: false do
8.times{sync :next}
with_fx :distortion, amp: 0.8, mix: 0.3 do
with_synth :beep do
with_fx (knit :echo,2, :reverb,2).tick(:fx), decay: 4.0, room: 1.0 do |fx_verb|
  n = play (knit :Fs4, 7, _, 1,
                 :As4, 7, _, 1
).tick, amp: 0.3

  if dice(32) == 1
     with_fx :pan, pan: Math.sin(vt*13)/1.5 do
     with_fx :bitcrusher, bits: 7, sample_rate: 32000 do
     #sample Mountain[/bow/i, /f#/i, 0],amp: 0.4
  end;end;end

  sleep bar/4.0
  control n, note: (knit :As4, 4, :B4, 4,
                         :Cs4, 4, :B4, 4).tick
 2.times{
  sleep bar/4.0
  if fx_verb.name =~ /reverb/
  control fx_verb, damp: rrand(0.0,1.0)
 end}
end;end;end;end

live_loop :bang, auto_cue: false do |m_idx|;with_fx :level, amp: 0.5 do
   sync :next
    case (m_idx%8)
    when 0,4,2,6
     if m_idx%16 == 0
       with_fx(:echo, decay: 2, pre_amp: 0.3){
         sample Ether["noise",(ring 12).tick(:noise)], amp: 0.5+rrand(0.0,0.1), rate: (ring 0.7,0.8,1.0).tick
       }
       #sample Mountain["subkick",1], amp: 1.0+rrand(0.0,0.2), rate: rrand(0.9,1.0)
     else
     #sample Mountain["subkick",0], amp: 1.0+rrand(0.0,0.2), rate: rrand(0.9,1.0)
     end
    when 1,3,4,5
      #sample Ether["snare",3], amp: 0.5+rrand(0.0,0.2), rate: rrand(0.9,1.0)
    when 7
      #sample Mountain["Impact_0#{(stretch (1..5).to_a, 16).tick(:b)}"], rate: -1.0,amp: 0.25
    end
    m_idx+=1
end;end

live_loop :next do;with_fx :level, amp: 0.5 do
    density(@polyrhythm.sort.first) do
      #sample Mountain["pebble",0], start: rrand(0.0,0.01), rate: -1.0, amp: 0.4

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

# 1    3    1    4    3    5    3     4
#FS4->AS4  FS4->B4   AS4->CS4  *AS4->B4*

live_loop :drifting_through_code, auto_cue: false do; with_fx :level, amp: 2.0 do
  1.times {sync :next}
  density(@polyrhythm.sort.last) do
  with_fx :reverb, room: 1.0, mix: 1.0, damp: 0.1 do |fx_r|
    with_fx (knit :none,7, :echo, (ring 7).tick(:d)).tick(:r2), mix: 0.8, phase: bar/2.0 do
      n = (knit
        (stretch invert_chord(chord(:As3,:m)[0..1], 0),1), 12,        #3
        (stretch chord(:As3,:m, invert: 0),1), 12,                    #3
#HIT 1 3 FS3-AS4
        (stretch invert_chord(chord(:Cs3,:M)[1..-1], 1),1), 12,       #5
        (stretch chord(:Cs3,:M, invert: 1),1), 12,                    #5
#HIT FS3-AS4
        (stretch chord(:Ds4,:m, invert: -2),1), 20,                   #6
         _, 4,
#HIT FS4-B4
        (stretch chord_degree(7, :Fs3, :major, 3, invert: -2),1), 20, #7
         _, 4,
#HIT FS4-B4
        (stretch chord(:Es3,'dim', invert: 1),1), 10,                 #7
        (stretch chord(:Es3,'dim', invert: 1),1), 10,                 #7
         _, 4,
#HIT AS4-CS4
        (stretch dice(6) > 3 ? chord(:Fs3,'sus4', invert: -1) : chord(:Fs3,'sus4', invert: 0),1), 20,          #1
         _, 4,
#HIT AS4-CS4
        (stretch chord(:Fs4,:M, invert: -1),1), 20,                   #1
         _, 4,
#HIT AS4-B4
        (stretch chord(:B4,:M, invert: -2)[0..2],1), 10,              #4
        (stretch chord(:B4,:M, invert: -3)[0..2],1), 10,              #4
         _,4,
#HIT AS4-B4
).tick(:asb)

#n = (stretch chord(:Fs3, 'sus4'),1, chord(:Fs3, "M"),1,
#             chord(:As3, 'sus4'),1, chord(:As3, 'M'),1)

if (n||[]).map{|a|note_info(a).midi_string} == (ring "Fs4", "B4", "Eb4")
  cue :bhit
end
#with_transpose(-12){with_synth(:sine){play (n ? n.sort[0] : n), cutoff: 60, pan: (Math.sin(vt*13)/1.5), amp: (ring 0.25).tick(:sdf), decay: 0.1 + rrand(0.1,0.2), release: 0.01}}
      with_synth(:beep){play n, pan: (Math.sin(vt*13)/1.5), amp: (ring 0.25).tick(:sdf), decay: 0.1 + rrand(0.1,0.2), release: 0.3} #, release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)
      #with_synth(:prophet){play n, cutoff: 70, attack: 0.01, pan: (Math.sin(vt*13)/1.5), amp: 0.5, decay: 0.1 + rrand(0.1,0.2), release: (ring 1.0,0.25,0.4,0.25).tick(:dasd)}
      sleep bar
    end
  end
end
end
end

live_loop :recursion, auto_cue: false do
  9.times{sync :bhit}
  with_fx (ring :none, :echo).tick, decay: bar*8 do
    sample Frag[/coil/i,/f#/i,1], amp: 0.5
  end
end

live_loop :rumbling_loops, auto_cue: false do |idx|;with_fx :level, amp: 0.5 do
with_fx :reverb, mix: 0.2, damp: 0.3 do |fx_reverb|; with_fx :distortion, mix: 0.1  do
    3.times{sync :next}
     notes = (knit
                   chord(:As1,:m,    invert: 2)[0], 1,
                   :Cs2, 2,
                   chord(:Ds2,:m,    invert: 0)[0], 2,
                   chord(:Es1, 'dim',invert: 0)[0], 2,
                   chord(:Es1,'dim', invert: 2)[0],2,
                   :Fs1,2,
                   _,1,:Fs2,1,
                   chord(:B1,:M,     invert: -1)[0],3)

    n = notes.tick(:a)
    sleep bar/2.0
    #(ring 1,0).tick(:ti).times{with_fx(:pitch_shift, mix: 1.0, pitch: 0.025){with_fx(:slicer, mix: 0.5, phase: 0.025, probability: 0.5){sample Heat[/stacked_bells/i,sam(notes.reverse.look(:a),1)], amp: 1.5, attack: 0.2}}}
    (knit 1,1).tick(:heat).times {with_fx(:reverb){sample Heat[/low_pad/i,sam(n,1)], amp: 1.0}}

    (ring 1,0).tick(:double).times do
      with_fx(:echo, decay: 2.0){sample Frag[/coil/i, /f#/i].tick(:coil), amp: 0.5}
      #sample Frag[/coil/i,11], amp: 1.0
      with_synth [:pnoise, :prophet][0] do
      play n, amp: 0.7, release: (knit bar,1).tick(:Bass), attack: 0.01, cutoff: 60
    end
    end

    1.times{sync :next}

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

live_loop :tracing_forward_back, auto_cue: false do |idx|;with_fx :level, amp: 0.0 do
    n = chord_seq(*%w{Cs3 7 Fs3 M B3 M7}).ring
    with_fx (ring :none, :echo).tick(:a), phase: bar/4.0, decay: (knit bar*8, 3, bar*6,1).tick(:q) do
      with_synth :hollow do
        2.times{sync :next}
        play n.tick(:f),  attack: 0.5, amp: 2.0
#        with_synth(:pnoise){play n.look(:f), amp: 0.001}
      end
      1.times{sync :next}
      with_fx(:slicer, mix: 0.1){
      play n.tick(:f), attack: 0.01, amp: 0.4, release: ring(2.0,0.5).tick(:r3)
      }
      1.times{sync :next}
    end
end;end

live_loop :missing_semi_colon, auto_cue: false do;with_fx :level, amp: 0.5 do
    2.times{sync :start}
      sample (knit Mountain["microperc_06"],3,Mountain["microperc_07"],1).tick(:s)
end;end