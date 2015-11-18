["samples","instruments","experiments", "log", "shaderview"].each{|f| load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/#{f}.rb"}; _=nil


with_fx(:reverb, room: 0.8, mix: 0.9, damp: 0.5) do |r_fx|
  live_loop :warm_up do
    #    sample Corrupt[/acoustic guitar/, /fx/].tick, cutoff: 75, amp: 1.5, beat_stretch: 8.0
    #sync :organ
    with_fx(:slicer, phase: 0.25*2, probability: 0) do

      with_synth :dark_sea_horn do
        play :fs2, cutoff: 80, decay: 8.1, amp: 0.6
      end
    end

    sleep 8
  end
end
shader :iWave, 0.5
#--Log of activity---------------------------------------->

#The code here creates and controls the sounds you are hearing.

live_loop :Matz do
  with_fx :reverb, room: 0.5 do
    with_fx(:pitch_shift, mix: 0.8, window_size: 0.1, pitch_dis: 0.05) do
      with_fx(:flanger, feedback: 0.8, decay: 0.5,mix: 0.4) do |r_fx|
        sample Words[/guy/], amp: 0.0
      end
    end
  end
  sleep 32
end

live_loop :heart do
  sync :organ
  #New samples to play with...
  with_fx(:krush, mix: 0.4) do |r_fx|
    #sample Organic[/kick/,2], cutoff: 80, amp: 1.0
  end

  sample ChillD[/drum_loop/,10], cutoff: 60, amp: 0.5, beat_stretch: 8.0

  #sample Organic[/drum_loops/,0],amp: 1.0



  #  sample Dust[/f#m/,1], cutoff: 45, amp: 0.2, beat_stretch: 8.0
  #  sleep 2

  #New set of samples.... no idea what we will find in here.....
  sleep 8
end

live_loop :perc do
  with_fx(:krush, mix: 0.1) do |r_fx|
    with_fx(:slicer, phase: 0.25, probability: 0) do
      sample Organic[/loop/,/perc/, 2], cutoff: 75,
        beat_stretch: 16.0, amp: 1.0
    end
  end
  sleep 16
end

live_loop :breath do
  with_fx(:reverb, room: 1.0, mix: 0.8, damp: 0.5) do |r_fx|
    #  sync :organ
    sleep 16+4
    sample Fraz[/coil/,/c#/,0], cutoff: 60, amp: 0.8, rate: 0.5
    sleep 16-4
  end
end


live_loop :fx do

  sync :organ
  with_fx(:reverb, room: 0.6, mix: 0.4, damp: 0.5) do |r_fx|
    synth :dsaw, note: :Fs1, cutoff: 40, amp: 0.1, decay: 16, detune: 12
    synth :prophet, note: :Fs1, cutoff: 40, amp: 0.1, decay: 16, detune: 12
  end

  sample Organic[/f#/,/strings/,0], cutoff: 50, amp: 1.0, beat_stretch: 16
  sleep 16
end

#This is the Leeds organ. Its lovely...
live_loop :organ do
  synth :hollow, note: :e3, attack: 1.0, decay: 4.0
  slices = [1,2,4].shuffle
  notes = [[/f#1/, /a1/, /c#1/],
           [/a1/, /c#1/, /_e1_/],
           [/c#1/, /_e1_/, /g#1/]].choose

  #notes = [/f#2/, /g#1/, /b1/]

  sample Organ[/f#0/,[0,0]].tick(:sample), cutoff: 100, amp: 2.0
  with_fx(:slicer, phase: 0.25*slices[0], probability: 0) do
    sample Organ[notes[0],[0,0]].tick(:sample), cutoff: 100, amp: 3.0
  end

  with_fx :echo, phase: 0.25*2 do
    #sample Instruments[/violin/, /fs4_1|a4_1|cs4_1/].tick, amp: 1, attack: 0.5
  end

  with_fx :echo, decay: 8.0 do
    with_fx(:distortion, mix: 0.1, distort: 0.2) do |r_fx|
      with_fx :reverb, room: 1.0 do
        sample Instruments[/cello/, /pianissimo_arco/, /fs2_1|a2_1|cs2_1/].tick, amp: 8
      end
    end
  end


  with_fx(:echo, phase: 0.25*2, decay: 8.0) do
    sample Organic[/kick/,4], amp: 2.0
    #sample Organic[/kick/,4], amp: 2.0, rate

    #sample Instruments[/violin/, /fs4/].tick(:oboe), amp: 1

    #sample Instruments[/double-bass/, /fs1/].tick(:oboe), amp: 1

    #   sample Instruments[/oboe/, /fs5/].tick(:oboe), amp: 1
    #    sample Instruments[/oboe/, /fs6/].tick(:oboe), amp: 1

  end

  with_fx(:slicer, phase: 0.25*slices[1], probability: 0) do
    sample Organ[notes[1],[0,0]].tick(:sample), cutoff: 100, amp: 3.0
  end

  with_fx(:slicer, phase: 0.25*slices[2], probability: 0) do
    sample Organ[notes[2],[0,0]].tick(:sample), cutoff: 100, amp: 2.9
  end

  sleep 8
end
