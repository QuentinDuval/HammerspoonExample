"""
Following this tutorial to install selenium:
https://selenium-python.readthedocs.io/installation.html#introduction

Following this tutorial to download the chrome drivers:
https://sites.google.com/chromium.org/driver/
https://sites.google.com/chromium.org/driver/getting-started

The first time, you may need to authorise the application
to run: https://support.apple.com/fr-fr/HT202491
"""

import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options 


if __name__ == "__main__":
    chrome_options = Options()  
    # chrome_options.add_argument("--headless")  # To make it in the back-ground
    # chrome_options.binary_location = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'

    driver = webdriver.Chrome(
        executable_path='/path/to/chromedriver',
        options=chrome_options,
    )
    driver.get('http://www.google.com/')
    time.sleep(1)  # Let the user actually see something!

    search_box = driver.find_element_by_name('q')
    search_box.send_keys('Hammerspoon')
    search_box.submit()

    time.sleep(1) # Let the user actually see something!
    driver.quit() # If you want to quit the window, you can comment that to keep it open
