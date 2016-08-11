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
  def self.find(name: nil, note: nil, max: nil, min: nil)
    @@cache ||= {}
    k = "#{note}#{name}#{max}#{min}"
    if !@@cache.has_key?(k)
      query = ""
      query = "name like '#{name}'" if name
      query += " AND note1=#{note}" if note
      query += " AND length < #{min}" if min
      query += " AND length > #{max}" if max
      r = Dsp.query("select * from notes_fine where #{query}")
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
    k = "#{note}#{octave}#{max}#{min}"
    if !@@cache.has_key?(k)
      query = "note='#{note}'"
      query += " AND octave=#{octave}" if octave
      query += " AND length < #{min}" if min
      query += " AND length > #{max}" if max
      r = Dsp.query("select * from notes_fine where #{query}")
      @@cache[k] = r
    end
    @@cache[k]
  end
  def self.flush
    @@cache = {}
  end
end