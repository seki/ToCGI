require 'socket'

class ToCGIServer
  def initialize(path, cgi)
    File.unlink(path) rescue nil
    @server = UNIXServer.new(path)
    @cgi = cgi
  end

  def run
    while true
      Thread.new(@server.accept) do |soc|
        begin
          on_client(soc)
        rescue
        ensure
          soc.close
        end
      end
    end
  end

  def on_client(soc)
    sz = soc.read(4)
    buf = soc.read(sz.unpack('N')[0])
    env = Marshal.load(buf)
    sin = soc.recv_io
    sout = soc.recv_io
    @cgi.start(env, sin, sout)
  ensure
    sin.close if sin
    sout.close if sout
  end
end
