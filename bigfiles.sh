#!/bin/bash
find / -type f -size +50000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }' > /files.log
