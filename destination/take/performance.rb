with_fx(:reverb, room: 0.6, mix: 0.8, damp: 0.5, damp_slide: 1.0, mix_slide: 0.1) do |r_fx|
  with_fx :level, amp: 1.0 do
    live_loop :softer, sync: :kick do
      score =  ring( 8, 8, 8, 8, 8, 16, 8)
      n = score.tick
      blah = nil
      with_fx :slicer, phase: 0.25, wave: 0 do
        with_fx :pitch_shift, time_dis: 0.9, window_size: 0.9, mix: 0.5, pitch_dis: 0.1  do
          with_fx :wobble, phase: 32, mix: 1 do
                     with_fx :echo, decay: 16, phase: 0.125 do
            #blah=synth :dark_sea_horn, note: (ring :E2).look, decay: 16, cutoff: 100, amp: 0.2
            smash_loop(smash(Sop[/sustain/,[0..3]].tick(:sample),[8.0,16.0,16.0,16.0,16.0,16.0,16.0]), amp: 2.0, cutoff: 130, pitch: (ring 2, 3, 2, 0).look(:sample))
                    end
          end
        end
      end
      comment do
        with_fx :slicer, invert_wave: 1, phase: 0.5, wave: 0 do
          blah=synth :dark_sea_horn, note: (ring :Gs2).look, decay: 16, amp: 1.0
        end
        
        with_fx :slicer, invert_wave: 1, phase: 0.25, wave: 0 do
          blah=synth :dark_sea_horn, note: (ring :B2).look, decay: 16, amp: 1.0
        end
      end
      with_fx :krush, mix: 0.05, mix_slide: 2 do |k_fx|
        n.times{|idx|
          #sample Sop[/Polysustains/, /release/, /01_oos/, /00/, 0], amp: 12.0
          with_fx :krush, mix: 0.2, sample_rate: 20000 do
            #sample Bass[/Polysustains/,/Omni/, /whisper/].tick, amp: 4.0# if idx <= 4
            # synth :gpa, note: :Fs4, attack: 0.01, release:  ring(0.125, 0.25).tick(:r), amp: 1.0
            #with_fx :reverb do
            #sample Alt[/Polysustains/, /release/, /f#/].tick(:sopnotes3), amp: 12.0# if idx <= 4
            #           sample Sop[/Polysustains/, /release/, /01_oos/, /f#3|e3|d3/].tick(:sopnotes), amp: 1.0 if idx <= 4
            #          sample Sop[/Polysustains/, /release/, /01_oos/, /f#4|e4|d4/].tick(:sopnotes2), amp: 2.1, rate: 1 if idx >= 4 && idx < 8
            #end
          end
          sleep 1
          control k_fx, mix: 0
          control blah, note: :FS1 if rand > 0.5
        }
      end
    end
  end
end

_=nil
def note_slices(note, m)
  NoteSlices.find(note: note, max: m, pat: "sop|alto|bass").select{|s| s[:path] =~ /sop|alto/}.take(16)
end
@slices ||= {"Gs2/4" => note_slices("Gs2",1/4.0),"D2/4" => note_slices("D2",1/4.0), "E2/4" => note_slices("E2",1/4.0), "A2/4" => note_slices("A2",1/4.0), "Fs2/4" => note_slices("F#2",1/4.0), "E3/4" => note_slices("E3",1/4.0), "D3/4" => note_slices("D3",1/4.0),"D3/8" => note_slices("D3",1/8.0),"Cs3/4" => note_slices("C#3",1/4.0), "Fs3/8" => note_slices("F#3",1/8.0),"Fs3/4" => note_slices("F#3",1/4.0), "Gs3/4" => note_slices("G#3",1/4.0), "A3/8" => note_slices("A3",1/8.0),"A3/4" => note_slices("A3",1/4.0), "B3/4" => note_slices("B3",1/4.0), "Cs4/4" => note_slices("C#4",1/4.0), "Cs4/8" => note_slices("C#4",1/8.0), "D4/4" => note_slices("D4",1/4.0),"D4/8" => note_slices("D4",1/8.0), "E4/4" => note_slices("E4",1/4.0),"E4/8" => note_slices("E4",1/8.0), "Fs4/4" => note_slices("F#4",1/4.0),"Fs4/8" => note_slices("F#4",1/8.0), "Gs4/4" => note_slices("G#4",1/4.0), "B4/4" => note_slices("B4",1/4.0),"Fs5/4" => note_slices("F#5",1/4.0), "Fs6/4" => note_slices("F#6",1/4.0),"A4/4" => note_slices("A4",1/4.0),"E5/4" => note_slices("E5",1/4.0)}
@slices.values.flatten.each{|f| load_sample f[:path]}
puts @slices.values.flatten.count
live_loop :back2 , sync: :drums do
  d = nil;di=nil
  with_fx :slicer, phase: 1/8.0, wave: 0, probability: 1.0 do
    with_fx :wobble, phase: 32 do
      #di = synth :dark_sea_horn, note: :Fs1, amp: 0.2, decay: 32#, cutoff: 40https://trello.com/c/OLYGPbnk/47-sample-lib-and-vsti-workflow
      #d = synth :dsaw, note: :Fs2, amp: 1.0, decay: 32#, cutoff: 13https://trello.com/c/OLYGPbnk/47-sample-lib-and-vsti-workflow0
    end
  end
  with_transpose (ring 12,5,5+3,0).look do
    32.times{
      sleep 1
      #control di, note: (ring :Fs1,:A1,:Fs1,:A1, :B1,:B1).tick(:a2sd)
      #control d, note: (ring :Fs1,:A1,:Fs1,:A1, :B1,:B1).tick(:asd)
    }
  end
  
