define :csample do |name|
  root = "/Users/josephwilk/Dropbox/repl-electric/samples/pi"
  "#{root}/#{name}"
end

s = csample "halixic.wav"
s_dur = sample_duration(s)

t = csample "clacker_rhythm.wav"
t_dur = sample_duration(t)

z = csample "nano_blade_loop.wav"
j = csample "crunchy_beat.aif"
j_dur = sample_duration(j)

g = csample "120bpm2smagnhildhh.wav"
a = csample "120bpm2smagnhildbd.wav"
b = csample "120bpmabramis4s_g.wav"
c = csample "whisperloop.wav"
e = csample "hypnoticsynth.wav"
f = csample "feedback21.wav"

#g = csample "120bpmacantholabrus4s_g.wav"
h = csample "120bpmacantholabrus6s_g.wav"
i = csample "120bpmacantholabrus6s_a.wav"
k = csample "120bpmacantholabrus6s_d.wav"

ethereal_femininity_s = csample "ethereal_femininity.wav"

define :highlights do
  sample [g, h, i, k].choose, rate: [1/2, 1/4, 1/8].choose
  sample s, rate: 0.2
  sample s

  if dice(6) > 3
    with_fx :slicer  do
      options = [2.0, 1.0 -2.0, -1.0]
      sample s, rate: options.choose
      sleep 1
      sample s, rate: options.choose
      sleep 0.5
      sample s, rate: options.choose
      sleep 0.5
      sample s, rate: options.choose
      sleep 1
    end
    sleep s_dur-2-1
  else
    sleep s_dur
  end

end

define :back do
  sample s, rate: 1
  with_fx :reverb, room: 0.5  do
    sample s, rate: 0.5
  end
  with_fx :echo, mix: lambda{rrand(0, 1)} do
    sample s, rate: 1.01, amp: 0.5
    sleep s_dur
  end
end

define :drums do
  sample :drum_snare_soft, rate: 0.4
  sleep j_dur/2
end

define :d2 do
  # default tempo is 60 bpm
  tempo = [60, 120, 240].choose
  with_bpm tempo do
    sample :drum_heavy_kick, rate: 0.8
    sleep j_dur/4
    with_fx :rlpf do
      sample j, pan: lambda{rrand(-1,1)}
    end
  end
end

define :d3 do
  sleep s_dur*3
  sample :ambi_choir, rate: 0.2, amp: 0.2
end

define :zoo do
  with_fx :reverb do
    sample z; sleep s_dur*4
  end
end

define :techo do
  with_fx :ixi_techno do
    sample t
    sleep t_dur
  end
end

define :echoer do
  rate = [1, -1].choose
  if dice(6) > 4
    sample e, rate: rate
    sleep sample_duration e
  end
end

define :highlights2 do
  rate = [0.7, -0.7].choose
  sample c, amp: 1, rate: rate
  sleep t_dur
end

define :highlights3 do
  with_fx :pan, pan: lambda{rrand(-1,1)}  do
    with_fx :echo do
      with_fx :reverb, mix: 0.9 do
        sample ethereal_femininity_s, amp: 0.9, rate: choose([1, 1/2, 1/4, 1/8])
      end
    end
  end

  sleep t_dur
end

in_thread(name: :d1) { loop {d3} }
in_thread(name: :d2) { loop {d2} }
in_thread(name: :d3) { loop {drums} }
in_thread(name: :d4) { loop {techo} }
in_thread(name: :d5) { loop {zoo} }
in_thread(name: :d6) { loop {back} }
in_thread(name: :d7) { loop {echoer} }
in_thread(name: :h1) { loop {highlights3} }
in_thread(name: :h2) { loop {highlights2} }
in_thread(name: :h3) { loop {highlights} }