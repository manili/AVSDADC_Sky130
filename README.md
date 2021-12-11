# AVSDADC_Sky130

AVSDADC_Sky130 is a 10-bit SAR ADC with 3.3v of analog voltage and 1.8v of digital voltage and 1 off-chip external voltage reference.

# Table of Contents

- [Introduction to the AVSDADC_Sky130](#introduction-to-the-avsdadc_sky130)
  - [AVSDADC_Sky130 architecture](#avsdadc_sky130-architecture)
  - [Successive-Approximation Algorithm](#successive-approximation-algorithm)
  - [Sample and Hold Unit](#sample-and-hold-unit)
  - [Comparator Unit](#comparator-unit)
  - [SAR-Logic Unit](#sar-logic-unit)
  - [DAC Unit](#dac-unit)
  - [Timing Management Unit](#timing-management-unit)
- [Prerequisites and Softwares to Install](#prerequisites-and-softwares-to-install)
  - [Dependencies Installation Instructions](#dependencies-installation-instructions)
  - [Ngspice Installation Instructions](#ngspice-installation-instructions)
  - [Xschem Installation Instructions](#xschem-installation-instructions)
  - [Magic Installation Instructions](#magic-installation-instructions)
  - [Netgen Installation Instructions](#netgen-installation-instructions)
  - [Openlane and Sky130 PDK Installation Instructions](#openlane-and-sky130-pdk-installation-instructions)

# Introduction to the AVSDADC_Sky130

AVSDADC_Sky130 is going to be the first 10-bit SAR-ADC by Sky130 technology. So it will open new doors to other people, designing and using such open-source IP core in the future. Our team hope that it will be possible to tape-out the design in the 5th SkyWater/Google shuttle (MPW5).

## AVSDADC_Sky130 architecture

ADC or Analog-to-Digital Convertor is a system that converts an analog signal to a digital number representing the magnitude of the voltage or current. There are several ADC architectures. Due to the complexity and the need for precisely matched components, not all but the most specialized ADCs are implemented as ICs. These typically take the form of MOS mixed-signal IC chips that integrate both analog and digital circuit.

This work is going to use Successive-Approximation ADC architecture in the design. A SAR-ADC uses a comparator and a binary-search to successively narrow a range that contains the input voltage. Successive approximation register (SAR) and the output of the digital to analog converter is updated for a comparison over a narrower range. The SAR register is going to be 10 bits in this work and we’ll use Sky130 as tech node.

## Successive-Approximation Algorithm

The successive-approximation Analog-to-Digital Converter circuit typically consists of four chief sub-circuits:

  1. A sample-and-hold circuit to get the input voltage of `Vin`.
  2. An analog voltage comparator that compares `Vin` to the output of the internal DAC and outputs the result of the comparison to the `successive-approximation register (SAR)`.
  3. A `successive-approximation register` sub-circuit designed to supply an approximate digital code of `Vin` to the internal DAC.
  4. An internal reference DAC that, for comparison with `Vref`, supplies the comparator with an analog voltage equal to the digital code output of the `SARin`.

The `successive-approximation register` is initialized so that the most significant bit is equal to a digital 1. This code is fed into the DAC, which then supplies the analog equivalent of this digital code (`Vref/2`) into the comparator circuit for comparison with the sampled input voltage. If this analog voltage exceeds `Vin`, then the comparator causes the `SAR` to reset this bit; otherwise, the bit is left as 1. Then the next bit is set to 1 and the same test is done, continuing this binary-search until every bit in the `SAR` has been tested. The resulting code is the digital approximation of the sampled input voltage and is finally output by the `SAR` at the `end of the conversion (EOC)`.

## Sample and Hold Unit

As the name suggests, a S&H Circuit samples the input analog signal based on a sampling command and holds the output value at its output until the next sampling command is arrived.

## Comparator Unit

The Comparator compares one analog voltage level with another analog voltage level, or some preset reference voltage, and produces an output signal based on this voltage comparison.

## SAR-Logic Unit

The SAR logic determines the digital output of the MSB based on the comparison result of the comparator. If the output of the comparison circuit is 1, the MSB digital output does not change. If the output of the comparison circuit is 0, the MSB digital output does becomes 0. For a 10-bit ADC it will take 10+2 clock cycles to find a proper value

## DAC Unit

The DAC is an internal Digital-to-Analog Converter that acquires its input from SAR register and convert it to analog signal. This project will use C-2C DAC instead of R-2R DAC.

## Timing Management Unit

D-type Flip-Flop is as a binary divider, for Frequency Division or as a “divide-by-2” counter. A shift register will be used to implement such architecture. The output clock must be low for at least 12 cycles of the main input clock (it is related to SAR Logic) and at least 1 cycle high. However the actual cycle numbers depend upon S&H implementation.

# Prerequisites and Softwares to Install

**Please note that we used Ubuntu 20.04 as our environment**

First, we need to install the following softwares, so that we can continue the design:

* Ngspice
* Xschem
* Magic
* Netgen
* Openlane and Sky130 PDK

## Dependencies Installation Instructions

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

## Ngspice Installation Instructions

[Ngspice Manual](https://sourceforge.net/projects/ngspice/files/ng-spice-rework/35/ngspice-35-manual.pdf/download)

Look into chapter 32 for details of NgSpice installation

First download the tarball from [here](http://sourceforge.net/projects/ngspice/files/ng-spice-rework/35/ngspice-35.tar.gz), then do the following:

```
tar -zxvf <tarball path>
cd <untar path>
mkdir release
cd release/
../configure --with-x --enable-xspice --disable-debug --enable-cider --with-readline=yes
make 2>&1 | tee make.log
sudo make install
which ngspice 
```

## Xschem Installation Instructions

```
git clone https://github.com/StefanSchippers/xschem.git
cd xschem/
./configure && make
sudo make install
which xschem
```

## Magic Installation Instructions

http://opencircuitdesign.com/magic/index.html

```
git clone git://opencircuitdesign.com/magic
cd magic/
./configure
make
sudo make install
which magic
```

## Netgen Installation Instructions

http://opencircuitdesign.com/netgen/index.html

```
git clone git://opencircuitdesign.com/netgen
cd netgen/
./configure
sudo make
sudo make install
which netgen
```

## Openlane and Sky130 PDK Installation Instructions

https://github.com/The-OpenROAD-Project/OpenLane#setting-up-openlane

```
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane/
sudo make pull-openlane
sudo make pdk
sudo make test
```

---

### Components
This repo contains source files of comparator and sample and hold components for a 10-bit ADC.
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