end
live_loop :drums, sync: :kick do
  tick
  magic= ring(           *%w{_ _ _ _ [18,18,19] _ _ _
                             _ _ _ _ _ _ [16,16,17] _
                             _ _ _ _ [19,19,18] _ _ _
                             _ _ _ _ _ _ [34,34] _}
                         ).look
  
  drum= ring(            *%w{ [18,18,20] _ _ _ [18,18,20] _ _ _
                              [18,18,20] _ _ _ [16,16,17] _ _  _
                              [18,18,20] _ _ _ [20,20,18] _ _ _
                              [18,18,20] _ _ _ [34,34] _ _  _}
                         ).look
  
  with_fx :lpf, cutoff: (line 80, 115, steps: 32).look do
    if spread(1,8, rotate: 0).look
      sample Frag[/hat/,[0,0]].look, rpitch: (ring 12*1,12*2,12*1).look, amp: 0.8+rand*0.1#, cutoff: 40
    end
    if spread(1,16, rotate: 1).look
      smp Frag[/hat/,[1,1]].look, rpitch: (ring 12*1,12*2,12*1).look, amp: 0.8+rand*0.1# ,cutoff: 80
    end
    if spread(1,16, rotate: 0).look
      smp @slices["Fs4/8"][0], rpitch: (ring 7*-1, 12*0, 12*0).look, amp: 1#, cutoff: 40
    end
  end
  if spread(1,64,rotate: 0).look # F# G G# A A# B C C# D D# E F
    smash_loop(smash(@slices["Fs4/8"][0][:path], [4,16,16,16,16]), rpitch: (ring 12, 5, 5+2,0).tick(:progrress), cutoff: 80, amp: 1.0) #   (F#5->B)  => (A#5->E) => (A#5->E)
    smp @slices["Fs4/8"][0][:path], rpitch: (ring 12, 5, 5+2,0).tick(:progrress), cutoff: 80, amp: 1.0 #   (F#5->B)  => (A#5->E) => (A#5->E)
    
    at do
      sleep 1
      #sample "/Users/josephwilk/Workspace/music/samples/melodyne/vor_alto_leg_oo_05_d_F#_D.wav", amp: 2.0
      #sample Alt[/vor_alto_leg_oo_05_d_03/,0], amp: 2       #G# -> C#
      #sample Alt[/vor_alto_leg_oo_05_d_09/,0], amp: 2       #G# -> C#
      
      #sample Alt[/vor_alto_leg_oo_05_d_08/,0], amp: 2       #F# -> B
      #sample Alt[/vor_alto_leg_oo_05_d_02/,0], amp: 1        #F# -> B
      
      #sample Alt[/vor_alto_leg_oo_05_d_01/,0], amp: 2       #E -> A
      #sample Alt[/vor_alto_leg_oo_05_d_07/,0], amp: 2       #E -> A
      
      #sample Alt[/vor_alto_leg_oo_05_d_06/,0], amp: 2       #D -> G???
    end
  end
  if drum != "_"
    matches = drum.match(/(.*)(\[.*\])/)
    pat = matches[1].empty? ? "kick" : matches[-2]
    selection = matches[-1]
    s = Fraz[pat,eval(selection)].tick(:sample)
    #smp (knit _,8,Frag[/hihats/,0],1,_,7).look, cutoff: 120, amp: 1#(ring -3.0,0,-1).look
    smp s, cutoff: (line 100, 80, steps: 32).look/1.0, rpitch: (ring -5,-1,-1).look, amp: 0.8+rand*0.1
  end
  with_fx :pan, pan:  ring(0.25,-0.25).look do
    #control e_fx, phase: knit(0.0,31, 0.25,1).look
    s = MagicDust[/_HI/,eval(magic)].tick(:s2)
    smp s, amp: 1.5+rand*0.1, rate: 1.0, cutoff:  ring(*range(70, 105, 5)).look
    #    s = Fraz[/kick/,[0,1]].look(:s2)
    if magic != "_"
      with_fx (knit :none, 31, :echo, 1).look, decay: 4 do
        #       smp s, amp: 1.0+rand*0.1, rate: 1.0, cutoff: ring(*range(70, 105, 5)).look, rpitch: (ring -5.0,0,-1).look
      end
    end
  end
  sleep 1/8.0
