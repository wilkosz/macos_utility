class ProcessObj
  attr_accessor :user, :pid, :cpu, :mem, :vsz, :rss, :tty, :stat, :started, :time, :cmd
  def initialize(user, pid, cpu, mem, vsz, rss, tty, stat, started, time, cmd)
    @user = user
    @pid = pid
    @cpu = cpu
    @mem = mem
    @vsz = vsz
    @rss = rss
    @tty = tty
    @stat = stat
    @started = started
    @time = time
    @cmd = cmd
  end
end