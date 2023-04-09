DefinitionBlock ("", "SSDT", 2, "THKP", "DEVICES", 0x00001000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.LPCB.H_EC.ADP1, DeviceObj)
    External (_SB_.PCI0.SBUS, DeviceObj)
    External (LWCP, FieldUnitObj)
    External (OSDW, MethodObj)   
    External (DTGP, MethodObj)

    Scope (\_SB.PCI0.LPCB.H_EC.ADP1)
    {
        //_PRW Method for ADP1 Device
        // https://github.com/khronokernel/DarwinDumped/blob/b6d91cf4a5bdf1d4860add87cf6464839b92d5bb/MacBookPro/MacBookPro15%2C1/ACPI%20Tables/DSL/DSDT.dsl#L5988
        // Patches ADP1 to allow ACPIACAdapter to attach to the device, not sure if useful
        Method (_PRW, 0, NotSerialized)
        {
            If ((\OSDW () || \LWCP))
            {
                Return (Package (0x02)
                {
                    0x17, 
                    0x04
                })
            }

            Return (Package (0x02)
            {
                0x17, 
                0x03
            })
        }
    }

    // Power Button. From OC-Little and
    // https://github.com/khronokernel/DarwinDumped/blob/b6d91cf4a5bdf1d4860add87cf6464839b92d5bb/MacBookPro/MacBookPro15%2C1/ACPI%20Tables/DSL/DSDT.dsl#L6102
    Device (_SB.PWRB)
    {
        Name (_HID, EisaId ("PNP0C0C"))  
        Method (_DSM, 4, NotSerialized) 
        {
                // The following lines, from MBP15,1 DSDT, change the behavior of the Power Button to immediately lock the computer.
                // Without, long press the Power Button shows the shutdown menu. 
                /*If (Arg0 == ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b"))
                {
                    Local0 = Package (0x04)
                        {
                            "power-button-usage", 
                            Buffer (0x08)
                            {
                                 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  
                            }, 

                            "power-button-usagepage", 
                            Buffer (0x08)
                            {
                                 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  
                            }
                        }
                    DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
                    Return (Local0)
                }*/
                Return (Zero)
        }

        Method (_STA, 0, NotSerialized) 
        {
            If (OSDW ())
            {
                Return (0x0B)
            }

            Return (Zero)
        }
    }

    Scope (_SB.PCI0)
    {
        // https://github.com/daliansky/OC-little/blob/master/06-%E6%B7%BB%E5%8A%A0%E7%BC%BA%E5%A4%B1%E7%9A%84%E9%83%A8%E4%BB%B6/SSDT-MCHC.dsl
        // https://github.com/khronokernel/DarwinDumped/blob/b6d91cf4a5bdf1d4860add87cf6464839b92d5bb/MacBookPro/MacBookPro15%2C1/ACPI%20Tables/DSL/DSDT.dsl#L2592
        Device (MCHC)
        {
            Name (_ADR, Zero)  
            Method (_STA, 0, NotSerialized) 
            {
                If (OSDW ())
                {
                    Return (0x0F)
                }

                Return (Zero)
            }
        }

        //Cosmetic Devices. Not necessary
        //Processor Gaussian Mixture Model
        Device (PGMM)
        {
            Name (_ADR, 0x00080000) 
        }
        
        //Thermal Controller
        //https://github.com/khronokernel/DarwinDumped/blob/b6d91cf4a5bdf1d4860add87cf6464839b92d5bb/MacBookPro/MacBookPro15%2C1/ACPI%20Tables/DSL/DSDT.dsl#L4459
        Device (PMCR)
        {
            Name (_ADR, 0x00120000) 
            //Lines from MBP15,1 DSDT
            /*Name (_HID, EisaId ("APP9876"))  // _HID: Hardware ID
            Name (_STA, 0x0B)  // _STA: Status
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                Memory32Fixed (ReadWrite,
                    0xFE000000,         // Address Base
                    0x00010000,         // Address Length
                    )
            })*/
        }

        // Shared SRAM
        Device (SRAM)
        {
            Name (_ADR, 0x00140002) 
        }
        //SPI controller
        //https://github.com/khronokernel/DarwinDumped/blob/b6d91cf4a5bdf1d4860add87cf6464839b92d5bb/MacBookPro/MacBookPro15%2C1/ACPI%20Tables/DSL/DSDT.dsl#L4821
        Device (XSPI)
        {
            Name (_ADR, 0x001F0005)  // _ADR: Address
        }
    }

    // DMA Controller. Not sure if (somehow) useful
    // https://github.com/khronokernel/DarwinDumped/blob/b6d91cf4a5bdf1d4860add87cf6464839b92d5bb/MacBookPro/MacBookPro15%2C1/ACPI%20Tables/DSL/DSDT.dsl#L3254
    Device (_SB.PCI0.LPCB.DMAC)
    {
        Name (_HID, EisaId ("PNP0200") /* PC-class DMA Controller */) 
        Name (_CRS, ResourceTemplate () 
        {
            IO (Decode16,
                0x0000,             // Range Minimum
                0x0000,             // Range Maximum
                0x01,               // Alignment
                0x20,               // Length
                )
            IO (Decode16,
                0x0081,             // Range Minimum
                0x0081,             // Range Maximum
                0x01,               // Alignment
                0x11,               // Length
                )
            IO (Decode16,
                0x0093,             // Range Minimum
                0x0093,             // Range Maximum
                0x01,               // Alignment
                0x0D,               // Length
                )
            IO (Decode16,
                0x00C0,             // Range Minimum
                0x00C0,             // Range Maximum
                0x01,               // Alignment
                0x20,               // Length
                )
            DMA (Compatibility, NotBusMaster, Transfer8_16, )
                {4}
        })
        Method (_STA, 0, NotSerialized)  
        {
            If (OSDW ())
            {
                Return (0x0F)
            }

            Return (Zero)
        }
    }
    
    //Fixing SMBus Support
    //https://dortania.github.io/Getting-Started-With-ACPI/Universal/smbus-methods/manual.html#edits-to-the-sample-ssdt
    Device (_SB.PCI0.SBUS.BUS0)
    {
        Name (_CID, "smbus")  
        Name (_ADR, Zero) 
        Device (DVL0)
        {
            Name (_ADR, 0x57) 
            Name (_CID, "diagsvault") 
            Method (_DSM, 4, NotSerialized)
            {
                If (!Arg2)
                {
                    Return (Buffer (One)
                    {
                         0x57                                 
                    })
                }

                Return (Package (0x02)
                {
                    "address", 
                    0x57
                })
            }
        }

        Method (_STA, 0, NotSerialized)  
        {
            If (OSDW ())
            {
                Return (0x0F)
            }

            Return (Zero)
        }
    }
}

