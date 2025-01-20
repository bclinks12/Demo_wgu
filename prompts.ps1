# Brittany Clinkscales - Student ID: 001265256
<#
    .SYNOPSIS
    This script will prompt end user input for various task.
    
    .DESCRIPTION
    This script provides a menu end user interface for perfroming task present in the Requirements folder.

    .INPUTS
    Interactive end user input via Read-Host

    .OUTPUTS
    The selections are displayed via the end users screen.

    .EXAMPLE
    Run this by typing PS> .\prompts.ps1

    .NOTES
    Author: Brittany Clinkscales
    Student ID: 001265256
    Start Date: 01/07/2025

#>
#Region Functions
function Show-Menu {
    <#
        .SYNOPSIS
        Function to display menu options and collect end user input between options 1-5

        .DESCRIPTION
        Displays a menu for the end user and return the selected options:
        1.  Using regex, list files within the Requirements1 folder, with the .log file extension and redirect the results to a new file called “DailyLog.txt”. (End user selects option 1.)

        2.  List the files inside the “Requirements1” folder in tabular format, sorted in alphabetical order. Direct the results to a new file named “C916contents.txt” within the “Requirements1” folder. 
        (End user selects option 2.)

        3.  List the current CPU & memory usage. (End user selects option 3.)

        4.  List all the different running processes. Sort the output by virtual size used least to greatest, and display it in grid format. (End user selects option 4.)

        5.  Exit script .\prompts.ps1 . (End user selects option 5.)

        .PARAMETER Title
        Displays the string title name -  End User Main Menu Selection
        .PARAMETER Options
        Displays an array of strings that presents (1-5) options for the end user to select
        
    #>
    param (
        [string]$Title = "Main Menu Selection",
        [string[]]$Options

    )
    Write-Verbose "Executes Function Show-Menu"
    
    
    Write-Host $Title
    Write-Host "_____________________________________________________________"
    
    # Write a loop for the exact size for the array of options
    for ($i = 0; $i -lt $Options.Length; $i++)
    {
        # Iterate over the array, write the number, and text for the option that the end user selects
        Write-Host "$($i+1). $($Options[$i])"
    }
    # Prompt the end user for input
    $selection = Read-Host "Please enter a value between 1 - 5"

    
    # Validate the input with RegEx
    if ($selection -match '^\d+$' -and $selection -le $Options.Length)
    {
        # Return the selection
        return $selection
    }
    else 
    {
        # If the input is invalid, inform the user and re-promtp
        Write-Host -ForegroundColor Red "`nInvalid selection. Please select from the current list of option.`n"
        Show-Menu -Title $Title -Options $Options
    }
}
# End of Region Function
    $menuOptions = @("Display Daily Logs","Display file content","Display the current CPU and memory performance metrics","Running Process Report","Exit the Program")
    $UserInput = 1
    
    Try {
        while($UserInput -ne 5) {
            $UserInput = Show-Menu -Title "`nPlease Select an Option from the list below:" -Options $menuOptions

            switch ($UserInput) {
                # End User Selects Option 1 - Display Daily Logs
            1 {         
                #Code for option 1 - Append .log file contents to DailyLog.txt with the current date
                Write-Verbose "Option 1 Selected"
                Write-Host "Display Daily Logs"
                $current_timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $logFiles = Get-ChildItem -Path $PSSCriptRoot | Where-Object { $_.Name -match '\.log$' } | ForEach-Object { $_.Name }
                $output = "[$current_timestamp]`n" + ($logFiles -join "`n")
                Add-Content -Path "$PSSCriptRoot\DailyLog.txt" -Value $output
                
            }
            2 {
                Write-Verbose "Option 2 selected"
                Write-Host "Display file content"
                # List files in tabular format and save to new file named C916contents.txt
                $files = Get-ChildItem -Path $PSSCriptRoot| Sort-Object Name 
                $files | Format-Table | Out-File -FilePath "$PSScriptRoot\C916contents.txt"
                
            }
            3 {
                Write-Verbose "Option 3 selected"
                Write-Host -ForegroundColor Green "Current CPU and memory performance metrics"
                # List current CPU & memory usage
                $current_cpu_usage = (Get-CimInstance Win32_Processor).LoadPercentage
                $memory_usage = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="FreeMemory"; Expression={[math]::Round($_.FreePhysicalMemory / 1KB)}}, @{Name="TotalMemory"; Expression={[math]::Round($_.TotalVisibleMemorySize / 1KB)}}
                Write-Host "CPU Usage: $current_cpu_usage%"
                Write-Host "Memory Usage: Free: $($memory_usage.FreeMemory) MB, Total: $($memory_usage.TotalMemory) MB"
            }
            Catch
            {
                Write-Error "Error retrieving CPU and memory usage: $_"
            }
            4 {
                Write-Verbose "Option 4 selected"
                Write-Host "Running Process Report"
                # List different running processes, sort small to large, and display grid style
                $processes = Get-Process | Sort-Object VirtualMemorySize | Select-Object Name, Id, @{Name="VirtualMemorySize(MB)"; Expression={[math]::Round($_.VirtualMemorySize / 1MB, 2)}}
                $processes | Out-GridView -Title "Running Processes"
            } 
            Catch {[System.OutOfMemoryException] 
            
                Write-Error "Out of memory while listing processes"
                Write-Error "Error listing processes: $_"
            }
            5 {
                Write-Verbose "Option 5 selected"
                Write-Host -ForegroundColor Green "Thanks for using this program. Bye Bye!"
                break
            }
            default {
                Write-Host "Invalid selection. Please try again."
            }
            }
    }
} Catch {
    Write-Error "An error occurred: $_"
} Finally {
    # Close all open resources 
}