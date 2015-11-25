["samples","instruments","experiments", "log", "shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil
with_fx(:reverb, room: 0.8, mix: 0.9, damp: 0.5) do |r_fx|
  live_loop :warm_up do
    #sample Corrupt[/acoustic guitar/, /fx/].tick, cutoff: 75, amp: 1.5, beat_stretch: 8.0
    #sync :organ
    with_fx(:slicer, phase: 0.25*1, probability: 0) do
      with_synth :dark_sea_horn do
        play :e3, cutoff: 60, decay: 8.1, amp: 1.0
      end
    end
    sleep 8
  end
end
shader :iWave, 0.5

live_loop :perc do
  with_fx(:krush, mix: 0.1) do |r_fx|
    with_fx(:slicer, phase: 0.25, probability: 0) do
      #sample Organic[/loop/,/perc/, 2], cutoff: 75, beat_stretch: 16.0, amp: 1.2
    end
  end
  sleep 16
end

live_loop :apeg do
  use_synth :plucked
  with_synth :hollow do
    play :fs3
  end
  #play (ring :fs3, :fs2).tick, decay: 0.25, attack_level: 0.6,amp: 0.0
  sleep (ring 0.25).tick(:l)
end

live_loop :breath do
  with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
    #  sync :organ
    sleep 16+4
    sample Fraz[/coil/,/c#/,0], cutoff: 70, amp: 1.0, rate: 0.5
    sleep 16-4
  end
end

live_loop :fx do
  sync :organ
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    #synth :dsaw, note: :Fs1, cutoff: 40, amp: 0.3, decay: 16, detune: 12
    #synth :prophet, note: :Fs1, cutoff: 40, amp: 0.3, decay: 16, detune: 12
  end
  #sample Organic[/f#/,/strings/,0], amp: 0.5
  sleep 32
end

live_loop :sop do
  sync :organ
  sleep 16
  if spread(1,4).tick(:sop)
    with_fx(:echo, room: 1.0, mix: 0.8, damp: 0.5, decay: 8) do |r_fx|
      sample Sop[ring(/eh/,/ye/).tick(:types),/release/, 3..4].tick(:sop),
        amp: 1.4, cutoff: 100
    end
  end
  sleep 16
end

#This is the Leeds organ. Its lovely...
live_loop :organ do
  with_fx :lpf, cutoff: 135, mix: 1.0 do
    synth :hollow, note: :e3, attack: 1.0, decay: 4.0, amp: 1.0
    with_fx  :bitcrusher, bits: 10, sample_rate: 20000, cutoff: 100, mix: 0.0 do #:distortion, feedback: 0.5, mix: 0.0 do
      slices = [1,2,4].shuffle
      notes = [[/f#2/, /a2/, /c#2/],
               [/a2/, /c#2/, /_e2_/], #/g#2/],
               [/c#2/, /_e2_/, /g#2/],# /_b2_/]
               ].choose

      #notes = [/f#2/, /b2/, /cs2/]

      root = notes[0]
      at do
        with_fx :reverb, room: 1.0, damp: 0  do
          d = [0.1, 0.2, 0.3].choose
          with_fx(:distortion, mix: 0.5, distort: d) do |r_fx|
            sample Instruments[/double-bass/,Regexp.new(root.inspect[1..-2].gsub("#","s").gsub("2","1")),/_25_/,3], amp: 4.0
          end
          sleep 2
          sample Instruments[/double-bass/,Regexp.new(notes[-1].inspect[1..-2].gsub("#","s").gsub("2","2")),/_1_/,3], amp: 0.5
        end
      end

      #with_fx :echo, phase: 0.125 do
      with_fx :slicer, phase: 0.25*2, invert_wave: 1, wave: 0 do
        sample Organ[notes[-1],1], cutoff: 100, amp: 3.5#, pan: Math.sin(vt*13)/1.5
        # sample Organ[/c#1/,1], cutoff: 100, amp: 3.5#, pan:

      end
      #end
      with_fx :slicer, phase: 0.25*4, invert_wave: 0 do
        #  sample Organ[/_d2_/,0], cutoff: 130, amp: 3.5, pan: Math.sin(vt*13)/1.5
      end

      if notes[-1] == /_b2_/
        puts "!@£$%^&*((*&^%$£@!"
        sample Organ[notes[-1],[0,0]].tick(:sample), cutoff: 100, amp: 1.5, attack: 1.0, cutoff_attack: 1.0

        #sample Mountain[/bow/, /B_/].tick(:bow), cutoff: 100, decay: 2, amp: 0.3

        with_fx :echo, decay: 8.0 do
          with_fx(:distortion, mix: 0.1, distort: 0.1) do |r_fx|
            with_fx :reverb, room: 1.0 do
              sample Instruments[/cello/, /pianissimo_arco/, /b2_1/].tick, amp: 3
            end
          end
        end
      end

      sample Organ[/f#0/,[0,0]].tick(:sample), cutoff: 130, amp: 2.5
      with_fx(:slicer, phase: 0.25*slices[0], probability: 0) do
        sample Organ[notes[0],[0,0]].tick(:sample), cutoff: 130, amp: 3.5
      end

      with_fx :echo, phase: 0.25*2 do
        #sample Instruments[/violin/, /fs4_1|a4_1|cs4_1/].tick, amp: 1, attack: 0.5
      end

      synth :dark_ambience, note: (ring :e3, :e4,:fs3).tick, cutoff: 100, decay: 8.0, amp: 1.5, attack: 0.001

      with_fx :slicer, mix: [0.0,0.2].choose do
        with_fx :echo, decay: 8.0 do
          with_fx(:distortion, mix: 0.1, distort: 0.4) do |r_fx|
            with_fx :reverb, room: 1.0 do
              sample Instruments[/cello/, /pianissimo_arco/, /fs2_1|a2_1|cs2_1/].tick, amp: 8
            end
          end
        end
      end

      with_fx(:echo, phase: 0.25*4, decay: 4.0) do
        #sample Frag[/coil/,10], amp: 0.2
        #sample Organic[/kick/,4], amp: 1.5
      end

      with_fx(:slicer, phase: 0.25*slices[1], probability: 0) do
        sample Organ[notes[1],[0,0]].tick(:sample), cutoff: 134, amp: 3.0
      end

      with_fx(:slicer, phase: 0.25*slices[2], probability: 0) do
        sample Organ[notes[2],[0,0]].tick(:sample), cutoff: 134, amp: 2.9
      end
    end
  end
  sleep 8
end
