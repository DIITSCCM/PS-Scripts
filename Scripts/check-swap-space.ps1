﻿<#
.SYNOPSIS
	Checks the swap space
.DESCRIPTION
	This PowerShell script checks the free swap space.
.PARAMETER MinLevel
	Specifies the minimum level (10 GB by default)
.EXAMPLE
	PS> ./check-swap-space
	✅ Swap space uses 63 GB of 1856 GB.
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

param([int]$MinLevel = 10) # minimum level in GB

function GB2String { param([int64]$Bytes)
        if ($Bytes -lt 1000) { return "$($Bytes)GB" }
        $Bytes /= 1000
        if ($Bytes -lt 1000) { return "$($Bytes)TB" }
        $Bytes /= 1000
        if ($Bytes -lt 1000) { return "$($Bytes)PB" }
        $Bytes /= 1000
        if ($Bytes -lt 1000) { return "$($Bytes)EB" }
}

try {
	[int]$Total = [int]$Used = [int]$Free = 0
	if ($IsLinux) {
		$Result = $(free --mega | grep Swap:)
		[int]$Total = $Result.subString(5,14)
		[int]$Used = $Result.substring(20,13)
		[int]$Free = $Result.substring(32,11)
	} else {
		$Items = Get-WmiObject -class "Win32_PageFileUsage" -namespace "root\CIMV2" -computername localhost 
		foreach ($Item in $Items) { 
			$Total = $Item.AllocatedBaseSize
			$Used = $Item.CurrentUsage
			$Free = ($Total - $Used)
		} 
	}
	if ($Total -eq 0) {
        	"⚠️ No swap space!"
	} elseif ($Free -lt $MinLevel) {
		"⚠️ Swap space has only $(GB2String $Free) of $(GB2String $Total) left to use!"
	} elseif ($Used -eq 0) {
		"✅ Swap space of $(GB2String $Total) is unused."
	} elseif ($Used -lt $Free) {
		"✅ Swap space uses $(GB2String $Used) of $(GB2String $Total)."
	} else {
		"✅ Swap space has $(GB2String $Free) of $(GB2String $Total) left."
	}
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
