# ===================================================================================
# CLI COLORIZATION
#
# This script allows you to print different colorized text in your CI output. Since
# we are running in Docker, we create a number of small helper scripts that are added
# into the PATH (rather than using aliases).
# See: https://misc.flogisoft.com/bash/tip_colors_and_formatting
#      https://stackoverflow.com/a/5947802/1356593


pRED='\033[0;31m'
pBOLD_RED='\033[0;1;31m'
pBLUE='\033[0;34m'
pBOLD_BLUE='\033[0;1;34m'
pGREEN='\033[0;32m'
pBOLD_GREEN='\033[0;1;32m'
pRESET='\033[0m'

# See: https://stackoverflow.com/a/36388856/1356593
function create_color_function {
  function_name=$1
  color_code=$2
  touch /usr/local/bin/$function_name
  echo '#!/bin/sh'                      >> /usr/local/bin/$function_name
  echo "printf \"${color_code}\$1\\n\"" >> /usr/local/bin/$function_name
  echo "printf \"${pRESET}\""           >> /usr/local/bin/$function_name
  chmod +x /usr/local/bin/$function_name
}

create_color_function blue $pBLUE
create_color_function blue_bold $pBOLD_BLUE
create_color_function red $pRED
create_color_function green $pGREEN
create_color_function green_bold $pBOLD_GREEN