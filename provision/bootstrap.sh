#!/usr/bin/env bash

apt-get update  

# terminate on error
set -e

# steps according to https://open-horizon.github.io/docs/mgmt-hub/docs/
curl -sSL https://raw.githubusercontent.com/open-horizon/devops/master/mgmt-hub/deploy-mgmt-hub.sh -o deploy-mgmt-hub.sh
bash ./deploy-mgmt-hub.sh -c /home/vagrant/mgmt-hub-config.txt
sudo gpasswd -a vagrant docker

# Create new RSFLAB organisation
hzn exchange org create -d 'Resilient Smart Farming Laboratory' -a IBM/agbot RSFLAB --org root --user-pw "hubadmin:CgYAt5aiJo5UI3wA8eaSLRdkIdmNpx"
hzn exchange agbot addpattern IBM/agbot IBM '*' RSFLAB --org root --user-pw "hubadmin:CgYAt5aiJo5UI3wA8eaSLRdkIdmNpx"

# Create new RSFLAB/rsflabadmin user
curl -X 'POST' \
  -u "root/root:fPCDjEPy7ccMeKeJ2Fv7bisESvfzt8" \
  'http://localhost:3090/v1/orgs/RSFLAB/users/rsflabadmin' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "password": "testpassword",
  "admin": true,
  "email": "mail@example.com"
}'


# next test does not run, until PR is merged: https://github.com/open-horizon/devops/pull/163
bash ./test-mgmt-hub.sh -c /home/vagrant/mgmt-hub-config.txt



echo -e "\n\n"
echo -e "Open Horizon Management Hub: Installation and tests finished.\n"
echo "You can now use \`vagrant ssh\` to get into the container."
echo "If you wish to communicate from your host environment with the management hub, "
echo "set the listening IP inside the Virtual Machine:"
echo "    ip address show eth0 | grep 'inet ' # read the external IP address"
echo "    ./deploy-mgmt-hub.sh -S   # stop the mgmt hub services (but keep the data)"
echo "    export HZN_LISTEN_IP=<external-ip>   # an IP address the edge devices can reach"
echo "    export HZN_TRANSPORT=https"
echo "    ./deploy-mgmt-hub.sh"
