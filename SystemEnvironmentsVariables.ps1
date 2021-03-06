# System Environment Variable
# [Environment]::SetEnvironmentVariable("MyTestVariable", "MyTestValue", "Machine")

# User Environment Variable
# [Environment]::SetEnvironmentVariable("MyTestVariable", "MyTestValue", "User")


# Run Scripts with Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
    exit 
}

# Script
$targetVariable = [EnvironmentVariableTarget]::User;

$listVariables = @{
    "V1"="valor1"; 
    "V2"="valor2"
};

foreach($lv in $listVariables.Keys) {
   # Write-Host "${lv} : $($listVariables.Item($lv))";
   $item = [Environment]::GetEnvironmentVariable($lv, $targetVariable);

   if ([String]::IsNullOrWhiteSpace($item)) {
       [Environment]::SetEnvironmentVariable($lv, $($listVariables.Item($lv)), $targetVariable);
   } elseif (!$item.Contains($($listVariables.Item($lv)))) {
        $item = "${item}; $($listVariables.Item($lv))";
        [Environment]::SetEnvironmentVariable($lv, $item, $targetVariable);
   }
}