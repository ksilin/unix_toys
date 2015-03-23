gem 'minitest'
require 'minitest/autorun'

# The typical way to explicitly orphan a process (so that it gets
# adopted by init) is a double fork:

# I cant get it to work - the innermost fork does not print anything after the first fork exits
class OrphanTest < Minitest::Test

  def test_orphaning
    print_pids

    outer_child_pid = fork {
      print_pids 'first fork'

      inner_child_pid = fork {
        # $stderr.puts "1: the pid of the inner process: #{inner_child_pid}"
        print_pids 'second fork'
        sleep 5
        print_pids 'second fork after being orphaned'
      }
      $stderr.puts "2: the pid of the inner process: #{inner_child_pid}"

      print_pids 'first fork again'
      exit # system("kill -5 #{Process.pid}")
    }
    $stderr.puts "3: the pid of the outer process: #{outer_child_pid || 'oops'}"
    # greppping_outer = "ps ax | grep #{outer_child_pid} | echo"
    # greppping_inner = "ps ax | grep #{inner_child_pid}"
    # puts "is inner alive? #{system(greppping_inner)}"
    res = `ps ax | grep #{outer_child_pid} | echo`
    puts "is outer alive? #{res}"
    # Process.waitall - does not help at all
  end

  # does not work in a test - the test quits once the parent is dead
  # TODO - SO - is there a better way? grab the std FDs perhaps?
  def test_orphaning2

    path = File.expand_path('../../standalone_orphans.rb', __FILE__)
    system("ruby #{path}")
    Process.waitall
    # here, we are expecting the orphans to print something, but they never do
    # probabaly all children are bing killed once the test finishes
  end

  private

  def print_pids(proc_name = 'main')
    $stderr.puts proc_name
    $stderr.puts "pid: #{Process.pid}"
    $stderr.puts "ppid: #{Process.ppid}"
    $stderr.puts '----------'
  end

end