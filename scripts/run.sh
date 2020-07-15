#!/bin/bash

set -eo pipefail

/bin/bash /bin/addSSHKey.sh
. /bin/aquireAWSSession.sh
/bin/bash /bin/packerBuild.sh
