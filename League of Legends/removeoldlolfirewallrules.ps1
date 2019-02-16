#Checks if script is running as admin, if it's not it restarts it as admin
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    start powershell -Verb runAs -ArgumentList "& $PSCommandPath"
    exit
}

$fw = New-object –comObject HNetCfg.FwPolicy2

$ruleappnames = @()

#Getting the paths for each LoL firewall rule 
foreach ($rule in $fw.Rules){
    if ($rule.Name -eq "League of Legends"){
        $ruleappnames += $rule.ApplicationName
    }
}

#Getting a list of the versions of the League Client from the firewall rules (since I don't wanna delete the most recent firewall rules)
$versions = @()

foreach ($rule in $ruleappnames){
    $versions+=(Split-Path (Split-Path (Split-Path $rule -Parent) -Parent) -Leaf)
}

#Taking only the 2 most recent versions
$versions = ($versions | Sort-Object -Descending -Unique | Select -First 2)

#Deleting all the old firewall rules
foreach ($appname in $ruleappnames){
    if (($appname -notmatch $versions[0]) -and ($appname -notmatch $versions[1])){
        netsh advfirewall firewall delete rule name="League of Legends" program=$appname
    }
}

Write-Host "Old LoL firewall rules have been deleted. Script is finished!"
cmd /c pause