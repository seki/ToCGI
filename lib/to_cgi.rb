#!/usr/local/bin/ruby
require 'socket'

def to_cgi(path)
  soc = UNIXSocket.new(path)
  env = Marshal.dump(ENV.to_hash)
  soc.write([env.size].pack('N'))
  soc.write(env)
  soc.send_io($stdin)
  soc.send_io($stdout)
  soc.read rescue nil
end

if __FILE__ == $0
  path = "/tmp/#{File.basename($0, '.rb')}.soc"
  to_cgi(path)
end
