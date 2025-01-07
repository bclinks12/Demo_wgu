<#
    .SYNOPSIS
    Instrutional Demostration from video.
    .DESCRIPTION
    This script demonstrates Powershell competencies
    .INPUTS
    None
  
    .OUTPUTS
    Output selections to the screen and local folder
    .Example
    run this by typing PS> .\Demo.ps1
    .NOTES
    Author: Brittany Clinkscales
    Student ID:1265256
    Start Date: 01/06/2025
#>

#Regin Functions
function Show-Menu {
    <#
    .SYNOPSIS
        Function to display meny and collect user input
    .DESCRIPTION
        This function displays a menu for the user to select an option
        The options are supplied as a string array parameter
        The user is prompted and the selected input is returned
        Input is validated with a RegEx and will re prompt on invalid selections
    .PARAMETER Title
        The title string to display
    .PARAMETER Options
        The array of string that represents the options to show the end user
    #>
    param (
        [string]$Title = "Main Menu",
        [string[]]$Options
    )
    Write-Verbose "Running Show-Menu Function"

    Write-Host $Title
    Write-Host "=========="

    # Create a loop the size of the array of options that was provided
    for ($i = 0; $i -lt $Options.Length; $i++)
    {
        # Iterate over the array and write the number and text of selection
        Write-Host "$($i+1). $($Options[$i])"
    }
    # Prompt the user for input
    $selection = Read-Host "Please select an option"
    
    # Validate the input with RegEx
    if ($selection -match '^\d+$' -and $selection -le $Options.Length)
    {
        # Return the selection
        return $selection
    }
    else 
    {
        # If the input is invalid, inform the user and re-promtp
        Write-Host - ForegroundColor DarkYellow "'n*Invalid selection. Plkease try again*'n"
        Show-Menu - Title $Title -Options $Options
    }
}
#End Region


$menuOptions = @("Try to divide by zero","report on large Files", "Exit")
$UserInput = 1

Try{
    while($UserInput -ne 3)
    {
        $UserInput = Show-Menu -Title "Demo - Please Select an Item" -Options $menuOptions

        switch ($UserInput)
        {
                # User Selects Option 1, Divided by Zero
            1 
                #Code to run if they chose Option 1
            {
                Write-Verbose "Option 1 Selected"
                Write-Host "Attempting to divide by Zero"
                $i =  1 / 0 # This will deliberately cause an exception.
            }
            2 
                #Code to run if they chose Option 2
            {
                Write-Verbose "Option 2 Selected"
                # Create a variable to store the filename and path for output
                $outputFile = "$PSScriptRoot\LargeFileReport.txt"
                
                #Add a timestamp to the file
                "TIMESTAMP:" + (Get-Date) | Out-File -FilePath $outputFile -Append

                Get-ChildItem -Path $PSScriptRoot -Filter "*.log" | Where-Object{$_.Length -gt 100KB} | Out-File -FilePath $outputFile -Append
            }

            3 
            {
                #Code to run if they chose Option 3
                Write-Verbose "Option 3 selected"
                Write-Host -ForegroundColor Cyan "Thanks for running our demo script!"
            }

        }
    }
}

Catch [System.DivideByZeroException]
{
    Write-Host -ForegroundColor Red "Only Chuck Norris can divide by Zero!"
    Write-Host -ForegroundColor Red "$($PSItem.ToString())`n`n$($PSItem.ScriptStackTrace)"
}
Catch 
{
    Write-Host -ForegroundColor Red "An unhandled Exception Occured"
    Write-Host -ForegroundColor Red "$($PSItem.ToString())`n`n$($PSItem.ScriptStackTrace)"
}
Finally
{
    #Close any open resource
}