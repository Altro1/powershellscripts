$gamerunning = $false
$wshell = New-Object -ComObject wscript.shell
while ($true){
    if ($gamerunning -eq $false){
        if ((ps "League of Legends" -ea Ignore) -ne $null){
            $wshell.SendKeys("%{f9}")
            $gamerunning = $true
        }
    } else {
        if ((ps "League of Legends" -ea Ignore) -eq $null){
            $wshell.SendKeys("%{f9}")
            $gamerunning = $false
        }
    }
    sleep 90
}