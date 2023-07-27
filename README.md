# Install OpenWrt on your Atlas Media Router

*[This zine is still a draft. Last updated July 27, 2023.]*

The Iffy Books router challenge is complete! We have a working build of OpenWrt that you can install on the Atlas Media routers we've been hacking away at for the past few months! Retry and Jim are sharing the prize, which we'll award at [Router Hack Day III](https://iffybooks.net/event/router-hack-day-3/) on Saturday, July 29th. We should also thank Anthony, who helped with initial research and did a great job spreading the word about the project.

This post will show you how to install Retry's build of OpenWrt on your Atlas Media AC1200 router (actually a rebranded Tenda FH1205 router). This project doesn't require any soldering, but you will need to disassemble the router's case and connect a couple wires to the board.

If you're interested in soldering wires to the router's serial pinout to access the serial shell, check out our blog post 'Notes from Router Hack Day II.' That post will also get you started on decompressing the router's stock firmware:
❏ https://iffybooks.net/router-hack-day-2

For background info and instructions on gaining telnet access using the router's stock firmware, check out Jim's progress report from March:
❏ https://iffybooks.net/challenge-router-progress

For hardware specs and manuals, check out the event page for our first Router Hack Day event:

❏ https://iffybooks.net/event/router-hack-day

<div style="page-break-after: always;"></div>

## Getting started

❏ Download the OpenWrt firmware from the following URL:
https://iffybooks.net/AtlasMediaOpenWrt.trx

❏ Go to your computer's wi-fi settings and turn off wi-fi completely. Here's what that looks like in Ubuntu Linux:

<img title="" src="./images/6ab034c20d4e423a0ad821d0add65f429a81a49b.png" alt="Screenshot from 2023-07-13 13-09-42.png" width="327" data-align="center">&nbsp;

<div style="page-break-after: always;"></div>

❏ Connect your Atlas Media router to your computer with an ethernet cable. Then attach the power cable.

<img title="" src="./images/3383f7bd8cb24d18522ed908b2102ba3c030da67.png" alt="IMG_6935.png" width="295" data-align="center">&nbsp;

## Give yourself a static IP address

Next you'll assign yourself a static IP address on the network. Here's why this step is necessary: In order to flash new firmware to your router, you'll need to boot into CFE (Common Firmware Environment) mode, a bare-bones version of the router's OS. CFE mode doesn't offer DHCP (Dynamic Host Configuration Protocol), which is the typical way a router assigns IP addresses to connected devices.

<div style="page-break-after: always;"></div>

***Instructions for Ubuntu:***

❏ Go to **Settings > Network**. Under **Wired**, make sure your connection is turned **on**. Then click the **gear** on the right side.

<img title="" src="images/2d2d5fcc9465988903a35a781f4ee3661f2ee4ce.png" alt="Screenshot from 2023-07-13 13-12-10.png" width="661" data-align="center">&nbsp;

<div style="page-break-after: always;"></div>

❏ Go to the **IPv4** tab and make the following changes:

    - Switch **IPv4 Method** to **Manual**.

    - Under **Address**, enter the IP address **192.168.1.X**, replacing X with a number from 0 to 255. 

    - Set **Netmask** to **255.255.255.0**.

<img title="" src="images/7e7faccd2b54ea7ad249495c45472d8a9a7d6003.png" alt="Screenshot from 2023-07-13 13-13-15.png" width="527" data-align="center">&nbsp;

❏ Click **Apply** to save your changes.

<div style="page-break-after: always;"></div>

***Instructions for macOS:***

❏ Go to **System Preferences > Network**. Find your Ethernet interface in the left column and click on it.

❏ Switch **Configure IPv4** to **Manually**.

❏ For **IP Address**, enter **192.168.1.X**, replacing X with a number from 0 to 255.

❏ For **Subnet Mask**, enter **255.255.255.0**.

❏ Click **Apply** to save your changes.

***Instructions for Windows:***

[Coming soon]

<div style="page-break-after: always;"></div>

## Set up your USB serial interface

Your Atlas Media router runs at 3.3V, so you'll want to use a USB serial interface that matches.

❏ Find your **alligator-to-jumper wire** and connect the jumper end to the **GND** pin on your USB serial interface.

<img title="" src="images/cb97a01b3b665000cade14f0dd88761e9ff51611.png" alt="IMG_6947.png" width="281" data-align="center">&nbsp;

<div style="page-break-after: always;"></div>

❏ Attach the **port** end of a **port-to-plug jumper wire** to the **Tx** pin (short for "Transmit").

<img title="" src="images/7bf52165ad84f4e4d529e181b3cb09ae8c584e69.png" alt="IMG_6956.png" width="402" data-align="center">

<div style="page-break-after: always;"></div>

## Remove the router's faceplate

❏ Disconnect the power cable and Ethernet from your router.

❏ Find the screw on the bottom of your router, using a **Phillips-head screwdriver** to pierce through the label. Unscrew the screw and remove the base.

<img title="" src="images/67b751c9dd8e9df0b37f5306156c9d3a097ca14a.png" alt="IMG_6963.png" width="255" data-align="center">&nbsp;

<div style="page-break-after: always;"></div>

❏ With the wider side of the router facing left, pry off the front panel of the case. It's easiest to start at the top corner on the narrow end.

<img title="" src="images/a81bee42b9253d673ef24df8b152619d26537e0a.png" alt="IMG_6984.png" width="437" data-align="center">

<div style="page-break-after: always;"></div>

Here's what the router looks like inside:

<img title="" src="images/6fe21cb379e3f991c3312e1282b87d468a0cca26.png" alt="IMG_6990.png" width="568" data-align="center">

<div style="page-break-after: always;"></div>

❏ Locate the pin indicated in the photo below, which is the **Rx** pin (short for "Receive") for the router's serial pinout. (The Tx pin is directly to the right, and GND is on the left. We're only using the Rx pin for this tutorial.)

