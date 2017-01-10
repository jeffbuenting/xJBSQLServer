Enum Ensure {
    Present
    Absent
}

[DSCResource()]
Class xSQLNetworkProtocol
{
    [DSCProperty(Key)]
    [String]$InstanceName

    [DSCProperty()]
    [ValidateSet( 'np','sm','tcp' )]
    [String[]]$Protocol

    [DSCProperty()]
    [Ensure]$Ensure = 'Present'


    # ----- Gets the info
    [xSQLNetworkProtocol] Get()
    {
        import-module SQLExtras

        $This.Protocol = (Get-SQLNetworkProtocol | where IsEnabled -eq $True).Name
        $This.InstanceName = "MSSQLServer"

        Return $This
    }

    # ----- Test to check if protocols are installed and wether they should be
    [Bool]Test() 
    {
        Import-Module SQLExtras

        if ( $This.Ensure ) 
        {
            Write-Verbose "Checking if $($This.Protocol) are enabled "

            Get-SQLNetworkProtocol -Protocol $This.Protocol | foreach 
            {
                if ( $_.isEnabled -eq $False ) 
                { 
                    Write-Verbose "and they are not"
                    Return $False 
                }
            }

            Write-Verbose "And they are"
            Return $True
        }
        Else 
        {
            Write-Verbose "Checking if $($This.Protocol) are disabled"

            Get-SQLNetworkProtocol -Protocol $This.Protocol | foreach 
            {
                if ( $_.isEnabled -eq $True ) 
                { 
                    Write-Verbose "and they are not"
                    Return $False 
                }
            }

            Write-Verbose "And they are"
            Return $True
        }
    }
    
    # ----- Install or remove the protocol
    [void]Set()
    {
        Import-Module SQLExtras

        if ( $This.Ensure )
        {
            Write-verbose "Enabling $($This.Protocol)"
            Get-SQLNetworkProtocol -Protocol $This.Protocol | Set-SQLNetworkProtocol -Enable $True
        }
        Else {
            Write-Verbose "Disabling $($This.Protocol)"
            Get-SQLNetworkProtocol -Protocol $This.Protocol | Set-SQLNetworkProtocol -Enable $False
        }
    }
}