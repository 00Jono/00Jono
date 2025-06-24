<#
.NOTES
    Author          : Jonathan Ferreras
    LinkedIn        : linkedin.com/in/https://github.com/00Jono
    GitHub          : https://github.com/00Jono
    Date Created    : 2025-06-24
    Last Modified   : 2025-06-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000005

.TESTED ON
    Date(s) Tested  : 2025-06-24 
    Tested By       : Jonathan Ferreras
    Systems Tested  : 10
    PowerShell Ver. : Powershell ISE

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

<#
.SYNOPSIS
  Configures local account lockout policy to meet STIG requirement WN10-AC-000005.
.DESCRIPTION
  Sets the following:
    - LockoutBadCount = 5 (lockout enabled)
    - LockoutDuration = 15 (minutes)
    - ResetLockoutCount = 10 (minutes)
#>

# --- Configuration (can be customized if needed) ---
$lockoutBadCount     = 5   # Lock account after 5 failed attempts
$lockoutDuration     = 15  # Lockout duration in minutes (STIG minimum)
$resetLockoutCounter = 10  # Reset failed count after 10 minutes

# --- INF Template ---
$infPath = "$env:TEMP\STIG-LockoutPolicy.inf"
$logPath = "$env:TEMP\STIG-LockoutPolicy.log"

$infContent = @"
[Unicode]
Unicode=yes
[System Access]
LockoutBadCount = $lockoutBadCount
LockoutDuration = $lockoutDuration
ResetLockoutCount = $resetLockoutCounter
"@

# --- Write and Apply Policy ---
Write-Host "🔧 Applying STIG-compliant Account Lockout Policy..."
try {
    $infContent | Set-Content -Path $infPath -Encoding Unicode

    secedit /configure /db "$env:windir\security\database\secedit.sdb" /cfg $infPath /log $logPath /quiet

    Write-Host "✅ Account lockout policy applied successfully."
} catch {
    Write-Error "❌ Failed to apply policy: $_"
}
