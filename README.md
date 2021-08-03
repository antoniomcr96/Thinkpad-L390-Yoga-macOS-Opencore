# Thinkpad-L390-Yoga-macOS-Opencore
This repository contains the files needed to successfully boot macOS on this laptop with Opencore.

<p align="center"><img src="./.github/l390yoga.png" alt="Thinkpad L390 Yoga" width="40%" align="Right"><a href="https://pcsupport.lenovo.com/us/it/products/laptops-and-netbooks/thinkpad-l-series-laptops/thinkpad-l390-yoga-type-20nt-20nu/downloads/ds505882"><img src="https://img.shields.io/badge/BIOS-1.35-blue"></a> &nbsp;&nbsp;<a href="https://github.com/acidanthera/OpenCorePkg"><img src="https://img.shields.io/badge/OpenCore-0.7.2-blue"></a> &nbsp;&nbsp;<img src="https://img.shields.io/badge/MacOS-12-blue"></p>
The project is stable. Mac OS 12 works with Windows 11 in dual boot. There are probably things that can be improved, so feel free to open issues or even PRs with suggestions or observations.<br> <b>This is not a support forum</b>, I won't be able to give individual support. I suggest to use the <a href="https://dortania.github.io/OpenCore-Install-Guide/">Dortania Opencore Install Guide</a> to build your EFI folder, then compare with this EFI for the last improvements. 

<h2>Configuration</h2>
<div align="center">

| Specifications      | Details                                          |
| :--- | :--- |
| Processor           | Intel Core i5-8265U @ 1.8 GHz          |
| Memory              | 16 GB DDR4 2400 MHz                             |
| Hard Disk           | Crucial P2 SSD PCIe NVMe 512 GB         |
| Integrated Graphics | Intel UHD Graphics 620 |
| Screen              | 13.3 inch @ 1920 x 1080         |
| Sound Card          | Realtek ALC257 @ layout-id 11                                 |
| Wireless/BT Card       | BCM94350ZAE (Lenovo FRU 00JT494)           |

<img src="./.github/info.png"></div>
<h2>Status</h2>
<h3>What doesn't work and can't be solved in Hackintosh</h3>

- Fingerprint sensor (disabled in BIOS);
- Battery Health Management;
- T2 chip related functions;
- Hardware DRM support (<a href="https://dortania.github.io/OpenCore-Post-Install/universal/drm.html">info</a>);
- Other features related to the native hardware of the Macs that you will find out.

<h3>What doesn't work and could be solved</h3>

- Trackpoint scrolls in the wrong direction (VoodooPS2Controller bug, reported here: <a href="https://github.com/acidanthera/bugtracker/issues/1226">issue 1226</a>);
- Enabling Bootchime breaks Windows audio (more info: <a href="https://github.com/acidanthera/bugtracker/issues/740#issuecomment-860667531">issue 740</a>);
- Sometimes the backlight of the display doesn't work on boot (solution: close the LID, wait a few seconds, open the LID; any suggestion is appreciated);
- SD card reader: there are probably workarounds, with projects that look promising, such as: <a href="https://github.com/0xFireWolf/RealtekCardReader">this driver</a> (I'm not interested in this device, so I disabled it in BIOS to save power);
- Personal Hotspot and Unlock with Apple Watch don't work with BCM94350ZAE, you need a native Apple Card. The only native card that fits in this laptop is the BCM94360NG;
- Some features of YogaSMC kext: for info, follow <a href="https://github.com/zhen-zen/YogaSMC/issues/68#">this issue</a> and feel free to contribute;

<h3>What works</h3>
Everything else, including gestures, multitouch, touchscreen, EC keys, sleep, hibernation, Handoff, Airdrop, ...

<h2>Useful informations about files</h2>
<details>
  <summary><b>SSDTs</b></summary>
  
  - <b>SSDT-AWAC-GPIO-INIT</b>: disables RTC device, HPET and enables DYTC for YogaSMC;
  - <b>SSDT-DEVICES</b>: patches ADP1 to allow ACPIACAdapter to attach to the device; injects PWRB, DMAC, MCHC, PPMC and BUS0 devices (not sure if it makes the difference); injects PGMM, PMCR, SRAM for cosmetic reasons;
  - <b>SSDT-GPRW</b>: personal patch to avoid instant wake after sleep with certain usb devices plugged. It patches _PRW methods and must be associated with the relative ACPI patch in config.plist;
  - <b>SSDT-HWAC</b>: patches the access in the only 16-bit field of EC;
  - <b>SSDT-KEYS</b>: makes the brightness keys work (alternative: <a href="https://github.com/acidanthera/BrightnessKeys">Brightness Keys kext</a>) and patches wrong keys for VoodooPS2Controller;
  - <b>SSDT-PNLF</b>: personal version of the cross-platform <a href="https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/Source/SSDT-PNLF.dsl">SSDT</a>, only for Whiskey Lake;
  . <b>SSDT-YogaSMC</b>: useful SSDTs from <a href="https://github.com/zhen-zen/YogaSMC/tree/master/YogaSMC/SSDTSample">YogaSMC</a> merged together.
  
</details>
