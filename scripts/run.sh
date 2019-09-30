#!/bin/bash

set -o pipefail

/bin/bash /bin/addSSHKey.sh
/bin/bash /bin/aquireAWSSession.sh
/bin/bash /bin/packerBuild.sh
