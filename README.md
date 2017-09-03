# pibmc-project

to build this project... do the following 

1. git clone https://github.com/buildroot/buildroot.git
2. make BR2_EXTERNAL=/<parent_dir>/pibmc-project/ menuconfig (save & exit AS IS!!!)
3. make pibmc-rpi1_defconfig
4. make BR2_EXTERNAL=/<parent_dir>/pibmc-project/ menuconfig
5. make
