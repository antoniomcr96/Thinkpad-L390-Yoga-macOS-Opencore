DefinitionBlock ("", "SSDT", 2, "OCLT", "GPRW", 0x00000000)
{
    External (_SB_.PCI0.XHC_._PRW, PkgObj)
    External (GPRW, MethodObj)    // 2 Arguments
    External (OSDW, MethodObj)    // 0 Arguments

    // This is the package that replaces original GPRW(0x6D, 0x04) calls in DSDT. It goes with its patch in config.plist
    // In MacOS, the second value of the package must be 0x00 to avoid wakes from sleep caused by certain devices
    Name (HPRW, Package (0x02)
    {
        0x6D, 
        0x00
    })        
    

    If (OSDW ())
    {
        // In DSDT, XHC._PRW isn't a method but a package, this patches the second value (if system is MacOs)
        \_SB.PCI0.XHC._PRW [One] = Zero
    } 
    Else {
        // Otherwise, normally (in Windows, Linux...), HPRW takes the value returned by the original GPRW method
        HPRW = GPRW (0x6D, 0x04)
    }
}

