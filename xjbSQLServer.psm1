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
        Try {
            $This.Protocol = (Get-SQLNetworkProtocol -ErrorAction Stop | where IsEnabled -eq $True).Name
            $This.InstanceName = "MSSQLServer"

            Return $This
        }
        Catch {
            $EXceptionMessage = $_.Exception.Message
            $ExceptionType = $_.exception.GetType().fullname
            Throw "xSQLNetworkProtocol Get : There was an error in retrieving the SQL Network Protocol.`n`n     $ExceptionMessage`n`n     Exception : $ExceptionType" 
        }
    }

    # ----- Test to check if protocols are installed and wether they should be
    [Bool]Test() 
    {
        Write-Verbose "Ensure = $($This.Ensure)"
        Write-Verbose "Protocols = $($This.Protocol)"

        if ( $This.Ensure -eq 'Present' ) 
        {
            try {
                $SQLProtocols = Get-SQLNetworkProtocol -Protocol $This.Protocol -ErrorAction Stop

                write-Verbose "$($SQLProtocols.Name | Out-Null)"
                Foreach ( $P in $SQLProtocols ) 
                {
                    Write-Verbose "====="
                    Write-Verbose "$($P.Name )"
                    if ( $P.isEnabled -eq $False ) 
                    { 
                        Write-Verbose "and they are not"
                        Return $False 
                    }
                }
            }
            Catch 
            {
                $EXceptionMessage = $_.Exception.Message
                $ExceptionType = $_.exception.GetType().fullname
                Throw "xSQLNetworkProtocol Test : Error Checking if Protocol is enabled.`n`n     $ExceptionMessage`n`n     Exception : $ExceptionType" 
            }

            Write-Verbose "And they are"
            Return $True
        }
        Else 
        {
            Write-Verbose "Checking if $($This.Protocol) are disabled"
            Try 
            {
               $SQLProtocols = Get-SQLNetworkProtocol -Protocol $This.Protocol -ErrorAction Stop

                write-Verbose "$($SQLProtocols.Name | Out-Null)"
                Foreach ( $P in $SQLProtocols ) 
                {
                    Write-Verbose "====="
                    Write-Verbose "$($P.Name )"
                    if ( $_.isEnabled -eq $True ) 
                    { 
                        Write-Verbose "and they are not"
                        Return $False 
                    }
                }
            }
            Catch 
            {
                $EXceptionMessage = $_.Exception.Message
                $ExceptionType = $_.exception.GetType().fullname
                Throw "xSQLNetworkProtocol Test : Error Checking if Protocol is Disabled.`n`n     $ExceptionMessage`n`n     Exception : $ExceptionType" 
            }

            Write-Verbose "And they are"
            Return $True
        }
    }
    
    # ----- Install or remove the protocol
    [void]Set()
    {
    Write-Verbose "------------------------------------------------------------------------"
    Write-Verbose "------------------------------------------------------------------------"
    Write-Verbose "------------------------------------------------------------------------"
    Write-Verbose "------------------------------------------------------------------------"
        
        #$SQLProtocols = Get-SQLNetworkProtocol -Protocol $This.Protocol 

        if ( $This.Ensure -eq 'Present' )
        {
            Foreach ( $P in $This.Protocol ) 
            {
                Try {
                    Write-verbose "Enabling $($This.Protocol)"
                    Set-SQLNetworkProtocol -Protocol $P -Enable $True -ErrorAction Stop
                }
                 Catch {
                    $EXceptionMessage = $_.Exception.Message
                    $ExceptionType = $_.exception.GetType().fullname
                    Throw "xSQLNetworkProtocol Set : There was an error in Enabling the SQL Network Protocol, $P.`n`n     $ExceptionMessage`n`n     Exception : $ExceptionType" 
                }
            }
        }
        Else {
            Foreach ( $P in $This.Protocol ) 
            {
                Try {
                    Write-Verbose "Disabling $($This.Protocol)"
                    Set-SQLNetworkProtocol -Protocol $P -Enable $False -ErrorAction Stop
                }
                Catch {
                    $EXceptionMessage = $_.Exception.Message
                    $ExceptionType = $_.exception.GetType().fullname
                    Throw "xSQLNetworkProtocol Set : There was an error in Disabling the SQL Network Protocol, $P.`n`n     $ExceptionMessage`n`n     Exception : $ExceptionType" 
                }
            }
        }
    }
}