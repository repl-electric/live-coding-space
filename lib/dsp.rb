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
