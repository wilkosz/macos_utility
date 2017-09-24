require 'timeout'
require 'macos_utility/constants'
require 'macos_utility/process_obj'
# Main MacosUtility module, a static module used for handling Mac Operating System functionality

module MacosUtility

  # Get all running processes
  #
  # Example:
  #   >> MacosUtility.get_processes
  #   => [ProcessObj]
  #
  # Example:
  #   >> MacosUtility.get_processes(process_name: "bash")
  #   => ProcessObj
  #
  # Example:
  #   >> MacosUtility.get_processes(process_id: 1234)
  #   => ProcessObj
  #
  # Arguments:
  #   process_name: (String)
  #   process_id: (Integer)

  def self.get_processes(process_name: nil, process_id: nil)
    command = "ps aux"
    command += " | grep #{process_name}" if process_name
    r, w = IO.pipe

    # dont worry about closing the process with ps command
    begin_process(command, out: w)

    w.close
    stream = r.read.split(/\n/)
    r.close

    stream.shift unless process_name
    stream.select! {|result| result.split(' ').length == 11 && !result.match(/(grep)/)}

    processes = stream.map do |itm|
      # USER               PID  %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
      # joshuawilkosz      313   8.6  5.4 14763108 900940   ??  R     9:49PM   3:27.95 /Applications/RubyMine.app/Contents/MacOS/rubymine -psn_0_69649
      args = itm.split(' ')
      ProcessObj.new(
          args[0],
          args[1].to_i,
          args[2].to_f,
          args[3].to_f,
          args[4].to_i,
          args[5].to_i,
          args[6],
          args[7],
          args[8],
          args[9],
          args[10]
      )
    end
    processes.select! {|process| process.pid == process_id} if process_id && process_name.nil?
    if process_name || process_id
      processes.first
    else
      processes
    end
  end

  # Kill a running process
  #
  # Example:
  #   >> MacosUtility.kill_process(100)
  #   => nil
  #
  # Arguments:
  #   pid: (Integer)

  def self.kill_process(pid)
    return if pid.nil?
    command = "kill -9 #{pid}"
    r, w = IO.pipe

    pid = begin_process(command, out: w)

    w.close
    result = r.read
    r.close
    result
  end

  # Change desktop background
  #
  # Example:
  #   >> MacosUtility.change_desktop_background("/Library/Desktop Pictures/Desert.jpg")
  #   => true
  #
  # Arguments:
  #   file: (String)

  def self.change_desktop_background(file)
    raise Constants::NOT_A_FILE_ERROR unless File.ftype(file) == Constants::FY_FILE_TYPE
    pid = spawn(
        "osascript -e 'tell application \"System Events\" to set picture of every desktop to \"#{file}\"'"
    )
    manage_cmd_process(pid, Constants::UPDATE_DESKTOP_WALLPAPER_TIMEOUT)
  end

  # Manage execution of process with process id handle
  #
  # Example:
  #   >> MacosUtility.manage_cmd_process(10, 10)
  #   => true
  #
  # Arguments:
  #   pid: (Numeric)
  #   limit_seconds: (Numeric)

  def self.manage_cmd_process(pid, limit_seconds)
    begin
      status = nil
      Timeout::timeout(limit_seconds) do
        status = Process.waitpid(pid) if pid
      end
      status
    rescue => e
      if pid
        Process.kill(Constants::KILL_PROCESS_CODE, pid)
        Process.detach(pid)
      end
      raise e.message
    end
  end

  private

  def self.begin_process(command, out: nil, err: nil)
    error = err ? err : out
    Process.spawn(command, :out=>out, :err=>error)
  end
end