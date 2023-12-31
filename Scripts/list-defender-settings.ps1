﻿<#
.SYNOPSIS
	Lists the Windows Defender settings
.DESCRIPTION
	This PowerShell script lists the current settings of Windows Defender Antivirus.
	NOTE: use 'Set-MpPreference' to change settings (e.g. DisableScanningNetworkFiles)
.EXAMPLE
	PS> ./list-defender-settings.ps1

	AttackSurfaceReductionOnlyExclusions          :
	CheckForSignaturesBeforeRunningScan           : False
	...
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

try {
	Get-MpPreference
	"NOTE: Documentation at: https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/dn455323(v=vs.85)"
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
