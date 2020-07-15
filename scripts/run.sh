#!/bin/bash

set -eo pipefail

/bin/addSSHKey.sh
/bin/aquireAWSSession.sh
/bin/packerBuild.sh
/bin/cleanup.sh
