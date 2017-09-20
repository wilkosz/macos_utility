require 'timeout'
require 'macos_utility/constants'

# Main MacosUtility module, a static module used for handling Mac Operating System functionality
module MacosUtility
  # Change desktop background
  #
  # Example:
  #   >> MacosUtility.change_desktop_background("/Library/Desktop Pictures/Desert.jpg")
  #   => true
  #
  # Arguments:
  #   file: (String)

  def self.change_desktop_background(file)
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
      Timeout::timeout(limit_seconds) do
        Process.waitpid(pid) if pid
      end
      true
    rescue => e
      if pid
        Process.kill(Constants::KILL_PROCESS_CODE, pid)
        Process.detach(pid)
      end
      false
    end
  end
end