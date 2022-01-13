DefinitionBlock ("", "SSDT", 2, "THKP", "_HWAC", 0x00001000)
{
    External (_SB_.LID_, DeviceObj)
    External (_SB_.PCI0.LPCB.H_EC, DeviceObj)
    External (_SB_.SLPB, DeviceObj)
    External (OSDW, MethodObj)    // 0 Arguments
    External (RRBF, IntObj)
    External (XL17, MethodObj)    // 0 Arguments
    
    //HWAC is the only FieldUnitObj longer than 8bits in an EmbeddedControl OperationRegion
    //It has to be splitted, because MacOS can't read fields longer than 8bits 
    Scope (\_SB.PCI0.LPCB.H_EC)
    {
        OperationRegion (ERAM, EmbeddedControl, Zero, 0x0100)
        Field (ERAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0x36), 
            WAC0,   8, 
            WAC1,   8
        }
    }

    Scope (\_GPE)
    {
        
        Method (_L17, 0, NotSerialized)  // _Lxx: Level-Triggered GPE, xx=0x00-0xFF
        {
            If (OSDW ())
            {
                Local0 = (\_SB.PCI0.LPCB.H_EC.WAC0 | (\_SB.PCI0.LPCB.H_EC.WAC1 << 0x08))
                \RRBF = Local0
                Sleep (0x0A)
                If ((Local0 & 0x04))
                {
                    Notify (\_SB.LID, 0x02) // Device Wake
                }

                If ((Local0 & 0x08))
                {
                    Notify (\_SB.SLPB, 0x02) // Device Wake
                }

                If ((Local0 & 0x10))
                {
                    Notify (\_SB.SLPB, 0x02) // Device Wake
                }

                If ((Local0 & 0x80))
                {
                    Notify (\_SB.SLPB, 0x02) // Device Wake
                }
            }
            Else
            {
                //If OSI isn't Darwin, original _L17 Method is called. It goes with the patch that renames _L17 to XL17
                XL17 ()
            }
        }

        Method (LXEN, 0, NotSerialized)
        {
            Return (One)
        }
    }
}

