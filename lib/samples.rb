module Sample
  
def self.matches(samples, matchers)
  samples = samples.sort!
  r = matchers.reduce(samples) do |filtered_samples,filter|
    if filtered_samples && !filtered_samples.empty?
    if filter.is_a?(Integer)
      filter = filter % filtered_samples.size
      [filtered_samples[filter]]
    elsif filter.is_a? Regexp
      if filter.inspect[-1] == "/" #We have no flags
        reg_str = filter.inspect[1..-2]
        filter = Regexp.new(reg_str,"i")
      end
      filtered_samples.select{|s| s=~ filter}
    elsif filter.is_a? Range
      filter.to_a.map{|f| Sample.matches(filtered_samples, [f])}
    elsif filter.is_a? SonicPi::Core::RingVector
      filter.to_a.map{|f| Sample.matches(filtered_samples, [f])}
    elsif filter.is_a? Array
      filter.map{|f| Sample.matches(filtered_samples, [f])}
    elsif filter == nil
      nil
    else
      filtered_samples.select{|s| s=~ /#{filter}/i}
    end
    end
  end

  if r && r.length == 1
    r[0]
  else
  if r && !r.empty?
    SonicPi::Core::RingVector.new(r)
  end
  end
end
end

ROOT = "/Users/josephwilk/Workspace/music/samples/"
module Organ
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/TownHallOrgan_SP/Samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Corrupt
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/DeviantAcoustics/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module ChillD
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/CHILLSTEP/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Mountain
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Mountain/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Decimated
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Decimated/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    self[a][0]
  end
end

module Ether
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Ether/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    self[a][0]
  end
end
module Frag
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Frag/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    self[a][0]
  end
end
module Fraz
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Dropbox/Music/samples/Frag2/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    self[a][0]
  end
end
module Eraser
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Eraser/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    self[a][0]
  end
end
module Scape
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Soundscape/**/*.wav"]
    Sample.matches(samples, a)
  end
  def self.pick(a)
    self[a][0]
  end
end
module Ambi
 def self.pick(a)
   self[a][0]
 end
 def self.[](*a)
   samples = Dir["/Users/josephwilk/Workspace/music/samples/Ambi/**/*.wav"]
   Sample.matches(samples, a)
 end
end
module Chill
 def self.pick(a)
   self[a][0]
 end
 def self.[](*a)
   samples = Dir["/Users/josephwilk/Workspace/music/samples/Chill/**/*.wav"]
   Sample.matches(samples, a)
 end
end
module Down
  def self.pick(a)
    self[a][0]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Down/**/*.wav"]
    Sample.matches(samples, a)
  end
end
module Heat
  def self.pick(a)
    self[a][0]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Heat/**/*.wav"]
    Sample.matches(samples, a)
  end
end
module Sop
  def self.pick(a)
    self[a][0]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/soprano/Samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end
module Alt
  def self.pick(a)
    self[a][0]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Alto/Samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end
module Bass
  def self.pick(a)
    self[a][0]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Bass/Samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end
module Dust
  def self.pick(a)
    self[a][0]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Dropbox/Music/samples/Dust/**/*.wav"]
    Sample.matches(samples, a)
  end
end
module Vocals
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Dropbox/Music/samples/Vocals/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Future
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Future/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Organic
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Organic/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Instruments
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/instruments/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Live
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Live/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Words
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Dropbox/repl-electric/samples/matz/*"]
    Sample.matches(samples, a)
  end
end

module Abstract
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Abstract/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module CineAmbi
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/CineAmbi/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module CineElec
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/CineElec/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Fractured
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Fractured/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Cycles
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Cycles/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module FutureE
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/FutureE/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module MagicDust
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/MagicDust/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Junk
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Junk/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Dusty
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Dusty/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Tech
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Analogue/**/*.wav"] + Dir["/Users/josephwilk/Workspace/music/samples/Pulse/**/*.wav"] +
Dir["/Users/josephwilk/Workspace/music/samples/ModTech/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Juno
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Juno/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Ambius
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Ambius/Samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Circles
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/Circle Bells/Samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Twine
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/TwineBass/Samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module Sink
  def self.pick(a)
    self[a]
  end
  def self.[](*a)
    samples = Dir["/Users/josephwilk/Workspace/music/samples/**/*.wav"]
    Sample.matches(samples, a)
  end
end

module S
def self.halixic              
  csample "halixic.wav"
end                           

def self.clacker              
  csample "clacker_rhythm.wav"
end                           

def self.eery_vocals          
  csample "hypnoticsynth.wav"
end                           

def self.zoom                 
  csample "nano_blade_loop.wav"
end                           

def self.beat                 
  csample "crunchy_beat.aif"
end                           

def self.whisper              
  csample "whisperloop.wav"
end                           

def self.ethereal_femininity  
  csample "ethereal_femininity.wav"
end                           

def self.sixg                 
  csample "120bpmacantholabrus6s_g.wav"
end                           

def self.sixa                 
  csample "120bpmacantholabrus6s_a.wav"
end                           

def self.sixd                 
  csample "120bpmacantholabrus6s_d.wav"
end                           

def self.fourg                
  csample "120bpmacantholabrus4s_g.wav"
end                           

def self.h                    
  csample "120bpm2smagnhildhh.wav"
end                           

def self.d                    
  csample "120bpm2smagnhildbd.wav"
end                           

def self.feedback             
  csample "feedback21.wav"
end                           

def self.house_lead           
  csample "128-bpm-house-lead-fx.wav"
end                           

def self.nasal                
  csample "183669__alienxxx__loop2-009-nasal-120bpm.wav"
end                           

def self.arp                  
  csample "20341__djgriffin__trippyarp120bpm.aif"
end                           

def self.epsilon_four         
  csample "249178__gis-sweden__120bpmepsilon4s-g.wav"
end                           

def self.epsilonix            
  csample "249177__gis-sweden__120bpmepsilon6s-d.wav"
end                           

def self.metaix               
  csample "249179__gis-sweden__120bpmeta6s-g.wav"
end                           

def self.skappa               
  csample "249870__gis-sweden__120bpm10skappa-g.wav"
end                           

def self.fourg                
  csample "120bpmabramis4s_g.wav"
end                           

def self.voc                  
  csample "150399__mikobuntu__voc-formant9.wav"
end                           

def self.drum_13              
  csample "c13.aif"
end                           

def self.drum_14              
  csample "c14.aif"
end                           

def self.drum_2               
  csample "c2.aif"
end                           

def self.gutteral_wobble      
  csample "blip.wav"
end
end
