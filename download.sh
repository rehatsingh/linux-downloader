 #!/bin/bash

 download ()
 {
    cd $HOME/build/linux
    read -p "remove old tarball and build directory before downloading? [Y|n]:" -n1 rm
    rm=${rm:-y}
    if [ $rm == y ]; then
      echo -e "removing old tarball and build directory...\n"
      $root rm linux-$linuxver.tar.xz
      $root rm -rf linux-$linuxver
    fi
    echo "downlidng..."
    wget $link && echo $ver > /home/rehat/build/linux/ver/downloaded
    echo -e "downloded\n"
 }

 extract ()
 {
  
    echo "extracting..."
    tar -xf linux-$ver.tar.xz
    echo -e "extracted\n"

 }

 mrproper ()
 {

    echo "cding into the directory"
    cd $HOME/build/linux/linux-$ver
    sleep 1
    echo "getting ready for build..."
    make mrproper

    echo -e "copping old config...\n"
    $root cp $HOME/build/linux/.config $HOME/build/linux/linux-$ver
    sleep 1
}

 formality ()
{

    echo -e "Ready to build \nRun 'make -j8' and 'make modules_install' as root to build \nOptionaly use the time command before those two commands to know how long it took to build"
    echo "After build rund the post install script as root to install the kernel and nvidia drivers"
}

 echo "parsing link..."

 export link=$(wget --output-document - -q https://www.kernel.org/ | grep -A 1 latest_link | grep http | cut -d'"' -f2)
 #link="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.4.7.tar.xz"
 echo -e "parsed\n"

if hash doas
then 
  export root=doas
  else
    root=sudo
fi

export ver=$(echo "$link" | cut -d '.' -f 4-6 | cut -c 9-13)
linuxver=$(cat /$HOME/build/linux/ver/installed)
downloaded=$(cat /$HOME/build/linux/ver/downloaded)
sleep 1


echo "The latest version is linux $ver"
echo -e "You are using $linuxver\n"
sleep 1

if [ "$downloaded" == "$ver" ] ; then
  if [ "$linuxver" == "$ver" ] ; then
  
  echo "Alredy using the latest stable relese" 
  #echo "tarbal should be in /home/rehat/build/linux"
  else
    echo "alredy downloaded the latest stable relese"
    echo "tarbal should be in $HOME/build/linux"
  fi

  echo "Still continue?"
  read -p "download again (d), extract again (e), run mrproper again (m), download and extract again (de), extract and mrproper again (em), do everything again (a):" again

  case "$again" in
    d) download
    ;;
    e) extract
    ;;
    m) mrproper
       formality
    ;;
    em) extract
        mrproper
        formality
    ;;
    de) download
        extract
    ;;
    a) download
       extract
       mrproper
       formality
    ;;
    *) echo "run the script again to try again. my coding skills are not high enough to compensate for your skill issues."
  esac
   
  else

    download
    extract
    mrproper
    formality
fi
