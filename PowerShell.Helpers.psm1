<#
 .Synopsis
   A function which returns an ScriptBlock wrapped in retry logic. 

 .Description
   A function which returns an ScriptBlock wrapped in retry logic.

 .Parameter Command
  The ScriptBlock which will be wrapped in retry logic.

 .Parameter Condition
  A ScriptBlock with conditional logic, when true, will break out of the retry loop.

 .Example
 $command = { Invoke-WebRequest https://www.foo.com }
 $condition = { param($response) return $($response.StatusCode -eq 200) -eq $true }
 (Get-CommandWithRetry $command $condition) 5
 #>

function Get-CommandWithRetry($command, $condition) {
  return { 
    param([int]$retries, [int]$sleepSeconds)    
    do {
      $result = & $command      
      if ($(& $condition $result) -eq $true) {
        return $result
        break
      }
      --$retries
      Start-Sleep $sleepSeconds
    } while ($retries -gt 0)

    return $result
  }
}