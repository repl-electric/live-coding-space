require "mysql2"
module Dsp
  def self.query(sql)
    SonicPi::Core::RingVector.new(Dsp.connection.query(sql,:symbolize_keys => true).to_a)
  end
  def self.connection()
    @@connection ||= Mysql2::Client.new(:host => "localhost", :username => "root", :database => "repl_electric_samples")
  end
  def self.connect!()
    @@connection = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "repl_electric_samples")
  end
end

module Samples
  def self.sql(query="")
    Dsp.query("select * from samples where #{query}")
  end
  def self.find(path: nil, note: nil, max: nil, min: nil)
    @@cache ||= {}
    k = "note#{note}path#{path}max#{max}min#{min}"
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

module NoteSlices
  def self.sql(query="")
    Dsp.query("select * from notes_fine where #{query}")
  end
  def self.find(note: nil, octave: nil, max: nil, min: nil)
    @@cache ||= {}
    k = "note#{note}octave#{octave}max#{max}min#{min}"
    if !@@cache.has_key?(k)
      query = []
      query << "note='#{note}'" if note
      query << "octave=#{octave}" if octave
      query << "length < #{min}" if min
      query << "length > #{max}" if max
      r = Dsp.query("select * from notes_fine where #{query.join(" AND ")}")
      @@cache[k] = r
    end
    @@cache[k]
  end
  def self.flush
    @@cache = {}
  end
end