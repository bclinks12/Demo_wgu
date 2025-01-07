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
    Write-Host "______________________"
    
    # Write a loop for the exact size for the array of options
    for ($i = 0; $i -lt $Options.Length; $i++)
    {
        # Iterate over the array, write the number, and text for the option that the end user selects
        Write-Host "$($i+1). $($Options[$i])"
    }
    # Prompt the end user for input
    $selection = Read-Host "Please select an option from the following:"
    
    # Validate the input with RegEx
    if ($selection -match '^\d+$' -and $selection -le $Options.Length)
    {
        # Return the selection
        return $selection
    }
    else 
    {
        # If the input is invalid, inform the user and re-promtp
        Write-Host - ForegroundColor Red "`n*Invalid selection. Please select from the current list of option.*`n"
        Show-Menu - Title $Title -Options $Options
    }
    # End of Region Function
    $menuOptions = @("Display Daily Logs","Display files for C916contents.txt folder","Display the current CPU and memory performance metrics","Running Process Report","Exit the Program")
    $UserInput = 1
    
    Try{
        while($UserInput -ne 5)
    }
        $UserInput = Show-Menu -Title "Please Select an Option from the following " -Options $menuOptions

        switch ($UserInput)
        {
            # End User Selects Option 1 - Display Daily Logs
            1
            #Code for option 1 - Append .log file contents to DailyLog.txt with the current date
            {
                Write-Verbose "Option 1 Selected"
                Write-Host "Display Daily Logs"
                $current_timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $logFiles = Get-ChildItem -Path $PSScriptRoot\Requirements1 | Where-Object { $_.Name -match '\.log$' } | ForEach-Object { $_.Name }
                $output = "[$current_timestamp]\n" + ($logFiles -join "`n") + "\n"
                Add-Content -Path "$PSSCriptRoot\DailyLog.txt" -Value $output
                Write-Output "Log files have been successfully appended to DailyLog.txt."
            } catch {
                Write-Error "Error listing .log files: $_"
                    }
        }

}