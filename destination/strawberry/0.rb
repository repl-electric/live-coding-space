load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/samples.rb";load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/dsp.rb";load "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lib/monkey.rb"
_=nil
set_volume! 2.0
def note_slices(n, m)
  NoteSlices.find(note: n, max: m, pat: "sop|alto|bass").select{|s| s[:path] =~ /sop|alto/}.take(64)
end
@slices ||= {"Gs2/4" => note_slices("Gs2",1/4.0),"D2/4" => note_slices("D2",1/4.0), "E2/4" => note_slices("E2",1/4.0), "A2/4" => note_slices("A2",1/4.0), "Fs2/4" => note_slices("F#2",1/4.0),"Fs2/8" => note_slices("F#2",1/8.0), "E3/4" => note_slices("E3",1/4.0), "D3/4" => note_slices("D3",1/4.0),"D3/8" => note_slices("D3",1/8.0),"Cs3/4" => note_slices("C#3",1/4.0), "Fs3/8" => note_slices("F#3",1/8.0),"Fs3/4" => note_slices("F#3",1/4.0), "Gs3/4" => note_slices("G#3",1/4.0), "A3/8" => note_slices("A3",1/8.0),"A3/4" => note_slices("A3",1/4.0), "B3/4" => note_slices("B3",1/4.0), "Cs4/4" => note_slices("C#4",1/4.0), "Cs4/8" => note_slices("C#4",1/8.0), "D4/4" => note_slices("D4",1/4.0),"D4/8" => note_slices("D4",1/8.0), "E4/4" => note_slices("E4",1/4.0),"E4/8" => note_slices("E4",1/8.0), "Fs4/4" => note_slices("F#4",1/4.0),"Fs4/8" => note_slices("F#4",1/8.0), "Gs4/4" => note_slices("G#4",1/4.0), "B4/4" => note_slices("B4",1/4.0),"Fs5/4" => note_slices("F#5",1/4.0), "Fs6/4" => note_slices("F#6",1/4.0),"A4/4" => note_slices("A4",1/4.0),"E5/4" => note_slices("E5",1/4.0)}
@slices.values.flatten.each{|f| load_sample f[:path]}
puts @slices.values.flatten.count
#smp Harp.slice(:Fs3).look, amp: 2, cutoff: (ramp 10, 130, 128).tick(:ram)
module Straw
  def self.slice(n, size: 1/4.0)
    @straw_cache ||= {}
    n = n.to_s.gsub(/s/,"#")
    if !@straw_cache.has_key?(n)
      @straw_cache[n] = NoteSlices.find(note: n, max: size, pat: "Straw").take(64)
    end
    @straw_cache[n]
  end
end
module Berry
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/strawberry/Samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end
module Harp
  def self.slice(n, size: 1/4.0)
    @harp_cache ||= {}
    n = n.to_s.gsub(/s/,"#")
    if !@harp_cache.has_key?(n)
      @harp_cache[n] = NoteSlices.find(note: n, max: size, pat: "Harp").take(64)
    end
    @harp_cache[n]
  end
end
🍓=Straw;🥁=@slices
live_loop :fake_drums, sync: :slicing do
  tick
   if spread(1,32).look
    #smp Mountain[/subkick/,1], amp: 2, cutoff: 60
    #smp Frag[/kick/,6], amp: 2#, cutoff: 60
    if spread(1,48).tick(:sindie)
      at do
        sleep (1/8.0)
        #smp Frag[/hat/,4], amp: 0.5, rpitch: (ring 0,12,12).tick(:pi)
        #smp 🥁["Fs3/4"][21], amp: 2
        smp Mountain[/subkick/,0], amp: 2.0
      end
    end
  end
  sleep 1/8.0
end
live_loop :slicing do
  tick
  s = (ring
       1/8.0,1/8.0,1/8.0,1/8.0,
       1/8.0,1/8.0,1/8.0,1/8.0,
       1/8.0,1/8.0,1/8.0,1/8.0,
       1/8.0,1/8.0,1/8.0,1/8.0,
       ).look
