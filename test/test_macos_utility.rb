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
    assert_equal(true, status)
  end
end