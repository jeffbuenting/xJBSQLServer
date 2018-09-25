# xJBSQLServer

SQL DSC Resource that is not found in xSQLServer  

## Installation

To manually install the module, download the source code and unzip the contents of the 'xNETFrameWork' directory to the '$env:ProgramFiles\WindowsPowerShell\Modules folder'.

The **xJBSQLServer** module contains the following Resources:

- **xSQLNetworkProtocol** : Similar to xSQLServerProtocol in xSQLServer.  Only this resource works for Named Pipes, Shared Memory and TCP/IP

##Resources

###xSQLNetworkProtocol

- **`[String]` InstanceName** (_Key_):  SQL Instance to configure  
- **`[String[]]` Protocol** (_Write_): Protocol to configure  
  - **np** = Named Pipes  
  - **sm** = Shared Memory  
  - **tcp** = TCP/IP  
- **`[Ensure]`Ensure** (_Write_): Defaults to 'Present'

##Versions

##Examples