with_fx :hpf, mix: 0, cutoff: (ramp 0,90,128).tick(:i231) do
  b = Dust[/perc/,1];a = Dust[/perc/,2]
  if (x=(ring *%w{0 0 0 0  0 0 0 0  0 0 0 0  0 0 0 0
                  0 0 0 0  0 0 0 0  0 0 0 0  0 0 0 0
                  0 0 0 0  0 0 0 0  0 0 0 0  0 0 0 0
                  0 0 0 0  0 0 0 0  0 0 0 0  b 0 0 0}).look) != "0"
    #smp eval(x),amp: 0.5, rate: (ring -1, 1).look
  end
  if spread(1,4).look
    dd = (knit _,3, Corrupt[/One Shots/, /hum/,2],1).tick(:loopy)
    kick_drift = (line,0.0,1/16.0,8).tick(:sloppy)
    smp Mountain[/subkick/,1], amp: 1.0*(ring 1.5).tick(:inside2), cutoff: (ring 135).tick(:inside)
    at{; sleep kick_drift; smp dd, amp: 0.5, finish: 0.01+rand(0.01) }
    if spread(1,16*4).look
     # smp Junk[/tom/,2], amp: 0.8, rpitch: 0
    end
     if spread(1,32).tick(:sindie)
      at do
        sleep (1/8.0)*2
        smp Mountain[/subkick/,0], amp: 0.5
      end
    end
  end
  if spread(7,11, rotate: 1).look
    with_fx :reverb, mix: 0.2, room: (line 0.0, 0.9, 32).look do
      smp Frag[/hat/,[3,5]].look, amp: 0.3, rpitch: (ring 0,12*4,12).tick(:pi), cutoff: (line 110, 135, 32).look
    end
      at do
     if spread(1,64).tick(:sindie)
        sleep 1/8.0
         smp Frag[/hat/,4], amp: 0.25, rpitch: (ring 0,12,12).tick(:pi)
      end
    end
  end
  if spread(1,8).look
    smp Dust[/snare/,2], amp: 0.25
    if spread(1,16).look
      #smp Dust[/snare/,1], amp: 0.25
      #smp Dust[/snare/,8], amp: 0.25
    else
      #smp Dust[/snare/,8], amp: 0.25, rpitch: (line 0,0.5,32).look
    end
  end
  if spread(16,64).look
    with_fx :bitcrusher, bits: 16 do
#      smp Junk[/perc_hit/,/_click_/].take(8).tick(:sn), amp: 0.2, rpitch: 0
    end
  end
  with_fx :pitch_shift, pitch_dis: 0.0, mix: 0 do
  if spread(1,32).look
    #synth :dark_sea_horn, note: chord(:FS2, :m11), cutoff: 100, decay: 1.0, attack: 0.0001, amp: 1.0
  end
    d=(spread 7,11).map{|s| s ? :echo : :slicer}
    with_fx  d.look, decay: 1*2, phase: 0.125, mix: 1, distort: (line 0.0, 0.5,128).look do
#puts (🍓.slice(:Fs3)).take(1)
      ons=[ratio_on((🍓.slice(:Fs3)).look()), ratio_off((🍓.slice(:Fs3)).look())].shuffle
      #smp ((🍓.slice(:Fs3))).look, amp: 4.0, rpitch: (ring 0).shuffle.tick(:inner), cutoff: 135 ,cutoff: (ramp 10, 135, 128).tick(:ras5s3am)#, finish: ons[0], start: ons[1]- (knit 0,31,0.01,1).tick(:spand)
      #smp (🍓.slice(:Fs3)).drop(1).look, amp: 4.0, rpitch: (ring 7).shuffle.tick(:inner), cutoff: 135 ,cutoff: (ramp 10, 135, 128).tick(:ra53am)
      #smp (🍓.slice(:Fs3)).drop(1).look, amp: 4.0, rpitch: (ring 3).shuffle.tick(:inner), cutoff: 135 ,cutoff: (ramp 10, 135, 128).tick(:ra53am)

      if (🍓.slice(:Fs3)).look[:path] =~ /vog_strw_sus_oh_f_01_rel/
        at do
          32.times{|n|
            if(true)
              #smp 🥁["Fs3/8"].drop(12).take(32).tick(:vocals), amp:(line 1.0, 2.0,32).look(:vocals), pan: (line -0.25, 0.25, 32).look(:vocals)
            end
            sleep 1/8.0/2.0
          }
        end
      end
    end

    if spread(7,11).look
      fslice = 🍓.slice(:Fs3).drop(1).reverse.look
#      smp fslice, amp: 4.0, rpitch: (ring 3).tick(:i), cutoff: 135#, finish_offset: rand(1)*0.0025
    end

    d=(spread 3,8).map{|s| s ? :pitch_shift : :bitcrusher}#.shuffle
    with_fx  d.look, decay: 1, phase: 0.25, mix: 1.0, distort: (line 0.0, 0.5, 128).look do
      fslice = 🍓.slice(:Fs3).drop(0).reverse.look
      smp fslice, amp: 4.0, rpitch: (ring 0).look, cutoff: 80#, finish_offset: ((spread 7, 11).look ? 0.01 : 0.0)
      if spread(7,11*5).look# != 0