<img title="" src="images/048f922c1a3e162eb3d2bace5a2368f4757e342b.png" alt="IMG_6998.png" width="460" data-align="center">

## Install Minicom and test your USB serial interface

❏ In Ubuntu, open a terminal window and run the following command to install [Minicom](https://en.wikipedia.org/wiki/Minicom), a program you'll use to send serial data to your router.

    sudo apt-get install minicom

<div style="page-break-after: always;"></div>

❏ Attach the **USB serial interface** to a USB port on your computer.

<img title="" src="images/b0ec3f9d7c17974cf0eedcc814701b89bade96d9.png" alt="IMG_7002.png" width="492" data-align="center"><br />

❏ Open a terminal window and run the following command to launch a Minicom session:

    minicom -D /dev/ttyUSB0 -c on

<div style="page-break-after: always;"></div>

❏ Next you'll test your USB serial adapter. Touch the plug end of your **Tx** jumper wire to the **Rx** pin, then type a few characters in the Minicom window. If the characters appear onscreen, your USB serial interface is working.

<img title="" src="images/e12281c62ccbb63b66fb3ff98b4a11f12056344b.png" alt="IMG_7005.png" width="251" data-align="center">

<img title="" src="images/582df64a24bd07fd487ca76c0da71ea30b528c47.png" alt="Screenshot from 2023-07-13 13-24-51.png" width="510" data-align="center">

<div style="page-break-after: always;"></div>

## Boot your router into CFE mode

❏ Reconnect the Ethernet cable to your router.

❏ Attach the alligator clip from your USB serial interface to the exposed metal on one or both of the router's external buttons.

<img title="" src="images/06569221e3972a22b7316c57b5a7c375205a512a.png" alt="IMG_7019__.png" width="241" data-align="center"><br />

<img title="" src="images/293b270e4f1c05ea8c294a7ad60fe2133ad79c02.png" alt="IMG_7011.png" width="215" data-align="center">

<div style="page-break-after: always;"></div>

❏ Touch the plug end your **Tx** jumper wire to the **Rx** pin hole indicated in the photo below. Hold it there firmly for the next step.

<img title="" src="images/262b6ef61a6e2933b5b7c6536a51bf59b7c202c7.png" alt="IMG_7020.png" width="434" data-align="center"><br />

❏ Make sure your Minicom terminal window is still open. Plug in your router and immediately press **ctrl+C** on your keyboard repeatedly. You'll need to start less than a second after the router's lights turn on.

<div style="page-break-after: always;"></div>

❏ Open your browser and go to the following address, using **http** at the beginning of the URL instead of "https", which your browser may use by default: **http://192.168.1.1**

If you're in CFE mode, you'll see a page like the one below. If you don't, skip back to the previous step and try again.

<img title="" src="images/24860dc112ca8ce392b8841e6a8bcab43ecdf7c4.png" alt="Screenshot from 2023-07-13 13-31-47.png" width="651" data-align="center">

❏ Click **Browse ...** and select the firmware file, **AtlasMediaOpenWrt.trx**.

❏ Click **Upload** to start uploading the file.

<img title="" src="images/7e73de9f6d2082d4b7fc8e6b3b344bc3fbeff9d7.png" alt="Screenshot from 2023-07-13 13-32-05.png" width="632" data-align="center">

<div style="page-break-after: always;"></div>

❏ When you see the page below, it means your firmware has been uploaded successfully.

<img title="" src="images/8e7c19066365ef0fc58d09460905f39dbadddfb0.png" alt="Screenshot from 2023-07-13 13-32-46.png" width="641" data-align="center">

<div style="page-break-after: always;"></div>

❏ Wait a minute or two for OpenWrt to finish setting up, then go the following address in your browser:
http://192.168.1.1

<img title="" src="images/2d03574321a0b618ba1b850e16371c83b3e628cd.png" alt="Screenshot from 2023-07-13 13-35-17.png" width="651" data-align="center">

❏ There's no password by default. Press enter to log in.

❏ Set a new password.

<img title="" src="images/6de9ab2666529d68a3c30a699e372956c9434236.png" alt="Screenshot from 2023-07-13 13-35-25.png" width="644" data-align="center">

❏ If your home router (or something else) is using the IP address 192.168.1.1, you'll need to change your router's LAN IP address. Change the IP address to 192.168.1.X, where X is a number <= 255, but not 1.

Details at the following URL: https://openwrt.org/docs/guide-user/network/openwrt_as_routerdevice

❏ Before reassembling your router's case, you may want to drill holes in it to provide access to the ground and Rx pins in case you want to re-flash the firmware later.

❏ Remove the alligator clip from the router.

❏ Snap the case back together. (You may want to disconnect power while you do this.)

❏ Screw on the router's base.

## Now the fun begins! If you make something cool with OpenWrt on your Atlas Media router, send an email to iffybooks@iffybooks.net and let us know.
