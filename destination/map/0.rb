["experiments", "log", "shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}
set_volume! 1.0
_=nil

#@s = MountainLoop[/.*/,12]
#use_sample_bpm

define :note_to_sample do |n|
  note_info(n).midi_string.gsub("s", "#").gsub("Eb", "D#").gsub("Ab", "G#")
end

# F♯, G♯, A, B, C♯, D, and E
#use_sample_bpm Fraz[/F#m/i, 0]

r = 1/8.0

live_loop :arp do
  with_synth :prophet do
    n = (knit
         chord(:Fs3, ['m'].choose),     64,
         chord(:Fs3, ['m+5'].choose),   32,
         chord(:Fs3, ['m7+5'].choose, invert: -1),  16,
         chord(:A3, :sus2, invert: 0), 32,

         chord_degree(6, :Fs3, :minor, 3,  invert: -3)[0..2],8,
         chord_degree(6, :Fs3, :minor, 3,  invert: -3),24,
         chord_degree(6, :Fs3, :minor, 3,  invert: -4),32,

         chord_degree(3, :Fs2, :minor, 3,  invert: 1),64,
         chord_degree(4, :Fs2, :minor, 3,  invert: 2),32,
         chord_degree(7, :Fs2, :minor, 3,  invert: 1),32,

#         chord_degree(5, :Fs3, :minor, 3,  invert: -3),32,
#         chord_degree(5, :Fs3, :minor, 3,  invert: -4),32,
#         chord_degree(7, :Fs3, :minor,  3, invert: -2),16,
#         chord_degree(7, :Fs3, :minor,  3, invert: -1),16,
#         chord_degree(7, :Fs3, :minor,  3, invert: 0),32,
#         chord(:Fs4, ['m'].choose),     8,
#         chord(:Fs3, ['m'].choose),     8,
#         chord(:Fs4, ['m'].choose),     8,
#         chord(:Fs4, ['m'].choose, invert: -1),  4,
#         chord(:Fs4, ['m'].choose, invert: -2),   4,
).tick(:c)
    #puts note_inspect(n)
comment do
    with_fx(:slicer, phase: 1/2.0, invert_phase: 1, probability: 0.5, mix: 0.0) do
      synth :hollow, note: (knit
                            _,3,
                            chord(:Fs2, 'm'),2,
                            _, 3,
                            _, 3,
                            chord(:Fs2, 'm7+5', invert: 1),2,
                            _, 3
).tick(:hc), amp: 1.0, attack: 0.01, decay: 1.0, release: 0.1, cutoff: 80
end
    end

    with_fx((knit :none,1, :reverb, 0, :none, 0).tick(:fx), decay: 1.0, phase: 1/4.0, room: 0.2) do
      c = (knit  _,1, n[0], 3,
                      n[-1],3, _,1,
                      n[1],2, _,2).tick(:c) #.choose
      with_transpose(0) do
        #synth :prophet,  note: (ring c, _).tick , amp: 1.0, attack: 0.01, cutoff: 60
#        synth :plucked,  note: (ring c,_,_,_).tick , amp: 2.0, attack: 0.01
        shader(:uniform, "iCellMotion", 0.0)
      end

      with_transpose(0){
      with_synth(:fm){
        play (knit n,32).tick(:support), amp: 2, release: 0.2, attack: 0.1, attack_level: 0.5, detune: 12
      }
}
      with_transpose(-12) do
        with_synth(:growl) do
          play (knit n[0],1, _,7).tick(:bass), decay: (1/2.0)*2, release: 0.1, attack: 0.1, amp: 0.6
        end
        with_transpose(0) do
          with_synth(:growl) do
            play (knit :Fs3,1,_,7).look(:bass), decay: 0.5, release: (knit 0.5,8, 0.5,8).tick(:r), attack: 0.001, amp: 0.2, detune: 12
            if (knit n[0],1, _,7).look(:bass)
              with_fx(:slicer, mix: 0.0, phase: 1/1.0, smooth: 0.0, probability: 0.5) do
#                sample Heat[/Low_Pad/i, /#{note_to_sample(n[-1])[0..-2]}1/i], amp: 2.5
                            #puts¯ note_info(n[0]).midi_string.gsub("s", "#").gsub("Eb", "D#").gsub("Ab", "G#")[0..-2]
              end
            end
          end
        end
      end
    end
  end
  sleep 1/8.0
end

live_loop :background do
  sample Ether[/D/i, 0], amp: 2.0, rate: 1.0, pan: (Math.sin(vt*13)/1.5)
  32.times{sync :drum}
end

@cell_count = 0
live_loop :drum do |e_idx|
#  sample Heat[/F#/i,1], amp: 1.0
 # sample Heat[/C/i,1], amp: 1.0
  puts e_idx % 16
  if(e_idx % 4 == 0)
    @cell_count += 1
    shader(:uniform, "iCellCount", 2)
  #  sample Fraz[/kick/i, [14,15]].tick(:high), rate: 1.0, amp: 10
  end

  with_fx(:bitcrusher, bits: 10, sample_rate: 30000) do
  (ring 4).tick(:time).times{sync :arp;   shader(:uniform, "iOffBeat",  0.0)}
  with_fx((knit :none,3, :none,1).tick(:f), mix: 0.5, decay: 0.5, phase: 1/2.0) do |x_fx|
#      sample Frag[/kick/i, [1,1,1,1]].tick(:drums), rate: 1.0, amp: 4.0
   #shader(:uniform, "iBeat",  1.0)

  end
  (ring 4).tick(:time).times{sync :arp;    shader(:uniform, "iBeat",  0.0)
}

#  sample Frag[/snap/i, [0,0,0,0,1,1,1,1]].tick(:snap), rate: 1.0, amp: 2.0, start: (rrand 0.0,0.1)
  #sample Frag[/noise/i, [0,0,0,0,1,1,1,1]].tick(:snap), rate: 1.0, amp: 2.0, start: (rrand 0.0,0.1)
 # sample Fraz[/kick/i, [0,9]].tick(:snares), rate: 1.0, amp: 10.0
 # sample Fraz[/snap/i, [0,0,0,0,1,1,1,1]].tick(:snap), rate: 1.0, amp: 2.0, start: (rrand 0.0,0.1)
  #shader(:uniform, "iOffBeat",  1.0)

end
e_idx+=1
end

live_loop :hats do |idx|
  sync :arp
  m = [0.3,0.2,0.1, 0.4].choose
  sample Fraz[/coil/i, 0], amp: 1.0 if idx % 32 == 0

  4.times{
   with_fx(:bitcrusher, bits: (ramp *(7..24).to_a.reverse).tick(:fxkc)) do
      with_fx(:reverb, room: 0.3, mix: m) do
#        with_fx(:slicer, phase: 0.025, probability: 0.5, mix: m) do
         sample Frag[/hat/i, Range.new(0,(ring 2,4).tick(:cr))].tick(:d), start: rrand(0.0,0.1), rate: 1.0, amp: 2.0
end
#        end
      end
  sleep 1/8.0}
  idx+=1
end

# F♯, G♯, A, B, C♯, D, and E


#live_loop :perc do
#  sample Frag[/coil/i,"D",2], amp: 1.0
 # 32.times{sync :arp}
#  sample Frag[/coil/i,"F#",2], amp: 1.0
 # 32.times{sync :arp}
#end
