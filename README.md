# pibmc-project

To build this runtime image... do the following steps

1a. git clone https://github.com/piBMC/pibmc-project.git
1b. git clone https://github.com/buildroot/buildroot.git
2. make BR2_EXTERNAL=/<parent_dir>/pibmc-project/ menuconfig (save & exit AS IS!!!)
3. make pibmc-rpi1_defconfig
4. make BR2_EXTERNAL=/<parent_dir>/pibmc-project/ menuconfig
5. make (can take up 3 hours)
