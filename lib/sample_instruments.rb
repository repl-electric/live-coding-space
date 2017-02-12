module Harp
  def self.slice(n, size: 1/4.0)
    @harp_cache ||= {}
    n = n.to_s.gsub(/s/,"#")
    if !@harp_cache.has_key?(n)
      @harp_cache[n] = NoteSlices.find(note: n, max: size, pat: "harp").take(64)
    end
    @harp_cache[n]
  end
end

module Vocal
  def self.slice(n, size: 1/4.0)
    @vocal_cache ||= {}
    n = n.to_s.gsub(/s/,"#")
    if !@vocal_cache.has_key?(n)
      @vocal_cache[n] = NoteSlices.find(note: n, max: size, pat: "sop|alto|bass").take(64)
    end
    @vocal_cache[n]
  end
end

module Strawberry
  def self.slice(n, size: 1/4.0)
    @straw_cache ||= {}
    n = n.to_s.gsub(/s/,"#")
    if !@straw_cache.has_key?(n)
      @straw_cache[n] = NoteSlices.find(note: n, max: size, pat: "strawberry").take(64)
    end
    @straw_cache[n]
  end
end
