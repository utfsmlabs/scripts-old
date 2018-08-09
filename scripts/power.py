from fabric.api import *

@task
@parallel
def reiniciar():
  reboot()