param (
[Parameter(Mandatory=$True,Position=0)]
[string]$resourceGroupName
)
$output = ''
. "$(Split-Path $MyInvocation.MyCommand.Path)\..\DeploymentLib.ps1"
if (StopExistingStreamAnalyticsJobs $resourceGroupName)
{
    $output = 'LastOutputEventTime'
}else
{
	$output = 'JobStartTime'
}
	Write-Host "##vso[task.setvariable variable=output]$output"
