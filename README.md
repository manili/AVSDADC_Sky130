## 10bit ADC

This repo contains source files of comparator and sample and hold components for a 10-bit ADC.

List of tools used to build thses files :

* Ngspice
* Xschem
* PDK (sky130A tech node)

### Tool Installation instructions

**(Tested on 17th Nov 2021 - platform ubuntu 20.04.3 version)**

#### Dependencies

```
# General needed packages
sudo apt install make gcc git iverilog gtkwave docker.io
# Python and Python3 needed package and package manager
sudo apt install python python3 python3-pip python3-tk
# Magic dependencies
sudo apt install m4 csh tcsh libx11-dev tcl-dev tk-dev mesa-common-dev libglu1-mesa-dev libcairo2-dev libncurses-dev
# NgSpice dependencies
sudo apt install bison flex libx11-dev libxaw7-dev libgtk2.0-dev libreadline-dev
# Make sure that the docker is accessable
sudo chmod 666 /var/run/docker.sock
# Openlane Python3 dependencies
python3 -m pip install pyyaml click
```

#### Ngspice

[Ngspice Manual](https://sourceforge.net/projects/ngspice/files/ng-spice-rework/35/ngspice-35-manual.pdf/download)

Look into chapter 32 for details of NgSpice installation

First download the tarball from http://sourceforge.net/projects/ngspice/files/ng-spice-rework/35/ngspice-35.tar.gz, then untar it.

```
tar -zxvf <tarball name>
cd <tarball name>
mkdir release
cd release/
../configure --with-x --enable-xspice --disable-debug --enable-cider --with-readline=yes
make 2>&1 | tee make.log
sudo make install
which ngspice 
```

#### Xschem

```
git clone https://github.com/StefanSchippers/xschem.git
./configure && make
cd xschem/
./configure && make
sudo make install
which xschem
```

#### Magic

http://opencircuitdesign.com/magic/index.html

```
git clone git://opencircuitdesign.com/magic
cd magic/
./configure
make
sudo make install
which magic
```

#### Netgen

http://opencircuitdesign.com/netgen/index.html

```
git clone git://opencircuitdesign.com/netgen
cd netgen/
./configure
sudo make
sudo make install
which netgen
```

#### Openlane

```
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane/
sudo make pull-openlane
sudo make pdk
sudo make test
```

---

### Components
#### Comparator
Comparator specifications are taken from vsdcmp project. This comparator is having zero hystersis. 

Below is the pre-layout simulation for the comparator. 

![Comparator-Prelayout-Simulations](/images/comparator_prelayout_sim.png)

#### Sample and Hold Circuits

This is a simple S&H circuit simulated with a sinusiodal wave of freq 10k and clock with freq 0.2MHz. The timeperiod is uneven with more time for sample and less time for hold phase. 

Below is the pre-layout simulation for Sample and Hold Circuit

![S&H-Prelayout-Simulations](/images/sample_hold_prelayout_sim.png)

### How to run

```
git clone https://github.com/manili/AVSDADC_Sky130
cd AVSDADC_Sky130/
ngspice src/comparator/comparator.spice
ngspice src/s_and_h/simple_sh.spice
```

You will see above simulation graphs for these ngspice runs.
