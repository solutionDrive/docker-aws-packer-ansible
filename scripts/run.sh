#!/bin/bash

set -o pipefail

/bin/bash ./addSSHKey.sh
/bin/bash ./aquireAWSSession.sh
/bin/bash ./packerBuild.sh
