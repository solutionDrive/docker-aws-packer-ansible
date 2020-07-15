#!/bin/bash

set -eo pipefail

/bin/bash /bin/addSSHKey.sh
/bin/bash source /bin/aquireAWSSession.sh
/bin/bash /bin/packerBuild.sh
