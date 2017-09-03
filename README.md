# pibmc-project

To build this runtime image... do the following steps

1. git clone https://github.com/piBMC/pibmc-project.git
2. git clone https://github.com/buildroot/buildroot.git
3. make BR2_EXTERNAL=/<parent_dir>/pibmc-project/ menuconfig (save & exit AS IS!!!)
4. make pibmc-rpi1_defconfig
5. make BR2_EXTERNAL=/<parent_dir>/pibmc-project/ menuconfig
6. make (can take up 3 hours)
