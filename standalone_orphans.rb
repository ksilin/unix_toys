fork do
  5.times do
    sleep 1
    $stderr.puts "I'm an orphan!"
  end
end
abort 'Parent process died...'