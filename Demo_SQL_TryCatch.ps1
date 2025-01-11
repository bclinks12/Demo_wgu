<# Brittany Clinkscales - Student ID: 001265256 #>

Try 
{
    <# Create Database #>
    Write-Host -ForegroundColor Green "[SQL]: SQL Tasks in Progress"
    #Import SqlServer Module
    if (Get-Module sqlps) { Remove-Module sqlps}
    Import-Module -Name SqlServer

    #Create Variables
    $sqlServerInstanceName = "SRV19-PRIMARY\SQLEXPRESS"
    $databaseName = 'MyDatabase-ReadWriteSQLTableData'
    $schema = "dbo"
    $tableName = 'Myable'

    #1. Check for existence of a database then delete if exist
    $sqlServerObject = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $sqlServerInstanceName
    $databaseObject = Get-SqlDatabase -ServerInstance $sqlServerInstanceName -Name $databaseName -ErrorAction SilentlyContinue
    if($databaseObject) {
        Write-Host -ForegroundColor DarkMagenta "[SQL]: $($databaseName) Database Detected. Deletion in Progress"
        $sqlServerObject.KillAllProcesses($databaseName)
        $databaseObject.UserAccess = "Single"
        $databaseObject.Drop()
    }
    else {
        Write-Host -ForegroundColor Red "[SQL]: $($databaseName) Not Found"
    }
    #4. Recieve Data from CSV File
    $NewClients = Import-Csv -Path $PSScriptRoot\NewClientData.csv
    #3. Create new table
    Write-Host -ForegroundColor Blue "[SQL]: Database creation in progress..."
    $NewClients | Write-SqlTableData - -ServerInstance $sqlServerInstanceName -DatabaseName $databaseName -TableName $tableName -SchemaName $schema -Force

    # Read information
    Read-SqlTableData -ServerInstance $sqlServerInstanceName DatabaseName $databaseName -SchemaName $schema -TableName $tableName
    Write-Host -ForegroundColor Green "[SQL]: SQL Task Complete"
}
#E. Exception Handling
Catch {
    Write-Host -ForegroundColor Red "An Exception Occured"
    Write-Host -ForegroundColor Red "$($PSItem.ToString())`n`n$($PSItem.ScriptStackTrace)"
}
