https://youtu.be/xzfHRJNjqDI
https://www.freeipa.org/page/Howto/ISC_DHCPd_and_Dynamic_DNS_update
# FreeIPA requires over 2Gb+ in /usr - Change to root, Check DNS
systemd-resolve --status enp1s0
firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps --permanent
dnf install freeipa-server freeipa-server-dns nfs-utils
ipa-server-install --mkhomedir

Setup complete

Next steps:
        1. You must make sure these network ports are open:
                TCP Ports:
                  * 80, 443: HTTP/HTTPS
                  * 389, 636: LDAP/LDAPS
                  * 88, 464: kerberos
                  * 53: bind
                UDP Ports:
                  * 88, 464: kerberos
                  * 53: bind
                  * 123: ntp

        2. You can now obtain a kerberos ticket using the command: 'kinit admin'
           This ticket will allow you to use the IPA tools (e.g., ipa user-add)
           and the web user interface.

Be sure to back up the CA certificates stored in /root/cacert.p12
These files are required to create replicas. The password for these
files is the Directory Manager password
The ipa-server-install command was successful

#REBOOT

kinit admin
klist

# Setup for client:
sudo yum -y install freeipa-client ipa-admintools
firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps
firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps --permanent
ipa-client-install --mkhomedir --force-ntpd
ipa sudorule-add --cmdcat=all All

# To check sudo rules:
ipa sudorule-find All

ipa sudorule-add ANY \
    --hostcat=all \
    --cmdcat=all \
    --runasusercat=all \
    --runasgroupcat=all

ipa sudorule-add-user ANY \
    --users=user --groups=group

ipa sudorule-add-option ANY \
    --sudooption='!authenticate'


User2 rob0: I *think* freeipa has a named DLZ module that pulls records straight from LDAP
User2 not 100% sure (I know Samba does exactly that for AD-hosted zones, however)
User3 Does it work with IXFR queries, do you know? And I suppose UPDATE queries make the change in the LDAP backend?
User2 never tried IXFR, but yeah, Windows AD hosts heavily use UPDATE queries for self-registration
User2 usually with GSS-TSIG

2. Join the server to the domain.

// Join server to domain
sudo dnf install realmd oddjob oddjob-mkhomedir sssd adcli
sudo realm join -U Administrator internal.domain.com -u Administrator
// Type in domain admin password to authenticate.
// Tweak SSSD
vi /etc/sssd/sssd.conf
fallback_homedir = /home/%u
use_fully_qualified_names = False

3. Install needed packages.

// Install needed packages
sudo dnf update
sudo dnf install git gcc
// Allow weak crypto
update-crypto-policies --set DEFAULT:SHA1