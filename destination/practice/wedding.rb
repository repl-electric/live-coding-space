["support", "soprano", "samples"].each{|f| require "/Users/josephwilk/Workspace/repl-electric/sonic-pi/lib/#{f}"}

gravity_s = "/Users/josephwilk/Dropbox/repl-electric/samples/stars_gravity.wav"

#sample gravity_s, amp: 0.1

bar = 1.0/1.0
live :timer do
  cue :circle
  sleep bar
  sleep bar
end

live :drummer do |n|
  use_synth :beep
  use_synth_defaults attack: 0.01, release: 0.01, amp: 0.2
  with_fx :lpf, cutoff: 70 do
    with_fx :reverb do
      sync :circle
      if n%2 == 0
        sample :drum_bass_soft, amp: 0.2, rate: -1.0
      else
        sample :drum_bass_soft, amp: 0.2, rate: 1.0
      end

      case (n%16)+1
      when false
        sample :drum_bass_soft, amp: 1.0
        play degree(1, :A3, :major)
        sleep (bar/4.0)
        play degree(1, :A3, :major)
        sleep bar/4.0
        play degree(1, :A3, :major)
        sleep bar/4.0
        play degree(1, :A3, :major)
        sleep bar/4.0
      when false
        sample :drum_bass_soft, amp: 0.8
        play degree(1, :A3, :major)
        sleep bar/4.0
        play degree(1, :A3, :major)
        sleep bar/4.0
        play degree(1, :A3, :major)
        sleep bar/4.0
        play degree(1, :A4, :major)
        sleep bar/4.0
      when 16
        sample :drum_bass_soft, rate: 1.2
        play degree(1, :A3, :major), amp: 0.5
        sleep bar/8
        play degree(1, :A3, :major), amp: 0.6
        sleep (bar/8)*3

        sample :drum_bass_soft
        play degree(3, :A4, :major)

        sleep bar/4.0
        play degree(1, :A4, :major)
        sleep bar/4.0

        sleep bar/4.0
        play degree(4, :A4, :major)
        sleep bar/4.0
        sample :drum_bass_soft

        play degree(4, :A4, :major)
        sample :drum_tom_hi_soft
        sleep bar/2.0
        sample :drum_tom_lo_soft
      when 1..8
        sample :drum_bass_soft, amp: 0.5, rate: 1.0
        play degree(1, :A4, :major)
        sleep (bar/4.0)
        play degree(1, :A4, :major)
        sleep bar/4.0
        play degree(1, :A4, :major)
        sleep bar/4.0
        play degree(1, :A4, :major)

        sleep bar/2.0
        sleep (bar/2.0)
        sleep bar/4.0
      when 8..16
        sample :drum_bass_soft, amp: 0.5, rate: 1.0
        play degree(1, :A4, :major)
        sleep (bar/4.0)
        play degree(1, :A4, :major)
        sleep bar/4.0
        play degree(1, :A4, :major)
        sleep bar/4.0
        play degree(1, :A4, :major)
        sleep bar/2.0
        sleep (bar/2.0)
      end
    end
  end
end

live :highlights do |n|
  use_synth :fm
  vol = 0.4
  sync :circle
  play degree(1, :A2, :major), attack: bar, release: bar*1, amp: vol
  s = "/Users/josephwilk/Workspace/music/samples/soprano/Samples/Sustains/Mm p/releases/vor_sopr_sustain_mm_p_03_r.wav"
#  if n % 2 == 0
  sleep (bar)
  with_fx :echo, phase: bar do
  with_fx :reverb do
    sample s, amp: 0.1
#    sleep(bar/2)
 #   sample s, amp: 1.5, decay: 0.1, release: 0.1
  end
  end

  #  sleep bar/2
#  end
 
  #sleep bar*1
  sync :circle
  play degree(3, :A2, :major), attack: bar, release: bar*1, amp: vol
  s = "/Users/josephwilk/Workspace/music/samples/soprano/Samples/Sustains/Mm p/releases/vor_sopr_sustain_mm_p_08_r.wav"

#  if n % 2 == 0
  sleep bar
  with_fx :echo, phase: bar do
  with_fx :reverb do
    sample s, amp: 0.1
  end
  end

#  end
  
  sleep bar*1
end

live :higher do |n|
  vol = 0.4
  sync :high
  use_synth :beep
  play degree(5, :A3, :major), release: bar*2, attack: bar*2, amp: vol

  with_fx :lpf, cutoff: 70 do
    with_fx :echo, phase: bar do
      with_fx :reverb do
        use_synth :zawa
        #play_chord chord(:A5, :major), release: bar*2, attack: bar, decay: bar, amp: 0.3,  cutoff: 50, res_slide: 0.2
      end
    end
  end
end

