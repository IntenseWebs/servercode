https://youtu.be/xzfHRJNjqDI
https://www.freeipa.org/page/Howto/ISC_DHCPd_and_Dynamic_DNS_update
# FreeIPA requires over 2Gb+ in /usr - Change to root, Check DNS
systemd-resolve --status enp1s0
firewall-cmd --add-service=freeipa-ldap --add-service=freeipa-ldaps --permanent
dnf install freeipa-server freeipa-server-dns nfs-utils
ipa-server-install --mkhomedir

User1 well, i don't know why freeipa thinks you have to use their bind, but all things being equal, i probably wouldn't
Question: I don't have to; it's recommended so I don't have to update zones all the time; to let freeipa do it.
User1 what do you mean update zones all the time?
Question: there are kerberos DNS records to be updated? I'm not sure yet how often they'll get updated?
User1 oh
Question: at least I have the luxury this time to bang my head through it (and backups of all the servers) lol
User1 you're just saying that freeipa does [however often] require modifications to dns data?  and you want freeipa to be able to do that directly,  rather than you going and getting the info and making the changes yourself on freeipa's behalf?
Question: yes
User1 i see
User1 surely freeipa support ddns, yes?
Question: yes
User1 then, all things being equal, there should be no issue with using your existing bind servers
Question: that's what I was thinking; the more I use bind, the more respect I have for it.
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