end

#sleep 32
with_fx :echo, mix: 0.8, phase: 0.25 do |e_fx|
  live_loop :skitter, sync: :kick do
    with_fx :level, amp: 1.0 do
      tick
      idx2= ring(            *%w{9 1 1 _ 1 _ 1 _ 1 _ _ _ 1 _ _ _
                                 }
                             ).look
      idx2= ring(            *%w{2 2  _ _  3 _   _ _    1 _  _ _  _ _  _ _
                                 1 1  _ _  _ _   _ _    1 _  _ 1  _ _  _ _
                                 1 1  _ _  _ _   _ _    1 _  _ _  _ _  _ _
                                 1 1  _ _  _ _   1 _    1 _  _ 1  _ _  _ _
                                 
                                 3 3  _ _  2 _   _ _    1 _  _ _  1 _  _ _
                                 1 1  _ _  _ _   _ _    1 _  _ 2  _ _  _ _
                                 1 1  _ _  _ _   _ _    1 _  _ _  _ _  _ _
                                 1 1  _ _  _ _   1 _    1 _  1 1  _ _  _ _
                                 }
                             ).look
      s = nil
      control e_fx, phase: ring(0.25, 0.0, 0.125,  0.0).look*2
      control e_fx, decay: 2.0
      if idx2 != "_"
        with_fx :hpf, cutoff: 80, mix: 1.0 do
          with_fx :bitcrusher, mix: (line 0.0, 1.0, steps: 32).look, bits: (line 4,8,steps: 32).look do
            #with_fx :echo, mix: 0.9, decay: 8.0 do
            score =  knit(
              "Fs4/4",4, "Fs3/4",4, "Fs3/4",4, "Fs3/4", 4,
              "Fs3/4",4, "A3/4",4, "A3/4",4, "A3/8", 4,
              "Fs3/4",4, "A3/4",4, "A3/4",4, "A3/8", 4,
              "A3/4",4,  "A3/4",4, "A3/4",4, "A3/8", 4,
              
              #              "Fs4/4",4, "Fs3/4",4, "Fs3/4",4, "Fs3/4",4,      #F#=>C#  C# D D# E F F# G G# A
              #             "Fs3/4",4, "A3/4",4, "A3/4",4, "A3/4", 4,
              #            "Fs3/4",4, "A3/4",4, "Fs3/4",4, "Fs3/4",4,
              #           "Fs3/4",4, "A3/4",4, "A3/4",4, "A3/4", 4,
              #          "Fs3/4",4, "A3/4",4, "Fs3/4",4, "Fs3/4",4,
              #         "Fs3/4",4, "A3/4",4, "A3/4",4, "A3/4", 4,
              #        "A3/4",4, "Fs3/4",4, "Fs3/4",4, "Fs3/4",4,
              #"Fs3/4",4, "A3/4",4, "Fs3/4",4, "Fs3/4", 4,
            )
            set = @slices[score.look]
            if set
              s = set[eval(idx2)]
              bits = (ring [ratio_off(s)-0.05,  ratio_on(s)], [ratio_on(s)-0.05,  ratio_off(s)])
              bits = bits.look#.shuffle
              smp s, amp: ring(*range(0.68, 2.0, 0.01)).look*4, cutoff: ring(*range((rand > 0.5 ? 95 : 95), 135, 5)).look, pan: ring(0.25,-0.25).look,
                rpitch: (knit 5,4,5+2,4,0,4, 5,4,5+3,4,0,4).look*0#, finish: bits[0], start: bits[1]
              #               rpitch:  knit(note_to_semi(score.look[0..-3], :Cs3),4, note_to_semi(score.look[0..-3], :B3),4, note_to_semi(score.look[0..-3], :A3),4, note_to_semi(score.look[0..-3], :Gs3),4,
              #rpitch:  knit(note_to_semi(score.look[0..-3], :E4),4, note_to_semi(score.look[0..-3], :D3),4, note_to_semi(score.look[0..-3], :Cs3),4, note_to_semi(score.look[0..-3], :Fs4),4,
              #              note_to_semi(score.look[0..-3], :E3),4, note_to_semi(score.look[0..-3], :D3),4, note_to_semi(score.look[0..-3], :B3),4, note_to_semi(score.look[0..-3], :Fs4),4,
              #              note_to_semi(score.look[0..-3], :E3),4, note_to_semi(score.look[0..-3], :D3),4, note_to_semi(score.look[0..-3], :B3),4, note_to_semi(score.look[0..-3], :Fs4),4,
              #              note_to_semi(score.look[0..-3], :E3),4, note_to_semi(score.look[0..-3], :D3),4, note_to_semi(score.look[0..-3], :B3),4, note_to_semi(score.look[0..-3], :Fs4),4,
              #              ).look
            else
              puts "none for #{score.look}"
            end
            #end
          end
        end
      end
    end
    sleep 1/8.0
  end
