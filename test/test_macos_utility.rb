require 'minitest/autorun'
require 'macos_utility'
require 'macos_utility/constants'

class TestMacosUtility < MiniTest::Test
  def test_set_background
    list = Dir["#{Constants::MAC_WALLPAPER_DIR}/*"].select do |file|
      Constants::MAC_ALLOWED_BACKGROUND_IMAGE_TYPES.include?(file.match(/.([\w]*)$/)[1].downcase)
    end
    skip("No mac background images found!") unless list.length > 0
    status = MacosUtility.change_desktop_background(list[0])
    assert_kind_of(Fixnum, status[0], "PID must be a Fixnum class")
  end

  def test_get_processes
    processes = MacosUtility.get_processes
    assert_equal(true, processes.length > 0)
    assert_kind_of(Fixnum, processes[0].pid)
    assert_kind_of(Float, processes[0].cpu)
    assert_kind_of(Float, processes[0].mem)
    assert_kind_of(Fixnum, processes[0].vsz)
    assert_kind_of(Fixnum, processes[0].rss)
  end
end