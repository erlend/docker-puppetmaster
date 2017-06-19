process = IO.popen %w[puppet master --verbose --no-daemonize]

out = process.readline

while !out.include?("Notice: Starting Puppet master") do
  puts(out)
  out = process.readline
end

Process.kill 'KILL', process.pid
Process.wait
