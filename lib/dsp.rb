require "mysql2"
module Dsp
  def self.query(sql)
    SonicPi::Core::RingVector.new(Dsp.connection.query(sql,:symbolize_keys => true).to_a)
  end
  def self.connection()
    @@connection ||= Mysql2::Client.new(:host => "localhost", :username => "root", :database => "repl_electric_samples", :reconnect => true)
  end
  def self.connect!()
    @@connection = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "repl_electric_samples",:reconnect => true)
  end
end

module Samples
  def self.sql(query="")
    Dsp.query("select * from samples where #{query}")
  end
  def self.find(path: nil, note: nil, max: nil, min: nil)
    @@cache ||= {}
    k = "samples[note#{note}path#{path}max#{max}min#{min}]"
    if !@@cache.has_key?(k)
      query = []
      query << "path like '%#{path}%'" if name
      query << "note1='#{note}'" if note
      query << "length < #{min}" if min
      query << "length > #{max}" if max
      r = Dsp.query("select * from samples where #{query.join(" AND ")}")
      @@cache[k] = r
    end
    @@cache[k]
  end
  def self.flush
    @@cache = {}
  end
end

module SampleBeats
  def self.sql(query="")
    Dsp.query("select * from track where #{query}")
  end
  def self.find(path: nil, collection: col, filename: f)
    @@cache ||= {}
    k = "path[query]"
    if !@@cache.has_key?(k)
      query = []
      query << "path='#{path}'" if path
      query << "collection='#{path}'" if collection
      query << "collection ='#{f}'" if f
      r = Dsp.query("select * from track where #{query.join(" AND ")} ORDER BY beat")
      puts "results#{r}"
      if r && !r.empty?
        beats = r.map{|r| r[:beat]}
        r = {beats: beats[1..-1]}.merge(r[0])
      end
      @@cache[k] = r
    end
    @@cache[k]
   r
  end
  def self.flush
    @@cache = {}
  end
end

module NoteSlices
  def self.sql(query="")
    Dsp.query("select * from notes_fine64 where #{query}")
  end
  def self.find(root: nil, octave: nil, min: nil, max: nil, note: nil, pat: nil)
    @@cache = {}
    octave = if !note.nil?
      note[-1]
    else
      octave
    end
    root = if !note.nil?
      note[0..-2]
    else
      root
    end
    k = "noteslices[note#{root}octave#{octave}max#{max}min#{min}]"
    if !@@cache.has_key?(k)
      query = []
      query << "note='#{root}'" if root
      query << "octave=#{octave}" if octave
      query << "length > #{min}" if min
      query << "length < #{max}" if max
      query << "path REGEXP '#{pat}'" if pat
      query = query.flatten
      r = Dsp.query("select * from notes_fine64 where #{query.join(" AND ")}")
      @@cache[k] = r
    end
    @@cache[k]
  end
  def self.flush
    @@cache = {}
  end
end
