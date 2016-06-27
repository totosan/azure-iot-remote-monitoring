Param (
[Parameter(Mandatory=$True,Position=0)]
[string]$resourceGroupName
)

function StopExistingStreamAnalyticsJobs()
{
    Param(
        [Parameter(Mandatory=$true,Position=0)] [string] $resourceGroupName
    )
    $sasJobs = Find-AzureRmResource -ResourceGroupNameContains $resourceGroupName -ResourceType Microsoft.StreamAnalytics/streamingjobs
    if ($sasJobs -eq $null)
    {
        return $false
    }
    Write-Host "$(Get-Date –f $timeStampFormat) - Stopping existing Stream Analytics jobs..."
    $returnValue = $true
    foreach ($sasJob in $sasJobs)
    {
        if ($sasJob.ResourceGroupName -eq $resourceGroupName) {
            $null = Stop-AzureRmStreamAnalyticsJob -Name $sasJob.ResourceName -ResourceGroupName $resourceGroupName
            $job = Get-AzureRmStreamAnalyticsJob -Name $sasJob.ResourceName -ResourceGroupName $resourceGroupName
            if ($job.Properties.LastOutputEventTime -eq $null)
            {
                # If the job never has seen data, use JobStartTime
                $returnValue = $false
            }
        }
    }
    Write-Host "$(Get-Date –f $timeStampFormat) - Stream Analytics jobs stopped"
    return $returnValue
}

$output = ''
if (StopExistingStreamAnalyticsJobs $resourceGroupName)
{
    $output = 'LastOutputEventTime'
}else
{
	$output = 'JobStartTime'
}
	Write-Host "##vso[task.setvariable variable=output]$output"