uncomment do
        with_fx :reverb, room: 1.0, mix: 1.0*(line 0.0,1.0,128).tick(:in) do
          with_fx :level, amp: 0.8*0 do
#            sample (knit Vocals[[2,2]].look,1,_,16).look, amp: 0.1*1.0, pan: (line -0.25,0.25,256).look
            sample (ring
                    🥁["Fs4/8"][16],🥁["Fs4/8"][17],
                    🥁["Fs4/8"][18],🥁["E4/8"][15],
                    🥁["Fs4/8"][20],🥁["Fs4/8"][21]).shuffle.tick(:sop), pan: (line -0.25,0.25, 256).look, cutoff: (ramp 50, 135, 256/2.0).tick(:sopit)
          end
end
        end
      end
      if s != 1/8.0  # B-7-C#-5-D-4-E-2-F#-2-G#-3-A-5-B-7-C#-8-D-10-E-12-F#
        smp fslice, amp: 2.0, rpitch: 0, cutoff: 135, start: 0.8469, finish: 1.0
        #smp fslice, amp: 2.0, rpitch: -5, cutoff: 100, start: 0.7, finish: 1.0
      end
#puts (fslice[:offset] - fslice[:onset])
if (fslice[:offset] - fslice[:onset]) > 0.1
  synth :gpa, note: (knit (chord :Fs4,:m)[0],64, (chord :Cs5,:m)[0],64).look, amp: 1.0, attack: 0.001, decay: fslice[:offset] - fslice[:onset], release: 0.001
end

     if spread(1,64).look
        #smp (🍓.slice(:Fs3)).reverse.drop(12).take(12).reverse.look, amp: 4.0,
        #rpitch: (ring 12*1).look, cutoff: 100
      end
    end
    if (spread 8, 16).look
      with_fx :distortion, mix: (line 0.0, 1.0, 128).look do
        with_fx :bitcrusher, bits: (line 8, 32, 1).look do
#          smp (🍓.slice(:D2).take(32)).look, amp: 0.3,rpitch: (knit -5, 32, 0, 32).look
        end
      end
    end
  end
end
  sleep s
end
live_loop :sop, sync: :slicing do
  tick
  with_fx :echo, room: 0.9 do
    with_fx :distortion do
      #synth :chipbass, note: :Fs4, amp: 0.125, decay: 2, pan: (line 0.25, -0.25, 0.001).look
    end
  end
  with_fx :pitch_shift do
    #smp Berry[/sustain/,/mm/][14], amp: 1
  end
  with_fx :pitch_shift, pitch_dis: 0.2 do
     #smp Harp.slice("C#3").take(16).look, amp: 4.2
  end
  sleep (1/8.0)
end
live_loop :breath, sync: :slicing do
  tick
  sample Vocals[[2,2,2, 2,2,6]].look, amp: 0.05*1.0, pan: (line -0.25,0.25,256).look
  sleep (1/2.0)*6
end
live_loop :ambient, sync: :slicing do
  tick
  with_fx :slicer, phase: (ring 1/4.0).look, invert_wave: 1  do
    #synth :dark_ambience, note: (chord :Fs4, :m11), amp: 1, decay: 10, attack: 8.0
    #smp Berry[/gaiazone_9/], amp: 10
  end
  #smp Berry[/ataxicone_10/], amp: 2
  #sample 🍓.slice(:Fs3).look()[:path], amp: 1
  sleep (1/2.0)*32
end

with_fx :reverb, mix_slide: 2, damp_slide: 2, mix: 1 do |g_fx|
live_loop :harmony, sync: :slicing do
tick
synth :dark_ambience, note: (ring 
                             chord(:FS3,:m), chord(:B3, :sus2),
                             chord(:B3, :m), chord(:Cs4,:m)).look, decay: 16.2, attack: 1, amp: 0.25
16.times{
control g_fx, mix: rand, damp: rand
sleep 1
}
end
end

live_loop :drum_layer,sync: :slicing do
  tick
  smp Dust[/crunchy/,4], amp: 0.5
  #smp Dust[/./].look, amp: 4#, beat_stretch: 8, amp: 4
  8.times{
    if(ring 1,0,0,0,1,0,1,0).look == 1
      smp Junk[/lo/,0], amp: 0.2*0
    end
    if(ring 0,1,0,0,0,0,0,0).look == 1
      smp Fraz[/snap/,2], amp: 0.5*0
    end
    if(ring 0,0,1,0,0,0,0,0).look == 1
      smp Fraz[/snap/,4], amp: 1*0
    end
    tick
    sleep 1/2.0
  }
end
