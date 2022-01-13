DefinitionBlock ("", "SSDT", 2, "THKP", "INIT", 0x00000000)
{
    External (DSTS, FieldUnitObj)
    External (HPTE, FieldUnitObj)
    External (STAS, IntObj)

    Scope (\)
    {
        // Method that checks if OSI is Darwing to apply certain patches
        Method (OSDW, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (One)
            }

            Return (Zero)
        }

        If (OSDW ())
        {
            // Disable RTC Device - Necessary to boot
            Debug = "RTC Device - AWAC"
            STAS = One
            
            // Disable HPET. Shouldn't be necessary in modern systems and it is disabled in genuine MacBooks
            Debug = "Disable HPET Device"
            HPTE = Zero
        }
    }
}