live :higher2 do |n|
  vol = 0.4
  use_synth :tb303
  #use_synth :beep
  with_fx :reverb do
    sync :high
    if n%2 == 0
      play degree(5, :A4, :major), release: 0.3, attack: 0.01, amp: vol
      sleep bar*1
      play degree(3, :A4, :major), release: 0.2, attack: 0.01, amp: vol

      sleep bar*1
      with_fx :reverb do
        play degree(3, :A4, :major), release: bar*2, attack: 0.01, decay: bar/4, amp: vol
        sleep bar/2
        play degree(6, :A4, :major), release: 0.15, attack: 0.01, amp: vol
        sleep bar/2
        play degree(6, :A4, :major), release: 0.1, attack: 0.01, amp: vol
        sleep bar
      end
    end
  end
end

live :otherhigher do |n|
  vol = 0.4
  sync :other_high

  use_synth :beep
  play degree(5, :A3, :major), release: bar*2, attack: bar*2, amp: vol
end

live :otherhigher2 do |n|
  vol = 0.1
  use_synth :tb303
  with_fx :reverb do
    sync :other_high
    if n%2 == 0
      play degree(5, :A3, :major), release: 0.3, attack: 0.01, amp: vol
      sleep bar*1
      #with_fx :reverb do
      play degree(3, :A3, :major), release: 0.2, attack: 0.01, amp: vol

      sleep bar*1
      with_fx :reverb, room: 0.9 do
        play degree(5, :A3, :major), release: bar*2, attack: 0.01, decay: bar/8, amp: vol
        sleep bar/2
        play degree(3, :A3, :major), release: 0.15, attack: 0.01, amp: vol
        sleep bar/2
        play degree(3, :A3, :major), release: 0.1, attack: 0.01, amp: vol
        sleep bar
      end
    end
  end
end

live :words do
  sync :circle
  with_fx :ixi_techno, phase: bar*4 do
    sample gravity_s, amp: 1
    sleep 8*sample_duration(gravity_s)
  end
end

define :startbeep do |n|
  use_synth_defaults amp: 0.4
  play degree(1, :A3, :major)
  sleep bar/2.0
  play degree(3, :A3, :major)
  sleep bar/2.0

  if n == 3 || n == 7
    sample :drum_cymbal_closed, rate: 1.0, amp: 0.1
    play degree(1, :A2, :major)
    sleep bar/2.0
    play degree(4, :A2, :major)
    sleep bar/4.0
    sample :drum_tom_lo_soft
    play degree(4, :A2, :major)
    sleep bar/4.0
  else
    sample :drum_cymbal_closed, rate: 1.0, amp: 0.1
    play degree(1, :A2, :major)

    if n%2 == 0
      sleep (bar/2.0)
      sample :drum_snare_soft, rate: 0.5, amp: 0.05, pan: -0.25
    else
      sleep (bar/2.0)
      sample :drum_snare_soft, rate: 0.5, amp: 0.05, pan: 0.25
    end

    play degree(1, :A2, :major)
    sleep bar/2.0
    cue :high
  end
end

define :endbeep do |n|
  use_synth_defaults amp: 0.4
  play degree(1, :A3, :major)
  sleep bar/2.0
  play degree(3, :A3, :major)
  sleep bar/2.0

  if n == 3 || n == 7
    sample :drum_cymbal_closed, rate: 1.0, amp: 0.2
    play degree(1, :A3, :major)
    sleep bar/4.0
    sample(:drum_tom_hi_soft)
    play degree(5, :A3, :major)
    sleep bar/4.0
    play degree(5, :A3, :major)
    sleep bar/4.0
    sample :drum_tom_hi_soft
    sample :drum_cymbal_open, rate: 0.80, amp: 0.05
    play degree(5, :A3, :major)

    sleep bar/4.0
    if n == 7 || n == 4
      sample(:drum_tom_hi_soft)
    end
  else
    sample :drum_cymbal_closed, rate: 1.0, amp: 0.2
    play degree(5, :A3, :major)
    sleep bar/2.0
    play degree(5, :A3, :major)
    sleep bar/2.0
    cue :other_high
  end
end

live :beeping do
  use_synth :beep
  with_fx :echo, phase: bar/4.0 do
    with_fx :reverb do
       8.times do |n|
        #cue :startstart
        sync :circle
        startbeep(n)
      end

      8.times do |n|
        sync :circle
        cue :start if n == 7
        endbeep(n)
      end
    end
  end
end

live :sing do |n|
  sync :startstart
  s = "/Users/josephwilk/Workspace/music/samples/soprano/Samples/Sustains/Mm p/vor_sopr_sustain_mm_p_03.wav"
#  with_fx :slicer, phase: bar*2 do
#  with_fx :reverb do
 # with_fx :echo, phase: bar/4 do
#  sample s, amp: 1.0
  #end
  #end
 # end
#  sleep sample_duration(s)
end

#begone :beeping
begone :end_of_bar
#begone :words
begone :otherhigher2
begone :otherhigher
begone :higher2
begone :higher
#begone :highlights
#begone :drummer

set_volume! 1
#fadeout()
