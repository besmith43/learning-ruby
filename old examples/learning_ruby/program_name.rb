# This is a test to change the program name
# This method does not show up in activity monitor on osx, but it does in htop

Process.setproctitle("My new title")

sleep(60)
