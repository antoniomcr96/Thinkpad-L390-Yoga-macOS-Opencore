# Thinkpad-L390-Yoga-macOS-Opencore
This repository contains the files needed to successfully boot macOS on Lenovo Thinkpad L390 Yoga with Opencore.

<p align="center"><img src="./.github/l390yoga.png" alt="Thinkpad L390 Yoga" width="40%" align="Right"><a href="https://pcsupport.lenovo.com/us/it/products/laptops-and-netbooks/thinkpad-l-series-laptops/thinkpad-l390-yoga-type-20nt-20nu/downloads/ds505882"><img src="https://img.shields.io/badge/BIOS-1.35-blue"></a> &nbsp;&nbsp;<a href="https://github.com/acidanthera/OpenCorePkg"><img src="https://img.shields.io/badge/OpenCore-0.7.5-blue"></a> &nbsp;&nbsp;<img src="https://img.shields.io/badge/MacOS-12-blue"></p>
The project is stable. Mac OS 12 works with Windows 11 in dual boot. There are probably things that can be improved, so feel free to open issues or even PRs with suggestions or observations.<br> <b>This is not a support forum</b>, I won't be able to give individual support. I suggest to use the <a href="https://dortania.github.io/OpenCore-Install-Guide/">Dortania's Opencore Install Guide</a> to build your EFI folder, then compare with this EFI for the last improvements. 

<h2>Configuration</h2>
<div align="center">

| Specifications      | Details                                          |
| :--- | :--- |
| Processor           | Intel Core i5-8265U @ 1.8 GHz          |
| Memory              | 16 GB DDR4 2400 MHz                             |
| Hard Disk           | Crucial P2 SSD PCIe NVMe 512 GB         |
| Integrated Graphics | Intel UHD Graphics 620 |
| Screen              | 13.3 inch with Touchscreen @ 1920 x 1080         |
| Sound Card          | Realtek ALC257 @ layout-id 11                                 |
| Wireless/BT Card       | BCM94350ZAE (Lenovo FRU 00JT494)           |

<img src="./.github/info.png"></div>
- <b>If your laptop has a Samsung PM981 NVMe SSD you have to buy another one</b>, because that drive <a href="https://github.com/tylernguyen/x1c6-hackintosh/issues/43">doesn't work with macOS</a> at all.
- The original network card (Intel wireless 9560NGW) works with <a href="https://github.com/OpenIntelWireless">OpenIntelWireless</a>. Anyway, if you're interested in features such as Airdrop or Handoff, a supported Broadcom card is a better choice. Check <a href="https://dortania.github.io/Wireless-Buyers-Guide/types-of-wireless-card/m2.html">Dortania Wireless Buyers Guide</a>.
  - I chose BCM94350ZAE due to the high cost of BCM94360NG. This card works well with AirDrop, Handoff and Universal Clipboard support. However, Personal Hotspot and Apple Watch Unlock don't work. The guide suggests to set aspm to 0 because the BCM94350ZAE chipset doesn't support power management correctly in macOS. However, I think that it is probably better to mask pin 53 (more info: <a href="https://github.com/acidanthera/bugtracker/issues/794">here</a> and <a href="https://github.com/acidanthera/bugtracker/issues/1646#issuecomment-877663608">here</a>). If you can find and buy it, a BCM94360NG is probably better. Keep in mind that bigger cards such as BCM94350CS2 don't fit this laptop.

<h2>Status</h2>
<h3>What doesn't work and can't be solved in Hackintosh</h3>

- Fingerprint sensor (disabled in BIOS);
- Battery Health Management;
- T2 chip related functions;
- Hardware DRM support (<a href="https://dortania.github.io/OpenCore-Post-Install/universal/drm.html">info</a>);
- Other features related to the native hardware of the Macs that you will find out.

<h3>What doesn't work and could be solved</h3>

- Realtek Card Reader: it can work with <a href="https://github.com/0xFireWolf/RealtekCardReader">this driver</a> by 0xFireWolf. However, I have noticed an increase in power consumption (about 0.5w on idle) with the card reader enabled and the kext, so I prefer to disable it;
- Trackpoint scrolls in the wrong direction (VoodooPS2Controller bug, reported here: <a href="https://github.com/acidanthera/bugtracker/issues/1226">issue 1226</a>);
- Enabling Bootchime breaks Windows audio (more info: <a href="https://github.com/acidanthera/bugtracker/issues/740#issuecomment-860667531">issue 740</a>);
- Personal Hotspot and Unlock with Apple Watch don't work with BCM94350ZAE, you need a native Apple Card. The only native card that fits in this laptop is the BCM94360NG;
- Some features of YogaSMC kext: for info, follow <a href="https://github.com/zhen-zen/YogaSMC/issues/68#">this issue</a> and feel free to contribute;

<h3>What works</h3>
Everything else, including gestures, multitouch, touchscreen, external video output, EC keys, sleep, hibernation, Handoff, Airdrop, ...

<h2>Useful informations</h2>
<h3>BIOS</h3>

- Disable Secure Boot;
- Disable VTd;
- Disable Wake On Lan;
- UEFI/Legacy Boot: UEFI Only;
- CSM Support: it should be disabled, however enable the CSM support avoids the black screen after hibernation (<a href="https://github.com/tylernguyen/x1c6-hackintosh/issues/44#issuecomment-697270496">technical info</a>). There is also an alternative patch at the end of config.plist, which I use in my configuration when I enable hibernation.

