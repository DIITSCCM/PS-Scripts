﻿<#
.SYNOPSIS
	Lists NIC details
.DESCRIPTION
	This PowerShell script lists the details of the installed network interfaces.
.EXAMPLE
	PS> ./list-nic.ps1
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

try {
	Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Format-Table -property ServiceName,Description,IPAddress,DHCPEnabled -AutoSize
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
