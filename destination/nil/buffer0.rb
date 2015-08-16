["experiments", "log"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}
#                        \:o/ - nil.music.lights
#   π=-    π=-   π=-      █
#  π=-   π=-   π=-      .||.
_ = nil
bar = 1.0
use_bpm 60
set_volume! 0.2
@polyrhythm = [2,3]
load_snippets("~/.sonic-pi/snippets/")

live :next, amp: 0.5 do
  density(@polyrhythm.sort.first) do
    cue :half
    sample Mountain["pebble",0], start: rrand(0.0,0.01), rate: -1.0, amp: 0.4
    sleep bar
  end
end

live :begin, amp: 0.0 do
  sync :next
  comment do
    with_fx :distortion, mix: (knit 0.0,3,1.0,1).tick(:v) do
      sample Ether[/F#/,2], amp: 3.0+rrand(0.0,0.2), rate: -1.0
    end
  end
end

live :bits, amp: 0.0 do
    sync :next
    sample Mountain["Cracklin_01"], rate: 0.95, amp: 0.2
    sleep sample_duration(Mountain["Cracklin_01"], rate: 0.95)
end

live :indeterminism, amp: 0.0 do
  4.times{sync :next}
  
  comment do
    with_fx(:distortion, mix: 1.0, distort: 0.8) do |fx_r|
    with_synth(:hollow) do
      play deg_seq(%w{Fs4 1 3}).tick, decay: bar*2, attack: 4, amp: 0.4, release: 1.0
    end
    notes = dice(6) > 3 ? deg_seq(%w{Fs3 1}) : deg_seq(%w{Fs4 1})
    with_fx(:reverb, room: 0.9) do
      with_synth(:dark_ambience) do
        play notes.tick(:note), decay: bar*6, attack: 1, amp: 1.0, release: 2.0
      end
    end
  end

  4.times{sync :next}
  i_deter(deg_seq(%w{Fs4 1*7 _ 3*7 _}).tick,
          deg_seq(%w{Fs4 34 -5 4}).stretch(4).tick)
end

live :bang, amp: 0.0 do |m_idx|
   sync :next
    case (m_idx%8)
    when 0,4,2,6
     if m_idx % 16 == 0
       with_fx(:echo, decay: 2, pre_amp: 0.3){
       #sample Ether["noise",(ring 12).tick(:noise)], amp: 0.5+rrand(0.0,0.1), rate: (ring 0.7,0.8,1.0).tick
       }
        sample Mountain["subkick",1], amp: 1.0+rrand(0.0,0.2), rate: rrand(0.9,1.0)
     else
        sample Mountain["subkick",0], amp: 1.0+rrand(0.0,0.2), rate: rrand(0.9,1.0)
     end
    when 1,3,4,5
      #sample Ether["snare",3], amp: 0.5+rrand(0.0,0.2), rate: rrand(0.9,1.0)
    when 7
      sample Mountain["Impact_0#{(stretch *(1..5), 16).tick(:b)}"], rate: -1.0,amp: 0.25
    end
    m_idx+=1
end

live :drifting_through_code, amp: 0.0 do
  1.times {sync :next}
  density(@polyrhythm.sort.last) do
  with_fx :reverb, room: 1.0, mix: 1.0, damp: 0.1 do |fx_r|
    with_fx((knit :none,7, :echo,(ring 7).tick(:d)).tick(:r2), mix: 0.8, phase: bar/2.0) do
notes = (knit chord(:As3,:m)[0..1], 12,
              chord(:As3,:m),       12,
              chord(:Cs3,:M, invert: 2).delete_at(1), 12,
              chord(:Cs3,:M, invert: 1), 12,
              chord(:Ds4,:m, invert: -2), 20,
              _, 4,
              chord_degree(7, :Fs3, :major, 3, invert: -2), 20,
              _, 4,
              chord(:Es3,'dim', invert: 1), 10,
              chord(:Es3,'dim', invert: 1), 10,
              _, 4,
              dice(6) > 6 ? chord(:Fs3,'sus4', invert: -1) : chord(:Fs3,'sus4', invert: 0), 20,
              _, 4,
              chord(:Fs3,:M, invert: -1), 20,
              _, 4,
              chord(:B4,:M, invert: -2)[0..2], 10,
              chord(:B4,:M, invert: -3)[0..2], 10,
              _, 4)

n = notes.tick(:asb)
n = chord(:Fs3, 'sus4') + chord(:Fs3, "M") + chord(:As3, 'sus4') + chord(:As3, 'M')
#n = [chord_seq(*%w{Cs3 7 Fs3 M B3 M7}).ring.stretch(2).tick(:notes)]
#n =  chord_seq(*%w{Cs3 7 Fs3 M B3 M7}).ring
#n = knit(chord(:Fs3, 1),2, chord(:Fs2, 1),2, chord(:B3, 1),2).tick(:yum)
#n = [chord_seq(*%w{Fs3 1 Fs2 1 B4 1}).ring.tick(:n)]

puts note_inspect(n)

if (n||[]).map{|a|note_info(a).midi_string} == (ring "Fs4", "B4", "Eb4")
  cue :bhit
end
#with_transpose(-12){with_synth(:sine){play (n ? n.sort[0] : n), cutoff: 60, pan: (Math.sin(vt*13)/1.5), amp: (ring 0.25).tick(:sdf), decay: 0.1 + rrand(0.1,0.2), release: 0.01}}
      i_int(n)
      #i_float(n)
      sleep bar
end;end;end;end

live :recursion, amp: 0.0 do
  9.times{sync :bhit}
  with_fx (ring :none, :echo).tick, decay: bar*8 do
    sample Frag[/coil/i,/f#/i,1], amp: 0.5
  end
end

with_fx :distortion, mix: 0.1 do
with_fx(:pitch_shift, window_size: 4.0) do
live_loop :rumbling_loops, auto_cue: false do |idx|;with_fx :level, amp: 0.0 do
with_fx :reverb, mix: 0.2, damp: 0.3 do |fx_reverb|;
    3.times{sync :next}
comment do
    notes = (knit "Cs3",2, "Gs2",2, "As2",2,
                  "Cs3",2, "Gs2",2, "As2",2,
                  "B2",2,  "Gs2",2, "As2",2)
end

    notes = (knit chord(:As1,:m,    invert: 2)[0], 1,
                  :Cs2,                            2,
                  chord(:Ds2,:m,    invert: 0)[0], 2,
                  chord(:Es1, 'dim',invert: 0)[0], 2,
                  chord(:Es1,'dim', invert: 2)[0], 2,
                  :Fs1,                            2,
                  _,1,:Fs2,1,
                  chord(:B1,:M,     invert: -1)[0],3)

    note = notes.tick(:a)

    puts "BASS[#{note_info(note||0)}]"

    sleep bar/2.0
    #(ring 1,0).tick(:ti).times{with_fx(:pitch_shift, mix: 1.0, pitch: 0.025){with_fx(:slicer, mix: 0.5, phase: 0.025, probability: 0.5){sample Heat[/stacked_bells/i,note_to_sample(notes.reverse.look(:a),1)], amp: 1.5, attack: 0.2}}}
    (knit 1,1).tick(:heat).times {with_fx(:reverb){sample Heat[/low_pad/i,note_to_sample(note,1)], amp: 1.0}}

    (ring 1,0).tick(:double).times do
      with_fx(:echo, decay: 2.0){sample Frag[/coil/i, /f#/i].tick(:coil), amp: 0.5}
      #sample Frag[/coil/i,11], amp: 1.0
      with_synth [:pnoise, :prophet][0] do
      play note, amp: 0.7, release: (knit bar,1).tick(:Bass), attack: 0.01, cutoff: 60
    end
    end

    1.times{sync :next}

    i_bass(note)

    6.times{
      control fx_reverb, damp: (rrand 0.0,1.0)
      sleep bar/8.0
    }
end;end
idx+=1
end;end;end

live :tracing_forward_back, amp: 0.0 do
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
end

live :missing_semi_colon, amp: 0.0 do
    2.times{sync :start}
    sample (knit Mountain["microperc_06"],3,Mountain["microperc_07"],1).tick(:s)
end
