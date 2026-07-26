sudo apt install git
sudo apt install git-all
git config --global user.name "IntenseWebsjunk"
git config --global user.email junkmail@intensewebsjunk.com

# ONLY ADD FIRST TIME ONLY (FROM SERVER)
cd ~/Repos && mkdir myfolder && cd myfolder
touch README.md && # touch .gitignore
cp ../COPYING ../LICENSE .
git init --initial-branch=main

# git remote add origin git@github.com:IntenseWebs/myfolder
# git remote rm origin
# git remote add origin gitea@giti.iweb.city:/var/lib/gitea/data/gitea-repositories/iw/cardano-public.git

git add * && git status && git commit * -m "Initial Commit" && git status
git commit -a
git status

# CLONE FROM MAIN
git clone ssh://git@192.168.1.123/~/Repos/servercode servercode
# After changes on remote branch open bash terminal
git remote -v

# PULL TO GET ALL UPDATES (fetches and merges)
git pull

# REFRESH from MASTER/MAIN & PUSH BACK to MAIN/MASTER - cd to repository folder first
git pull origin master
git add *
git commit -a
git commit * -m "Updating . . ."
git remote -v
# git push origin master:refs/heads/upload
git push origin main:refs/heads/upload

# ON MASTER
su -git
cd ~/Repos/servercode
git merge upload

# ONLY IF CHANGED ON GITHUB
git pull git@github.com:IntenseWebs/servercode.git

#PUSH TO GITHUB
cd ~/Repos/myfolder
# ONLY ADD FIRST TIME ONLY (BELOW)
eval "$(ssh-agent -s)"
ssh-add ~/Repos/mykey
git remote add origin git@github.com:IntenseWebs/myfolder.git
git push --mirror origin

# CLONE FROM GITHUB
git clone git@github.com:IntenseWebs/servercode.git
git branch -a

# GIT CHANGES FROM GETHUB - ***DANGEROUS***
git pull --rebase git@github.com:IntenseWebs/servercode.git
git push

git config --list
git log
____________________________________________________________________________
#GIT CLONE TO ONE FILE FOR BACKUP
#! /bin/bash

cd ~
mdkdir git-backup
cd ~/git-backup
cp -f ~/.gitconfig .
cd ~/Repos/cardano-private
git bundle create ~/git-backup/gitbundle-cardano-private --all
cardano-private  cardano-public  dns-backups  giddyupgit  giddyupiw  iw.kdbx  my-code  personal  servercode  windowm
cd ~/Repos/cardano-public
git bundle create ~/git-backup/gitbundle-cardano-public --all
cd ~/Repos/dns-backups
git bundle create ~/git-backup/gitbundle-dns-backups --all
cd ~/Repos/personal
git bundle create ~/git-backup/gitbundle-personal --all
cd ~/Repos/servercode
git bundle create ~/git-backup/gitbundle-servercode --all
cd ~/Repos/windowm
git bundle create ~/git-backup/gitbundle-windowm --all
#
tar -czvf ~/git-backup/Repos.gz /home/git/Repos
