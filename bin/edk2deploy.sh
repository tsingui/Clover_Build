#!/bin/bash

# Variable 
org=$(svn log -l 1 https://svn.code.sf.net/p/cloverefiboot/code) 
pro_ver=$(echo "\n$org" | sed -n '2p' | awk '{print $1}' | sed 's/r//g') 
author=$(echo "\n$org" | grep -v "\-\-\-\-" | sed -n "1p" | awk '{print $3}' | sed 's/r//g') 
updatetime=$(echo "\n$org" | sed -n '2p' | awk '{print $5}') 
curr_ver=$(ls ~/Documents/Tower/Build_Clover/build/ | sort | sed -n '$p' | perl -nle 'print $& if m{_r\K.*}') 
log=$(echo "\n$org" | sed -n '4p') 
log="$pro_ver: $log by $author" 

# git_tag="r${pro_ver}"
cloversize=1
# flag=0

# Build 
cd ~/Documents/Tower/Build_Clover/ 
if [[ ${pro_ver} > ${curr_ver} ]] ; then 
	
	~/Documents/Tower/Build_Clover/bin/edk2build_1.sh 
	
	# Judge local CLOVER size to avoid error 
	cloversize=$(ls -l ~/src/edk2_micky/Clover/CloverPackage/sym/*.zip | awk '{print $5}') 
	while [[ $cloversize < 13000000 ]] 
	do
		~/Documents/Tower/Build_Clover/bin/edk2build_1.sh 
		cloversize=$(ls -l ~/src/edk2_micky/Clover/CloverPackage/sym/*.zip | awk '{print $5}') 
	done
	
	# Remove old CLOVER in workspace 
#	rm -rf ~/Documents/Tower/Build_Clover/build/* 
#	rm -rf ~/Documents/Tower/Clover_Build/build/* 
#	rm -rf ~/Documents/Tower/Build_Clover_GitLab/build/* 
	
# Copy CLOVER to remote repo
# -------------------------------------------------------------------------------------------------------------------->
	# Copy CLOVER to Gitee workspace 
	mkdir -p ~/Documents/Tower/Build_Clover/build/Clover_v2.4k_r${pro_ver}
	cp ~/src/edk2_micky/Clover/CloverPackage/sym/*.zip ~/Documents/Tower/Build_Clover/build/Clover_v2.4k_r${pro_ver}/ 
	cp ~/src/edk2_micky/Clover/CloverPackage/sym/CloverISO-${pro_ver}/*.iso ~/Documents/Tower/Build_Clover/build/Clover_v2.4k_r${pro_ver} 
	cp ~/src/edk2_micky/Clover/CloverPackage/sym/CloverCD/EFI/CLOVER/CLOVERX64.efi ~/Documents/Tower/Build_Clover/build/Clover_v2.4k_r${pro_ver} 
	
	# Copy CLOVER to GitHub workspace 
	mkdir -p ~/Documents/Tower/Clover_Build/build/Clover_v2.4k_r${pro_ver}
	cp ~/src/edk2_micky/Clover/CloverPackage/sym/*.zip ~/Documents/Tower/Clover_Build/build/Clover_v2.4k_r${pro_ver}/ 
	cp ~/src/edk2_micky/Clover/CloverPackage/sym/CloverISO-${pro_ver}/*.iso ~/Documents/Tower/Clover_Build/build/Clover_v2.4k_r${pro_ver}/ 
	cp ~/src/edk2_micky/Clover/CloverPackage/sym/CloverCD/EFI/CLOVER/CLOVERX64.efi ~/Documents/Tower/Clover_Build/build/Clover_v2.4k_r${pro_ver}/ 
	
	# Copy CLOVER to GitLab workspace 
	mkdir -p ~/Documents/Tower/Build_Clover_GitLab/build/Clover_v2.4k_r${pro_ver}
	cp ~/src/edk2_micky/Clover/CloverPackage/sym/*.zip ~/Documents/Tower/Build_Clover_GitLab/build/Clover_v2.4k_r${pro_ver}/  
	cp ~/src/edk2_micky/Clover/CloverPackage/sym/CloverISO-${pro_ver}/*.iso ~/Documents/Tower/Build_Clover_GitLab/build/Clover_v2.4k_r${pro_ver}/  
	cp ~/src/edk2_micky/Clover/CloverPackage/sym/CloverCD/EFI/CLOVER/CLOVERX64.efi ~/Documents/Tower/Build_Clover_GitLab/build/Clover_v2.4k_r${pro_ver}/  
# <--------------------------------------------------------------------------------------------------------------------

# Push commit to remote repo
# -------------------------------------------------------------------------------------------------------------------->
	# Push to Gitee
	cd ~/Documents/Tower/Build_Clover/ 
	sed -i -e '10a\ ' README.md
	sed -i -e "10a\- $log -- $updatetime" README.md 
	git add . 
	git commit -m "$log"
	# Copy EFI drivers to Gitee workspace 
	rm -rf ~/Documents/Tower/Build_Clover/drivers64UEFI/*.efi 
	cp ~/src/edk2_micky/Clover/CloverPackage/CloverV2/drivers-Off/drivers64UEFI/*.efi ~/Documents/Tower/Build_Clover/drivers64UEFI/ 
	cp ~/src/edk2_micky/Clover/CloverPackage/CloverV2/drivers-Off/drivers64/*.efi ~/Documents/Tower/Build_Clover/drivers64UEFI/ 
	cp ~/drivers64UEFI/apfs*.efi ~/Documents/Tower/Build_Clover/drivers64UEFI/ 
	git add .
	git commit -m "Update all EFI drivers"
#	git tag -a $git_tag -m "$log"
#	git push origin $git_tag
	git push origin master 

	# Push to GitLab
	cd ~/Documents/Tower/Build_Clover_GitLab/
	sed -i -e '10a\ ' README.md
	sed -i -e "10a\- $log -- $updatetime" README.md
	git add .
	git commit -m "$log"
	# Copy EFI drivers to Gitee workspace 
	rm -rf ~/Documents/Tower/Build_Clover_GitLab/drivers64UEFI/*.efi 
	cp ~/src/edk2_micky/Clover/CloverPackage/CloverV2/drivers-Off/drivers64UEFI/*.efi ~/Documents/Tower/Build_Clover_GitLab/drivers64UEFI/ 
	cp ~/src/edk2_micky/Clover/CloverPackage/CloverV2/drivers-Off/drivers64/*.efi ~/Documents/Tower/Build_Clover_GitLab/drivers64UEFI/ 
	cp ~/drivers64UEFI/apfs*.efi ~/Documents/Tower/Build_Clover_GitLab/drivers64UEFI/ 
	git add .
	git commit -m "Update all EFI drivers"
#	git tag -a $git_tag -m "$log"
#	git push origin $git_tag
	git push origin master

	# Push to GitHub
	cd ~/Documents/Tower/Clover_Build/
	sed -i -e '13a\ ' README.md
	sed -i -e "13a\- $log -- $updatetime" README.md
	git add .
	git commit -m "$log"
	# Copy EFI drivers to Gitee workspace 
	rm -rf ~/Documents/Tower/Clover_Build/drivers64UEFI/*.efi 
	cp ~/src/edk2_micky/Clover/CloverPackage/CloverV2/drivers-Off/drivers64UEFI/*.efi ~/Documents/Tower/Clover_Build/drivers64UEFI/ 
	cp ~/src/edk2_micky/Clover/CloverPackage/CloverV2/drivers-Off/drivers64/*.efi ~/Documents/Tower/Clover_Build/drivers64UEFI/ 
	cp ~/drivers64UEFI/apfs*.efi ~/Documents/Tower/Clover_Build/drivers64UEFI/ 
	git add .
	git commit -m "Update all EFI drivers"
#	git tag -a $git_tag -m "$log"
#	git push origin $git_tag
	git push origin master
# <--------------------------------------------------------------------------------------------------------------------

else 
	echo "The local clover version $curr_ver has been already up to date ......" 
fi 
