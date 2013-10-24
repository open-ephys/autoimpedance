=====================
Autoimpedance
=====================

In neuroscience studies, it's important to measure electrode impedances before every experiment. If impedance levels are not in the right range, they must be adjusted by plating electrode tips with gold or platinum. The most common way to do this is with an analog impedance meter and current source, but this method is slow and unreliable. Autoimpedance will be an open-source, digital alternative that aims to speed up the impedance measurement and plating process.

This repository contains code, schematics, and board designs for Autoimpedance. It's based on the Electric Imp and the Analog Devices AD5933_ impedance converter.

Most of the code has been written for Arduino_, but it will soon be translated into Squirrel. PCB layout was done with Eagle_.

What's been done so far
-----------------------------------
- board layout with 32-channel multiplexing capabilities, with the ability to toggle between impedance testing (Analog Devices AD5933) and an adjustable current source (LM234).
- assemble prototype board and verify that multiplexing is working (multiplexing.pde_)
- write code for I2C communication with AD5933 and AD5245 programmable potentiometer (autoimpedance.pde_)

TODO List (short term)
-------------------------------
- calibrate the AD5933 (see instructions in the datasheet_)
- calibrate the LM234 adjustable current source
- create a simple webpage to manually control the device via WiFi
- write and refine a simple feedback algorithm to automatically bring impedance to desired levels
- design and manufacture a case


.. _AD5933: http://www.analog.com/en/rfif-components/direct-digital-synthesis-dds/ad5933/products/product.html
.. _Arduino: http://www.arduino.cc/
.. _Eagle: http://www.cadsoftusa.com/
.. _datasheet: https://github.com/open-ephys/autoimpedance/blob/master/PCB/AD5933.pdf
.. _autoimpedance.pde: https://github.com/open-ephys/autoimpedance/blob/master/autoimpedance.pde
.. _multiplexing.pde: https://github.com/open-ephys/autoimpedance/blob/master/multiplexing.pde
