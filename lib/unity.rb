$LOAD_PATH.unshift("/Users/josephwilk/Workspace/ruby/osc-ruby/lib/")
require "osc-ruby.rb"

def unity(endpoint, *args)
  @uclient ||= OSC::Client.new('localhost', 9000)
  begin
    args = args.map{|a|
      a = (a.is_a?(Symbol) ? a.to_s : a)
      a = (a == Float::INFINITY ? 0.0 : a)
    }
    @uclient.send(OSC::Message.new(endpoint, *args))
  rescue Exception
    #puts $!
    #puts "$!> Graphics not loaded"
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
