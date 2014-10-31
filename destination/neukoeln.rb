["support", "soprano", "samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}

bar = 1.0/1.0
live :timer do
  cue :circle
  sleep bar
  sleep bar
end

live :drummer do |n|
  use_synth :beep
  use_synth_defaults attack: 0.01, release: 0.01
  with_fx :lpf, cutoff: 100 do
    with_fx :reverb do
      sync :circle
      if n%16 == 7
        sample :drum_bass_soft
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(1, :A3, :major)
        sleep bar/2.0
      elsif n%16 == 15
        play degree(1, :A4, :major)
        sleep bar
        sleep bar
      elsif n%16 == 0
        sample :drum_bass_soft
        play degree(1, :A4, :major)
        sleep bar/3.0
        play degree(1, :A4, :major)
        sleep bar/3.0
        play degree(1, :A4, :major)
        sleep bar/3.0
      else
        with_fx :lpf, cutoff: 80 do
        sample :drum_bass_soft
        end
        play degree(1, :A4, :major)
        sleep bar
        play degree(1, :A4, :major)
        sleep bar
      end
    end
  end
end

live :highlights do |n|
#  sync :high

  use_synth :fm
  vol = 0.7
  #if n%2 == 0
  #8.times do |n|
    sync :circle
    play degree(1, :A2, :major), attack: bar, release: bar*1, amp: vol
    sleep bar*1
    sync :circle
    play degree(4, :A2, :major), attack: bar, release: bar*1, amp: vol
    sleep bar*1
  #end    

end

live :higher do |n|
  sync :high
  use_synth :beep
  #with_fx :slicer, phase: bar/2  do
    play degree(6, :A3, :major), release: bar*2, attack: bar*2
  #end
  use_synth :zawa
  with_fx :lpf, cutoff: 70 do
  with_fx :echo, phase: bar do 
  
  with_fx :reverb do
    #play_chord chord(:A5, :major), release: bar*1, attack: bar, decay: bar, amp: 0.3
  end
  end
  end
end

live :otherhigher do |n|
  sync :other_high
  use_synth :beep
  play degree(5, :A3, :major), release: bar*2, attack: bar*2
end


live :words do
  sync :circle
  with_fx :ixi_techno do
  sample "/Users/josephwilk/Dropbox/repl-electric/samples/stars_gravity.wav", amp: 1 
  sleep 8*sample_duration("/Users/josephwilk/Dropbox/repl-electric/samples/stars_gravity.wav")
  end
end

live :beeping do
  use_synth :beep
  #    with_fx :lpf, cutoff: 120, _slide: 5 do
  with_fx :echo, phase: bar/4.0 do
    with_fx :reverb do
      8.times do |n|
        sync :circle
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(3, :A3, :major)
        sleep bar/2.0

        if n == 3 || n == 7
          play degree(1, :A3, :major)
          sleep bar/2.0
          play degree(4, :A3, :major)
          sleep bar/4.0
          with_fx :lpf, cutoff: 70 do
            sample :drum_tom_lo_soft
          end
          play degree(4, :A3, :major)
          sleep bar/4.0
        else
          play degree(1, :A3, :major)
          sleep bar/2.0
          play degree(4, :A3, :major)
          sleep bar/2.0
          cue :high
        end
      end

      8.times do |n|
        sync :circle
        play degree(1, :A3, :major)
        sleep bar/2.0
        play degree(3, :A3, :major)
        sleep bar/2.0

        if n == 3 || n == 7
          play degree(1, :A3, :major)
          sleep bar/4.0
          with_fx :lpf, cutoff: 70 do
            sample :drum_tom_hi_soft
          end
          play degree(5, :A3, :major)
          sleep bar/4.0
          play degree(5, :A3, :major)
          sleep bar/4.0
          with_fx :lpf, cutoff: 70 do
            sample :drum_tom_hi_soft
          end
          play degree(5, :A3, :major)
          sleep bar/4.0
        else
          play degree(1, :A3, :major)
          sleep bar/2.0
          play degree(5, :A3, :major)
          sleep bar/2.0
          cue :other_high
        end
      end
    end
  end
  # end
end
