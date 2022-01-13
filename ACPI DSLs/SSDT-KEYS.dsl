DefinitionBlock ("", "SSDT", 2, "REMAP", "_KBD", 0x00000000)
{
    External (_SB_.PCI0.LPCB.H_EC, DeviceObj)
    External (_SB_.PCI0.LPCB.H_EC.XQ1C, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.H_EC.XQ1D, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.KBD_, DeviceObj)

    Scope (\_SB.PCI0.LPCB.H_EC)
    {
        // Brightness adjustment keys patches. BrightnessKeys.kext is an alternative.
        // In order to use these patches, it's necessary to enable the relative ACPI renames.
        Method (_Q1C, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x0206)
                Notify (\_SB.PCI0.LPCB.KBD, 0x0286)
            }
            Else
            {
                \_SB.PCI0.LPCB.H_EC.XQ1C ()
            }
        }

        Method (_Q1D, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                Notify (\_SB.PCI0.LPCB.KBD, 0x0205)
                Notify (\_SB.PCI0.LPCB.KBD, 0x0285)
            }
            Else
            {
                \_SB.PCI0.LPCB.H_EC.XQ1D ()
            }
        }
    }

    // Fix a strange behavior by certain keys
    Name (_SB.PCI0.LPCB.KBD.RMCF, Package (0x02)
    {
        "Keyboard", 
        Package (0x02)
        {
            "Custom PS2 Map", 
            Package (0x03)
            {
                Package (0x00){}, 
                "46=80", 
                "e045=80"
            }
        }
    })
}

