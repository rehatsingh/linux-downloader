# linux-downloader
automatically download linux tarball for compilation
tested on arch but the download script should work on all distros

this script tries to copy .config from /home/user/build/linux so keep your .config there
it is recommended to do this manually at least once to familiarize yourself with the process

if you have an nvidia gpu remove the nvidia package and install nvidia-dkms (arch)

how to use
1. make the following directories
/home/user/build/linux/ver
2. run download.sh
3. run make -j(nproc) and make modules_install as root
4. run install.sh as root
5. enjoy

the download script downloads the tarball, extracts it, runs make mrproper and copies the old .config file

the install script copies the bzimage to /boot, installs dynamic kernel modules (for nvidia drivers) and generates initramfs

the install script looks at the passwd file to get the username and home directory of UID 1000 and uses that. so if there are multiple users or your UID is different edit the script accordingly

the install script does NOT regenerate the grub config. I use systendboot.


I just want to clarify that this is my first bash script and GitHub project. I assure you that I have put in my best effort, and I greatly appreciate your support.