<h3>SSDTs</h3>
  
  - <b>SSDT-AWAC-HPET-OSDW</b>: disables RTC device, HPET and injects a OSDW method (useful to check if the system is MacOS);
  - <b>SSDT-DEVICES</b>: patches ADP1 to allow ACPIACAdapter to attach to the device; injects PWRB, DMAC, MCHC, and BUS0 devices (not sure if it makes the difference); injects PGMM, PMCR, SRAM for cosmetic reasons;
  - <b>SSDT-GPRW</b>: personal patch to avoid instant wake after sleep with certain usb devices plugged. It patches _PRW methods and must be associated with the relative ACPI patch in config.plist;
  - <b>SSDT-HWAC</b>: patches the access in the only 16-bit field of EC;
  - <b>SSDT-KEYS</b>: makes the brightness keys work (alternative: <a href="https://github.com/acidanthera/BrightnessKeys">Brightness Keys kext</a>) and patches wrong keys for VoodooPS2Controller;
  - <b>SSDT-PNLF</b>: from the cross-platform <a href="https://github.com/acidanthera/OpenCorePkg/blob/master/Docs/AcpiSamples/Source/SSDT-PNLF.dsl">SSDT</a>, only for Coffee Lake;
  - <b>SSDT-YogaSMC</b>: useful SSDTs from <a href="https://github.com/zhen-zen/YogaSMC/tree/master/YogaSMC/SSDTSample">YogaSMC</a> merged together.

<h3>config.plist</h3>
  
  - <b>Device Properties</b>
    - (0x0)/(0x2,0x0) -> patches platform-ID and device-ID for WhiskeyLake as suggested in the <a href="https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md">Whatevergreen FAQ</a>; patches connectors as suggested in the Dortania guide; patches DVMT allocation;
    - (0x0)/(0x12,0x0) -> allows AppleIntelPCHPMC to attach to PMCR (pci8086,9df9), not sure if useful;
    - (0x0)/(0x1C,0x6)/(0x0,0x0) -> for BCM94350ZAE <b>with pin 53 masked</b>; change aspm if you don't mask the pin; remove if you use other Wireless Cards;
    - (0x0)/(0x1F,0x3) -> audio
  - <b>Kernel</b>/<b>Quirks</b>:
    - AppleCpuPmCfgLock / AppleXcpmCfgLock -> Interestingly, <a href="https://github.com/simprecicchiani/ThinkPad-T460s-macOS-OpenCore/issues/8">system boots even though these two patches are disabled and CFG Lock is enabled</a>. Patching CFGLock (or DVMT), maybe, is possible only with a <a href="https://github.com/tylernguyen/x1c6-hackintosh/blob/main/docs/BIOS.md#modding-the-bios">CH341A + SOIC programmer</a>. Anyway, <a href="https://github.com/digmorepaka/thinkpad-firmware-patches">there isn't any public BIOS full patch</a> (with advanced menu) available for this laptop</a>;
    - SetApfsTrimTimeout -> probably useful for my ssd that <a href="https://github.com/dortania/bugtracker/issues/192">takes more than 10s</a> to complete trim;
  - <b>Kernel</b>/<b>Add</b>:
    - BrcmPatchRAM, BrcmFirmwareData, AirportBrcmFixup are useful for non-native Broadcom network cards, remove if not needed;
    - BlueToolFixup: <a href="https://github.com/acidanthera/BrcmPatchRAM/pull/12">required for Bluetooth</a> with non-native network cards in Monterey. In Big Sur (and older) replace with BrcmBluetoothInjector.kext; 
  - <b>NVRAM</b>
    - rtc-blacklist -> for hibernation. You can remove the content of this entry, along with HibernationFixUp and RTCMemoryFixUp kexts, if you don't use hibernation;
    - hbfx-ahbm = 1445 -> Auto-hibernation. The value means 1: Enable; +4: When External Power is disconnected; +32: When Battery At Critical Level; +128: DisableStimulusDarkWakeActivityTickle, not sure if useful; +256+1024 = 5%;
    - prev-lang:kbd -> change with your language, I'm Italian so I keep it-IT:0;

<img src="https://user-images.githubusercontent.com/63928525/128098815-9685a7e8-2d6e-4cb4-830d-faf16e744709.png" align="right"> These three I2C devices under PCI0 should be removed but I haven't found a way to solve this. VoodooI2C is necessary to make the touchscreen work. <a href="https://github.com/VoodooI2C/VoodooI2C/issues/408">More info</a>.

Battery lasts about 3-4h with a full charge, with a 0.8-1.1W idle power consumption. Undervolting with Voltageshift is a good idea.

<h2>Thanks to</h2>

- <a href="https://github.com/acidanthera">acidanthera</a>
- <a href="https://dortania.github.io/OpenCore-Install-Guide/">Dortania's OpenCore Install Guide</a>
- zhen-zen for <a href="https://github.com/zhen-zen/YogaSMC">YogaSMC</a>
- <a href="https://github.com/VoodooI2C/VoodooI2C">VoodooI2C</a> for the touchscreen driver
- sicreative for <a href="https://github.com/sicreative/VoltageShift">VoltageShift</a>
- benbender and tylernguyen for their well-documented <a href="https://github.com/benbender/x1c6-hackintosh">thinkpad x1c6 hackintosh project</a>
- <a href="https://github.com/5T33Z0/OC-Little-Translated">OC-Little-Translated</a>

<h2>Benchmark</h2>
<p align="center"><img src="./.github/Benchmark.png"></p>
Compare with <a href="https://browser.geekbench.com/v5/cpu/search?utf8=✓&q=MacBook+Pro+2018+i5">these</a>.
  
