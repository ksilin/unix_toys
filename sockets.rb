require 'socket'

sock1 = Socket.new(:INET, :STREAM)
addr1 = Socket.pack_sockaddr_in(8888, '0.0.0.0')
sock1.bind(addr1)
sock1.listen(10)
puts "socket open for connections: #{sock1.inspect}"

sock2 = Socket.new(:INET, :STREAM)
addr2 = Socket.pack_sockaddr_in(9999, '0.0.0.0')
sock2.bind(addr2)
sock2.listen(10)
puts "socket open for connections: #{sock2.inspect}"

5.times do |i|
  fork do
    puts "i'm listening... nr #{i}"
    loop do
      readable, _, _ = IO.select([sock1, sock2]) # what would be different when using accept instead of select

      connection, _ = readable.first.accept
      puts "[#{Process.pid}, worker#{i}] #{connection.read}"
      connection.close
    end
  end
end

Process.wait
