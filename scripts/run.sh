#!/bin/bash

set -eo pipefail

/bin/addSSHKey.sh
. /bin/aquireAWSSession.sh
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN /bin/packerBuild.sh
