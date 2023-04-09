DefinitionBlock ("", "SSDT", 2, "THKP", "INIT", 0x00000000)
{
    External (DSTS, FieldUnitObj)
    External (HPTE, FieldUnitObj)
    External (STAS, IntObj)
    External (_SB_.PCI0.XHC_._PRW, PkgObj)
    External (GPRW, MethodObj)    // 2 Arguments


    Scope (\)
    {
        
        // Method that checks if OSI is Darwin to apply (or not) certain patches
        Method (OSDW, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (One)
            }
            Return (Zero)
        }
    
        // GPRW part. This is the package that replaces original GPRW(0x6D, 0x04) calls in DSDT. It goes with its patch in config.plist
        // In MacOS, the second value of the package must be 0x00 to avoid wakes from sleep caused by certain devices
        Name (HPRW, Package (0x02)
        {
            0x6D, 
            0x00
        })   
    
    
        Method (_INI, 0, NotSerialized)  // _INI: Initialize
        {
            If (OSDW())
            {
                // Disable RTC Device - Necessary to boot
                STAS = One
            
                // Disable HPET. Shouldn't be necessary in modern systems and it is disabled in genuine MacBooks
                HPTE = Zero
                
                // GPRW part. In DSDT, XHC._PRW isn't a method but a package, this patches the second value (if system is MacOs)
                \_SB.PCI0.XHC._PRW [One] = Zero
            }
            Else 
            {
                // Otherwise, normally (in Windows, Linux...), HPRW takes the value returned by the original GPRW method
                HPRW = GPRW (0x6D, 0x04)
            }
        }
    }
}

