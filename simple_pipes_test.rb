require 'test/unit'

# http://ruby-doc.org/core-2.2.1/IO.html#method-c-pipe

class SimplePipesTest < Test::Unit::TestCase


  def test_letter_to_parent
    reader, writer = IO.pipe

    event = 'hi, dad'

    if fork
      writer.close
      assert_equal event, reader.read
      # puts "Parent got: <#{reader.read}>"
      reader.close
      Process.wait
    else
      reader.close # is closing the reader cosmetic?
      puts 'Sending message to parent'
      writer.write event
      writer.close # sends EOF
    end
  end


# a letter to child
  def test_letter_to_parent
    reader, writer = IO.pipe

    event = 'hi, son'

    if fork
      reader.close # is closing the reader cosmetic?
      puts 'Sending message to child'
      writer.write event
      writer.close # sends EOF
      Process.wait
    else
      writer.close
      assert_equal event, reader.read
      # puts "Child got: <#{reader.read}>"
      reader.close
    end

  end


  def test_pipe_as_lifeline
    reader, writer = IO.pipe

    # preventing child from outliving it's parent
    # concept: a pipe as a lifeline

  # TODO - does not seem to work:  try again
    if fork

      # the two processes close the ends of the pipe that they are not using.
      # This is not just a cosmetic nicety.
      # The read end of a pipe will not generate an end of file condition
      # if there are any writers with the pipe still open.
      # In the case of the parent process, the rd.read will never return
      # if it does not first issue a wr.close
      reader.close
      $stderr.puts 'sending message to child'
      writer.write 'hi son'
      writer.close
      Process.wait # nonessential
    else
      writer.close
      $stderr.puts 'in child'

      t = Thread.new do
        $stderr.puts 'in new thread'
        begin

          re = reader.read
          $stderr.puts "child read in thread: #{re}"
          reader.close
            raise 'kaboom'
        rescue Exception
          $stderr.puts "it's just a flesh wound"
          # Kernel.exit
        end
      end
      t.join

    end
  end


end