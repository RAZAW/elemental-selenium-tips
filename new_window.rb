#filename: new_window.rb

require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

def setup
	geckodriver = File.join(Dir.pwd, 'vendor', 'geckodriver.exe')
	@driver = Selenium::WebDriver.for :firefox, driver_path: geckodriver
end

def teardown
	@driver.quit
end

def run
	setup
	yield
	teardown
end

run do
	@driver.get 'http://the-internet.herokuapp.com/windows'
	@driver.find_element(css: '.example a').click
	@driver.switch_to.window(@driver.window_handles.first)
	expect(@driver.title).not_to equal 'New Window'
	@driver.switch_to.window(@driver.window_handles.last)
	expect(@driver.title).to eql 'New Window'
end

run do
	@driver.get 'http://the-internet.herokuapp.com/windows'
	first_window = @driver.window_handle
	@driver.find_element(css: '.example a').click
	all_windows = @driver.window_handles
	second_window = all_windows.select { |this_window| this_window != first_window }

	@driver.switch_to.window(first_window)
	expect(@driver.title).not_to eql 'New Window'

	@driver.switch_to.window(second_window)
	expect(@driver.title).to eql 'New Window'

end



