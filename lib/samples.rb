module Sample
def self.cache_key(keys)
  keys.join("-")
end

def self.cached(matchers, match_cache)
  match_cache[Sample.cache_key(matchers)]
end

def self.glob(str)
  Dir[str].sort!
end

def self.filter_samples(samples, matchers)
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
        filter.to_a.map{|f| Sample.filter_samples(filtered_samples, [f])}
      elsif filter.is_a? SonicPi::Core::RingVector
        filter.to_a.map{|f| Sample.filter_samples(filtered_samples, [f])}
      elsif filter.is_a? Array
        filter.map{|f| Sample.filter_samples(filtered_samples, [f])}
      elsif filter == nil
        nil
      else
        filtered_samples.select{|s| s=~ /#{filter}/i}
      end
    end
  end
  result_set = if r && r.length == 1
    r[0]
  else
    if r && !r.empty?
      SonicPi::Core::RingVector.new(r)
    end
  end
  result_set
end

def self.matches(samples, matchers, match_cache)
  result_set = Sample.cached(matchers, match_cache)
  return result_set if result_set
  result_set = filter_samples(samples, matchers)
  match_cache[Sample.cache_key(matchers)] ||= result_set
end
end

#----------------------------Favs
module Tape
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Juno/Soundiron Tape/samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Lo
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Juno/Soundiron Lo/samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Drip
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Juno/Soundiron Drip/samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Crystal
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Juno/Soundiron Crystal/samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Mountain
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Mountain/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end

module Ether
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Ether/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Frag
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Frag/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Fraz
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Dropbox/Music/samples/Frag2/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end

module Dust
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/CPA_TDDC/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Sop
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/soprano/Samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Alt
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Alto/Samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end

module Vocals
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Dropbox/Music/samples/Vocals/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Analog
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/workspace/music/samples/Analog Snares & Claps/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end

#--END

module Organ
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/TownHallOrgan_SP/Samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Corrupt
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/DeviantAcoustics/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module ChillD
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/CHILLSTEP/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Decimated
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Decimated/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Eraser
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Eraser/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Scape
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Soundscape/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Ambi
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
   unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Ambi/**/*.wav"); end
   Sample.matches(@sample_cache, a, @matcher_lookup)
 end
end
module Chill
 @sample_cache = nil; @matcher_lookup = {}
 def self.[](*a)
   unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Chill/**/*.wav"); end
   Sample.matches(@sample_cache, a, @matcher_lookup)
 end
end
module Down
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Down/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Heat
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Heat/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Bass
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Bass/Samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Future
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Future/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Organic
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Organic/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Instruments
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/instruments/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Live
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Live/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Words
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Dropbox/repl-electric/samples/matz/*"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Abstract
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Abstract/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module CineAmbi
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/CineAmbi/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module CineElec
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/CineElec/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Fractured
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Fractured/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end

module Cycles
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Cycles/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end

module FutureE
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/FutureE/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module MagicDust
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/MagicDust/**/*.wav"); end
    if(a[0] == :clack) #named matchers
      a[0] = 21..31
      a = [/MD_ORGANIC_HIT_MID_/] + a
    end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Junk
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Junk/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Dusty
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Dusty/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Tech
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = (Sample.glob("/Users/josephwilk/Workspace/music/samples/Analogue/**/*.wav") +
                                           Sample.glob("/Users/josephwilk/Workspace/music/samples/Pulse/**/*.wav") +
                                          Sample.glob("/Users/josephwilk/Workspace/music/samples/ModTech/**/*.wav")); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Juno
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Juno/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end


module Ambius
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Ambius/Samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Circles
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Circle Bells/Samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Twine
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/TwineBass/Samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Berry
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/strawberry/Samples/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module SevenBass
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Live/seven/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Suburb
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Live/suburban/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
module Org
  @sample_cache = nil; @matcher_lookup = {}
  def self.[](*a)
    unless @sample_cache; @sample_cache = Sample.glob("/Users/josephwilk/Workspace/music/samples/Live/organ/**/*.wav"); end
    Sample.matches(@sample_cache, a, @matcher_lookup)
  end
end
