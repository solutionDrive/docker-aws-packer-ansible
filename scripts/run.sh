#!/bin/bash

set -eo pipefail

/bin/bash /bin/addSSHKey.sh
/bin/bash . /bin/aquireAWSSession.sh
/bin/bash /bin/packerBuild.sh
