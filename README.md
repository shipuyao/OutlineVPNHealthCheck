# OutlineVPNHealthCheck

## Prerequisite 

- Create Service Principle and role assignment to your subscription 
  - https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal
- Install Outline VPN server and client
  - https://getoutline.org/
- Create Azure storage account to save your access key
- Create SAS URL for Outline VPN client 
  - https://learn.microsoft.com/en-us/azure/cognitive-services/translator/document-translation/how-to-guides/create-sas-tokens?tabs=blobs
  
## How does it work?

- Install Outline VPN server in Azure VM
- Install outline VPN client on your phone or computer
- Using Dynamical access key in your client 
  - https://www.reddit.com/r/outlinevpn/wiki/index/dynamic_access_keys/#wiki_dynamic_access_keys
  - Using Azure Blob Storage to save real access key
  - Example: ssconf://Azure_Blob_SAS_URL
- Run health script to check Outline server connection
  - If connection failed, update Outline server VM public IP addresss, update new access key in blob storage

## Build & Publish

- docker build -t shipu/vpnhealthcheck:v1 . 
- docker push shipu/vpnhealthcheck:v1

## How to deploy?

- Run health check script via cron job in domestic network

### v1
  - make sure you set up env in preload.sh file
  - docker run -d -v ${PWD}/preload.sh:/root/preload.sh shipu/vpnhealthcheck:v1

### v2
  - make sure you set up env in healthcheck-env file
  - docker run -v ${PWD}/healthcheck-env:/root/healthcheck-env -it --rm --privileged shipu/vpnhealthcheck:v2   
  ```
  Created symlink /etc/systemd/system/systemd-firstboot.service → /dev/null.
  Created symlink /etc/systemd/system/systemd-udevd.service → /dev/null.
  Created symlink /etc/systemd/system/systemd-modules-load.service → /dev/null.
  Created symlink /etc/systemd/system/multi-user.target.wants/docker-entrypoint.service → /etc/systemd/system/docker-entrypoint.service.
  Created symlink /etc/systemd/system/multi-user.target.wants/vpnhealthcheck.service → /etc/systemd/system/vpnhealthcheck.service.
  /docker-entrypoint.sh: starting /lib/systemd/systemd --show-status=false --unit=docker-entrypoint.target
  systemd 245.4-4ubuntu3.20 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
  Detected virtualization docker.
  Detected architecture x86-64.
  Set hostname to <b2e538e993f8>.
  modprobe@chromeos_pstore.service: Succeeded.
  modprobe@pstore_blk.service: Succeeded.
  modprobe@pstore_zone.service: Succeeded.
  modprobe@ramoops.service: Succeeded.
  + source /etc/docker-entrypoint-cmd
  ++ journalctl -f -u vpnhealthcheck.service
  -- Logs begin at Tue 2023-03-28 14:28:08 UTC. --
  Mar 28 14:28:08 b2e538e993f8 systemd[1]: Starting Cronjob for vpnhealthcheck.service...
  Mar 28 14:28:09 b2e538e993f8 bash[52]: Tue Mar 28 14:28:09 UTC 2023
  ... 
  ...
  Mar 28 14:28:15 b2e538e993f8 bash[51]: Start testing Outline server 20.212.125.164:27909 connectivity
  Mar 28 14:28:15 b2e538e993f8 bash[71]: Connection to 20.212.125.164 27909 port [tcp/*] succeeded!
  Mar 28 14:28:15 b2e538e993f8 bash[51]: Outline server connection is health, PIP rotation skipped
  Mar 28 14:28:15 b2e538e993f8 systemd[1]: vpnhealthcheck.service: Succeeded.
  Mar 28 14:28:15 b2e538e993f8 systemd[1]: Finished Cronjob for vpnhealthcheck.service.
  ^Cgot signal INT
  ```

