#require "/Users/josephwilk/Workspace/josephwilk/c++/sonic-pi/app/server/sonicpi/lib/sonicpi/osc/osc.rb"

$LOAD_PATH.unshift("/Users/josephwilk/Workspace/ruby/osc-ruby/lib/")
require "osc-ruby.rb"

#require 'osc-ruby'
unless defined?(SHADER_ROOT)
  SHADER_ROOT = "/Users/josephwilk/Workspace/repl-electric/live-coding-space/lights/"
end
def dshader(endpoint, *args)
  at{sleep 0.5; shader(endpoint, *args)}
end


def unity(endpoint, *args)
  @uclient ||= OSC::Client.new('localhost', 9000)
  begin
    args = args.map{|a| a.is_a?(Symbol) ? a.to_s : a}
    @uclient.send(OSC::Message.new(endpoint, *args))
  rescue Exception
    puts $!
    puts "$!> Graphics not loaded"
  end
end

def viz(*opts)
  ns="/"
  begin
    if !opts[0].is_a?(Hash)
      ns = "/#{opts[0].to_s}/"
      opts = opts[1..-1]
    end
    if opts && !opts.empty?
      (opts[0]||{}).keys.map{|k|
        if k==:camera
          unity "#{ns}camera/#{opts[0][k]}",1
        else
          unity "#{ns}#{k.to_s}", opts[0][k]
        end
      }
    else
      unity "#{ns[0..-2]}",1.0 #bang signal
    end
  rescue Exception
    puts $!
  end
end

def dviz(*args)
  at{sleep 0.5; viz(*args)}
end

def dunity(endpoint, *args)
  at{sleep 0.5; unity(endpoint,*args)}
end

def shader(endpoint, *args)
  if endpoint.is_a?(Array)
    args = if(args[0].is_a?(Array))
      args[0]
    else
      args
    end
    endpoint.zip(args.cycle).each do |thing, value|
      shader(thing, value)
    end
  else
    endpoint = endpoint.to_s.gsub(/_/,"-") #Sorry
    if endpoint == "shader"
      if args && (args.count > 3) && args[-1].is_a?(Numeric)
        shader :uniform, :iVC, args[-1]
      end
    end

    if args.count == 1 &&
        (endpoint.to_s != "shader" && #This really has to die
        endpoint.to_s != "vertex" &&
        endpoint.to_s != "echo" &&
        endpoint.to_s != "fx"
        )
      args = [endpoint] + args
      endpoint = :uniform
    end
    if endpoint == :shader
      args[0] = "#{SHADER_ROOT}/#{args[0]}"
    end
    endpoint = "#{endpoint.to_s.gsub("smooth", "smoothed-uniform")}"
    endpoint = "#{endpoint.to_s.gsub("decay", "decaying-uniform")}"
    endpoint = "/#{endpoint}"
    @client ||= OSC::Client.new('localhost', 9177)
    begin
      args = args.map{|a| a.is_a?(Symbol) ? a.to_s : a}
      @client.send(OSC::Message.new(endpoint, *args))
    rescue Exception
      puts $!
      puts "$!> Graphics not loaded"
    end
  end
end

def shaderinit
  shader :shader, "wave.glsl", "rope.vert", "points", 100000
  shader :iVertexCount, 100000
end


#shader(:shader, "nil.glsl")
#shader(:uniform, "iColorFactor", 0.0)
#live_loop :dance do
#  shader(:suniform, "iColorFactor", 2.0)
#  sample :drum_heavy_kick
#  sleep 1
#end
