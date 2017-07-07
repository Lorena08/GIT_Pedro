#!/bin/bash
timeout 600 wkhtmltopdf "$@"

# Exit with exit status of the timeout command
# 124 if command times out
# 125 if timeout itself fails
# 126 if command is found but cannot be invoked
# 127 if command cannot be found
# 137 if command is sent the KILL(9) signal (128+9)
# the exit status of command otherwise
exit $?