end

_=nil;set_volume! 1.0;use_bpm 60;set_mixer_control! lpf: 135
with_fx(:reverb, room: 0.6, mix: 0.8, damp: 0.5, damp_slide: 1.0, mix_slide: 0.1) do |r_fx|
  live_loop :soft2, sync: :kick do
    score =  ring([[:E3,8],[:Gs3,8],[:B3,8]],
                  [[:Cs3,8],[:Fs3,8],[:A3,8*2]],
                  [[:Cs4,8],[_,8], [:E4,8],[:E3, -4]],
                  [[:Cs3,16+8], [:E3,16], [:Gs3,16]],
                  [[:A2,8*2], [_,8], [:Fs3,8*3]],
                  [[:D3,8*2],[_,8], [_,8]],
                  [[:B2,8],[_,8],[_,8]],
                  [[:A2,8],[:Cs3,8],[:E3,8]],
                  [[:D3,8],[:Fs3,8],[:A3,8]],
                  [[:B3,8],[:Gs3,8],[:E3,8], [:Cs4,8]],
                  [[:A3,8],[:Fs3,8],[_,8]],
                  [[:Cs3,8],[:Fs3,8*4],[_,8]],
                  [[_,8],[:A3,8*3],[_,8]],
                  [[:Fs2,8*2],[:D3,8],[_,8]],
                  [[:cs3,8],[:A2,8],[_,8]]
                  )
    n = score.tick
    with_fx :krush, mix: 0.5, mix_slide: 4*2 do |k_fx|
      a,s = [],[]
      n.select{|n| n[1] > 0}.each do |note|
        puts note
        #       a = synth :beep, note: note[0], amp: 1.0/n.length
        s << (synth :hollow, note: note[0], decay: note[1], amp: (1.0*2), amp_slide: 0.5, attack: 0.5)
        with_transpose 0 do
          #          synth :pluck, note: note[0], release: n[0][1]/2.0, decay: n[0][1]/2.0, attack: 0.05, amp: 0.5
        end
      end
      (n.map{|s| s[1] > 0 ? s[1] : 0}.select{|s| s!=0}.min).times{|idx|
        control r_fx, damp: rand, mix: 1.0
        s.each{|sy| control sy, amp: rrand(0.8, 1.0)}
        n.select{|n| n[1] < 0}.each do |note|
          if note[1].abs == idx
            #synth :pluck, note: note[0], release: note[1].abs, decay: note[1].abs, attack: 0.1, amp: 0.25
            #synth :hollow, note: note[0], release: note[1].abs, decay: note[1].abs, attack: 0.01, amp: 1.0
          end
        end
        if idx == score.look(offset: 1)[0][1]/2.0
              b = nil
              with_fx :slicer do
                with_transpose 0 do
  #                synth :pretty_bell, note: score.look(offset: 1)[0][0],
   #                 amp: 0.25, decay: ring(2.0,1.0).tick(:itss), attack: 2.0
                end
              end
              end
              sleep 1
    #          control k_fx, mix: 0
              }
              end
              end
              end

              comment do
                (knit (ring :Cs4,:E3, _, _),     32,          #FGAB C D E F   # 6th
                 (ring :B3, :D4,  _, :D4),  32,                         # 4th
                 (ring :A4, :Cs4, _, :cs4), 32,                         # 5th
                 (ring :Gs4,:B3,  _, :E3),  32,
   
                 #32*4
                 (ring :Fs4,:A4,  _, :Cs4), 32*2,                # 1st
                 (ring
                  :Fs4,:a4, _, :Cs4,            #1st +
                  :Fs4, :a4, _,  :Cs4,
                  ), 32,
                 (ring :D4,  :E4,  _, :a3), 32,
                 #32 + 16 + 16
                 (ring :Cs4, :D4,  _, :a3), 16,
                 (ring :B3,  :a3,  _, :A3), 32,
                 (ring :B3,  :a3,  _, :A3), 16)
  
              end

              _=nil
              with_fx :gverb, room: 300, mix: 1.0, spread: 4.0, damp: 1.0, dry: 1.0 do
                live_loop :melody,sync: :kick do
                  tick
                  with_fx :level, amp: 1.0 do
                    score = (knit
                             #32*4
                             #32*4
               
                             (ring :Cs4,:E3, _, _),     32,          #FGAB C D E F   # 6th
                             (ring :B3, _,  _, _),  32,                         # 4th
                             (ring :A4, _, _, _), 32,                         # 5th
                             (ring :Gs4,_,  _, _),  32,
               
                             #32*4
                             (ring :Fs4,_,  _, :Cs4), 32*2,                # 1st
                             (ring
                              :Fs4,_, _, :Cs4,            #1st +
                              :Fs4, _, _,  :Cs4,
                              ), 32,
                             (ring :D4,  _,  _, _), 32,
                             #32 + 16 + 16
                             (ring :Cs4, _,  _, _), 16,
                             (ring :B3,  _,  _, _), 32,
                             (ring :B3,  _,  _, _), 16
               
               
                             )
                    base_s = score.look
                    note = base_s.tick(:n)
                    with_transpose -12*3 do
                      # synth :dsaw, note:    (knit score.look(offset: 1).look(:n),1,_,15,).tick(:bass), decay: 1.0/2.0, release: 4.0, amp: 0.5*1.0, cutoff: 55
                      # synth :prophet, note: (knit score.look(offset: 1).look(:n),1,_,15).tick(:bass2), decay: 1.0/2.0, release: 4.0, amp: 0.25*1.0, cutoff: 50, attack: 0.001
                    end
                    #smp NoteSlices.find(note: "A", octave: 3, max: 1/8.0, min: 1/12.0).take(8).look, amp: 1.0
                    with_fx :distortion, distort: 0.2, mix: 1.0 do
                      if note == :Fs4
                        #smp Mountain[/subkick/,[1,0]].tick(:sample2)
                        #          smp Mountain[/microperc/,[4,5]].tick(:sample2), cutoff: 85, amp: 1.0
                        #         smp Mountain[/perc/,/shot/,/snare/].tick(:sample), cutoff: 80, amp: 1.0
                      end
        
                      s = synth :plucked, note: note, attack: 0.001, release: ring(0.125, 0.25, 0.125, 0.25).tick, amp: 0.8*1, cutoff: (ramp *(range 0,60,0.25)).tick(:entry)
                      with_transpose 12 do
                        #          s = synth :gpa, note: (ring _,_,_,note).look(:n), attack: 0.0001, release: 5.5, amp: 0.5*1#, cutoff: 100
                      end
                      with_transpose 0 do
                        #         synth :dark_ambience, note: (ring note, _,_,_  ,_,_,_).tick(:thing), decay: 1.0, attack: 1.0, amp: 0.2
                      end
                    end
                    high_score = (knit (ring _,_,_,_),(32*4+ 32*4 + 32+32 + 32*3), (ring (chord :E5, "7"),:E4,(chord :E5, "7"), :E4), 32*1,(ring (chord :Fs5,:m),:Fs4,:Fs5, :Fs4), 32*1, (ring :A4,:A3,:A4, :A3), 32*1,
                                  (ring _,_,_,_),(32*2+32+16+16))
                    highlight = high_score.look.tick(:core_bitty)
                    puts highlight if highlight
                    #   s = synth :plucked, note: highlight, attack: 0.1, release: 0.25, amp: 0.2*1, cutoff: 70
                    o = (note.to_s.gsub(/s/,"#").split("")[-1].to_i)
                    #      smp (ring _,_, NoteSlices.find(root: note.to_s.gsub(/s/,"#").split("")[0..-2].join("").upcase, octave: 4, max: 0.25).take(4).tick(:thinga), _).tick(:Baszzzzz), amp: 1.0
                    sleep 1/8.0
                    #      smp NoteSlices.find(note: "A", octave: 3, max: 1/8.0, min: 0.0).take(16).tick(:what), amp: 1.0
                    sleep 1/8.0
                  end
                end
              end
  
  
  
              _=nil
              set_volume! 1.1
              use_bpm 60
              set_mixer_control! lpf: 135
              with_fx(:reverb, room: 0.6, mix: 0.8, damp: 0.5, damp_slide: 1.0, mix_slide: 0.1) do |r_fx|
                live_loop :sofst2, sync: :kick do
                  with_fx :level, amp: 1.0 do
                    score =  ring(# 7 -> 1a -> 3 -> 5 -> 1a -> 6 -> 4
                                  # 3 -> 6 -> 7 -> 1 -> 6 -> 4
                                  [chord(:e3, 'M', invert: 0), 8], [chord(:Fs3, 'm', invert: -1), 8],
                                  [chord(:A3, :M), 8, [:E3, 4]],
                                  [chord(:Cs3, :m, invert: 0), 16], [chord(:Fs3, 'm', invert: -2), 8],
                                  [chord(:D3, :M), 8], [chord(:B2, :m), 8],
                    
                                  [chord(:a2,'M'), 8], [chord(:d3, :M), 8],
                                  [chord(:e3, '6'), 8],
                                  [chord(:Fs3, 'm', invert: 0), 8], [chord(:D3, :M), 8],
                                  [chord(:Cs3, :m, invert: 0), 12],[chord(:Cs3, :M, invert: 0), 4], [chord(:Fs3, 'm', invert: -1), 8],
                                  [chord(:D3, :M), 8], [chord(:B2, :m), 8],
                                  )
                    n = score.tick;
                    sample "/Users/josephwilk/Desktop/bbuk-tuned/zf_bbuk_stacc_#{note_info(n[0][0]).pitch_class.to_s.gsub("s","#")}2_1_r1.wav", amp: 5
                    with_fx :krush, mix: 0.2, mix_slide: 4*1 do |k_fx|
                      d,s = nil
                      s = synth :beep, note: n[0], amp: 1.0
                      #s = synth :dark_sea_horn, note: n[1], decay: n[-1]/2.0 + 5, cutoff: 50
                      #s = synth :beep, note: n[0], release: n[-1]/2.0, decay: n[-1]/2.0 + 5, amp: 1.0*2, amp_slide: 0.5, attack: 0.5
                      s = synth :hollow, note: n[0], release: n[1]/2.0, decay: n[1]/2.0 + 5, amp: 1.0*2, amp_slide: 0.5, attack: 0.5
                      with_transpose 0 do
                        # synth :pluck, note: n[0][0], release: n[1]/2.0, decay: n[1]/2.0+5, attack: 0.05, amp: 1.0
                      end
                      puts "#{note_inspect(n[0])}"
                      n[1].times{|idx|
                        if n[2] && n[2][1] == idx
                          #  synth :hollow, note: n[2][0], release: n[2][1]/2.0, decay: n[2][1]/2.0+5, attack: 0.01, amp: 1.0
                        end
                        if s.respond_to? :sub_nodes
                          #  control r_fx, damp: rand, mix: 1.0; s.sub_nodes.each{|sy| control sy, amp: rrand(0.8, 1.0)}
                        end
                        if idx > score.look[1]-4 && idx < score.look[1]
                          puts note_inspect(score.look(offset: 0)[0])
                          puts note_inspect(score.look(offset: 1)[0])
                          #with_fx :wobble, phase: 1 do
                          with_fx :slicer do
                            with_transpose 0 do
                              #     synth :pretty_bell, note: score.look(offset: 1)[0][0],
                              #      amp: 0.25, decay:  ring(2.0,1.0).tick(:itss), attack: 2.0
                            end
                          end
                          #end
                        end
                        #sleep 1
                        # control k_fx, mix: 0
                      }
                    end
                  end
                end
              end
              live_loop :kick do
                tick
                with_fx :level, amp: 1.0 do
                  bass_score =  ring(#2=> 32 patten
                                     #  A B C -> D    D F A C E G# B        D F A C E
                                     [:D1,1],[:D1,1],   [:E1,1],[:Fs1,1],
                                     [:A0,1.5],[:a0,1], [:Gs0,1],[:Gs0,1],
                                     [:Fs0,1.5],[:Fs0,1], [:Gs0,1],[:E0,1],
                                     [:Fs0,1],[:Fs0,1], [_,1],[_,1],
                                     [:Gs0,1],[:Cs0,1], [:Cs0,1], [:Cs1,1])
                  #      [:E1,1],[:B0,1],[:Gs0,1],[:D1,1]                    )
                  bass_note = bass_score.tick(:b)[0]
                  puts "Bass: #{bass_note}"
                  bass_note = :Fs0
                  #bass_note =  knit(:D1, 4, :E1,4, :Fs1, 4).tick(:internal)
                  if !bass_note
                    #synth :gpa, note:  ring(:Cs4, :fs3).tick(:asdasdasd), decay: 2, amp: 0.8
                  end
                  with_fx :lpf, cutoff: 135, mix_slide: 1.0, mix: 1.0 do |lpf_fx|
                    with_transpose 12*2 do
                      #synth :pluck, note: bass_note+ ring(0,5,-5,-7,5,7).look, decay: 0.25, cutoff: 100, attack: 0.001
                      #synth :gpa, note: bass_note
                      #synth :beep, note: bass_note, amp: 0.05*1, decay: 0.5
                    end
                    decay_rate =  knit(0.5+0.25,1,0.5,3).tick(:ds4) * bass_score.look(:b)[-1]
                    with_transpose 12*1 do
                      #synth :dsaw, note: bass_note, decay: decay_rate, release: 2.0, amp: 0.8*1.0, cutoff: 40
                      #synth :prophet, note: bass_note, decay: decay_rate, release: 4.0, amp: 0.5*1.0, cutoff: 30, attack: 0.001
                    end
      
                    with_fx :distortion, mix_slide: 0.5, mix: 1.0, distort: 0.5 do |dis_fx|
                      if (look(:b) % 8 == 0)
                        control(lpf_fx, mix: 0.0)
                        control(dis_fx, mix: 1.0)
                      else
                        control(lpf_fx, mix: 1.0)
                        control(dis_fx, mix: 0.8)
                      end
        
                      with_fx :reverb, decay: 8.0, damp: 1.0 do
                        with_transpose 12*1 do
                          #synth :prophet, note: bass_note, release: 0.125, attack: 4, amp: 0.4, cutoff: 60
                          #    synth :chipbass, note: bass_note+0.0, amp: 0.013*1, decay: decay_rate, attack: 0.2
                          #synth :chiplead, note: bass_note+0.0, amp: 0.02*1, decay: decay_rate, attack: 0.2
                          #                synth :beep, note: bass_note+0.0, amp: 0.3*1, decay: decay_rate
                        end
                        with_transpose 12*1 do
                          #synth :gpa, wave: 4, note: bass_note, amp: 1.4, decay:  bass_score.look(:b)[-1]*knit(0.25,1,0.125,3).tick(:ds1)
                          #                synth :growl, note: bass_note, attack: 0.001, amp: 0.3*1, decay:  bass_score.look(:b)[-1]*knit(0.5,1,0.25,3).tick(:ds2), cutoff: 135
                        end
                      end
                    end
                  end
                  comment do
                    with_fx :gverb, decay: 0.8, room: 300, mix: 0.9, mix_slide: 0.25, spread: 1.0 do |g_fx|
                      control g_fx, mix: 0.8+rand
                      sample Fraz[/coil/,/c#/,[0,0]].tick(:sample), cutoff: 80, amp: 0.5, start: 0.2, finish: 0.15, rpitch:  ring(5,-2,-2,-2).look
                      sample Corrupt[/kick/,7], amp:  ring(1.0,0.8,0.8,0.9).tick(:ms)*0.5, cutoff:  line(70,100, steps: 8).look, rpitch:  ring(0,5,5,5).look
                    end
                  end
                  with_fx :lpf, cutoff: 0, mix: 1.0 do
                    s =  knit( chord(:Fs3, :m), 4, # chord(:Gs3, :dim), 4,  chord(:Fs3, :m), 4,
                               )
                    with_fx :distortion, distort: 0.5, mix: 1.0, mix_slide: 0.5 do |d_fx|
                      if spread(1,8).tick(:kicker)
                        control d_fx, mix: 0.5
                        sample Corrupt[/kick/,7], amp: 0*0.8, cutoff: 80 + rand,  rpitch:  ring(0,5,5,5).look
                      else
                        control d_fx, mix: 0.2
                        sample Corrupt[/kick/,7], cutoff: 70 + rand, amp: 1.0,  rpitch:  ring(0,5,5,5).look
                      end
                      sy = :plucked
                      sleep 1/4.0
                      #sample Mountain[/ice/].tick(:sample), cutoff: 100, aamp: 0.1
                      with_transpose 0 do
                        sample Fraz[/coil/,/c#/,[0,0]].tick(:sample), cutoff: 135, amp: 0.3, start: 0.2, finish: 0.15, rpitch:  ring(0,-2,-2,-2).tick(:itititi)
          
                        #with_fx :reverb, room: 1.0, mix: 1.0, spread: 1 do
                        with_transpose 12*1 do
                          #synth :beep, cutoff: 100, note: s.tick, release: 0.25, attack: 1.0, amp: 0.2, pan:  ring(0.25, -0.25).tick(:pan)
                        end
                        #    puts "Harmoney #{note_inspect(s.look)}"
                        #synth :prophet, cutoff: 100, note: s.tick, release: 0.25, attack: 2.0, amp: 0.2, pan:  ring(0.25, -0.25).tick(:pan)
                        #end
                        #synth :growl, note: s.look, release: 0.25, attack: 0.1, amp: 0.5
                      end
                      sleep 1/4.0
                      #sample Fraz[/coil/,/c#/,[0,0]].tick(:sample), cutoff: 135, amp: 0.8, start: 0.2, finish: 0.15
                      #        sample Corrupt[/kick/,7], amp: 1*1, cutoff: 100
                      #       sample Corrupt[/GuitarThud/].tick(:hitit), amp: 0.5#, cutoff: 80
                      sleep 1/4.0#;sample Corrupt[/kick/,9]
                      sleep 1/4.0
                      #      sample Corrupt[/kick/,9], amp: 0.6, cutoff: 100
                      #sample Corrupt[/snare/,0], amp: 0.4, cutoff: 75, rpitch: 0
                      sleep 1/4.0
                      sleep 1/4.0
                      sample Corrupt[/GuitarThud/,0], amp: 0.8, cutoff: 50
                      sleep 1/4.0
                      sleep 1/4.0
                    end
                  end
                end
              end
  
  
              comment do
                core_score = (knit ["E", "G#", "B"],32, ["A", "C#","F#"],32, ["A", "C#", "E"],32,
                              ["C#", "E", "G#"],32*2, ["A", "C#", "F#"],32, ["D", "F#", "A"],32, ["B", "D", "F#"],32
                              )
                #itsu = NoteSlices.find(root: core_notes[0], octave: 2, max: 1/4.0).take(0)
                core_score.map{|core_notes|
                  suspects = (ring
                              NoteSlices.find(root: core_notes[0], octave: 2, max: 1/4.0).select{|s| s}.take(2),
                              NoteSlices.find(root: core_notes[1], octave: 3, max: 1/4.0).select{|s| s[:path]=~/sop|alto|bass/}.drop(rand > 0.5 ? 32 : 32).take(16),
                              NoteSlices.find(root: core_notes[2], octave: 3, max: 1/2.0).select{|s| s[:path]=~/sop|alto|bass/}.take(16))
                }.flatten.map{|s| load_sample s[:path]}
              end

              with_fx :reverb, decay: 1.0, room: 1, damp: 1.0, damp_slide: 1 do |r_fx|
                live_loop :percussion, sync: :kick do
                  with_fx :level, amp: 1.0 do
                    tick
                    core_notes = (knit ["E", "G#", "B"],32, ["A", "C#","F#"],32, ["A", "C#", "E"],32,
                                  ["C#", "E", "G#"],32*2, ["A", "C#", "F#"],32, ["D", "F#", "A"],32, ["B", "D", "F#"],32
                                  ).look
                    #itsu = NoteSlices.find(root: core_notes[0], octave: 2, max: 1/4.0).take(0)
                    suspects = (ring
                                NoteSlices.find(root: core_notes[0], octave: 2, max: 1/4.0).select{|s| s}.take(2),
                                NoteSlices.find(root: core_notes[1], octave: 3, max: 1/4.0).select{|s| s[:path]=~/sop|alto|bass/}.drop(rand > 0.5 ? 32 : 32).take(16),
                                NoteSlices.find(root: core_notes[2], octave: 3, max: 1/2.0).select{|s| s[:path]=~/sop|alto|bass/}.take(16))
                    x =  knit(:none, 7, :echo, 1).tick(:fx)
                    with_fx x, mix: range(0.0, 0.4, 0.4/64).look, phase: (ring 0.5, 0.25, 0.5, 0.125).tick(:moving), decay: 4.0, bits: 6, sample_rate: 8000, phase: 0.125 do
                      pat = (ring *%w{🐋🦄🦄 🦄🐴🐴
                                      🦄🦄🦄 🐴🐴🐴
                                      🦄🦄🦄 🦄🐴🦄
                                      🐁🦄🦄 🐴🦄🐴
                                      }.map{|s|s.split("")}.flatten)
                      puts suspects.look.look(:inner)[:path]
                      control r_fx, damp: rand
                      if pat.look == "🦄"
                        s = suspects.look.tick(:inner)
                        #smp Mountain[/microperc/,5], amp: 1, cutoff: 80
                        #  smp s, cutoff: (ring *(range 100, 130, 10)).look, amp: 2.8
                      elsif pat.look == "🐋"
                        s = suspects.look.tick(:inner)
                        # smp s, amp: 1.0, pitch: (ring -1.0, -0.85, -0.5, -2.0).tick(:ph)
                      elsif pat.look == "🐁"
                        s = suspects.look.tick(:inner)
                        if rand > 0.5
                          #  smp s, amp: 1, pan: ring(0.25,-0.25).look, cutoff: (ring *(range 80, 135, 2)).look
                        end
                      end
                      sleep 1/4.0
                    end
                  end
                end
              end
              comment do
                with_fx :reverb, decay: 1.0, room: 1, damp: 1.0, damp_slide: 1 do |r_fx|
                  live_loop :percussion2, sync: :kick do
                    stop
                    with_fx :level, amp: 1.0 do
                      tick
                      core_notes = (knit ["E", "G#", "B"],32, ["A", "C#","F#"],32, ["A", "C#", "E"],32,
                                    ["C#", "E", "G#"],32*2, ["A", "C#", "F#"],32, ["D", "F#", "A"],32, ["B", "D", "F#"],32
                                    ).look
                      suspects = (ring
                                  NoteSlices.find(root: core_notes[0], octave: 3, max: 1/2.0).take(8),
                                  NoteSlices.find(root: core_notes[1], octave: 3, max: 1/2.0).take(8),
                                  NoteSlices.find(root: core_notes[2], octave: 3, max: 1/2.0).take(8))
                      x =  knit(:none, 0).tick(:fx)
                      with_fx :none, mix: range(0.0, 0.4, 0.4/64).look, phase: (ring 0.5, 0.25, 0.5, 0.125).tick(:moving), decay: 4.0, bits: 6, sample_rate: 8000 do
                        pat = (ring *%w{🦄🐴🐴🐴 🐴🐴🐴🐴
                                        }.map{|s|s.split("")}.flatten)
                        control r_fx, damp: rand
                        if pat.look != "🐴"
                          s = suspects.look.tick(:inner)
                          smp s, pan: ring(0.25,-0.25).look, cutoff: (ring *(range 100, 130, 10)).look, amp: 1, start: 0
                        end
                        sleep 1/4.0
                      end
                    end
                  end
                end
              end

  
