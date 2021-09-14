<#
    .SYNOPSIS
    Find Exchange recipient objects for a single or multiple domains.
   
    Thomas Stensitzki
	
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
	
    Version 1.1, 2021-09-14

    Ideas, comments, and suggestions via GitHub.
 
    .LINK  
    http://www.granikos.eu/en/scripts
   
	
    .DESCRIPTION
	
    This script finds recipient objects for a single domain or a list of domains. An overview
    containing the number of found recipients is displayed as output.
    You can export recipient details as CSV if needed.
    
    Tested with Exchange Server 2016 and Exchange Server 2019.

    .NOTES 
    Requirements 
    - Windows Server 2016+     
    - Administrative Exchange Server 2016+ Management Shell

    Revision History 
    -------------------------------------------------------------------------------- 
    1.0 Initial community release 
    1.1 Some PowerShell performance enhancements
    
	
    .PARAMETER DomainFile
    Filename of a simple txt file containing one domain name per row.

    .PARAMETER Domain
    A single domain name.

    .PARAMETER ExportUsersToCsv
    Switch to export recipients. The script creates a single file per domain.

    .EXAMPLE
    Search for recipients that have a proxy address of domains provided in the TXT file domains.txt and export all users to a CSV file
    .\Get-RecipientDomainOverview.ps1 -DomainFile .\domains.txt -ExportUsersToCsv

    .EXAMPLE
    Search for recipients that have a proxy address of varunagroup.de and display the summary only
    .\Get-RecipientDomainOverview.ps1 -Domain varunagroup.de

#>
param (
  [Parameter(ParameterSetName = 'DomainFile')]
  [string]$DomainFile = '',

  [Parameter(ParameterSetName = 'Domain')]
  [string]$Domain = '',

  [Parameter(ParameterSetName = 'DomainFile')]
  [Parameter(ParameterSetName = 'Domain')]
  [switch]$ExportUsersToCsv
)

# Script Path
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

$domainList = @()

function Get-RecipientObjects {
  Write-Host ('Gathering recipient objects. It might take some time.')
  $script:recipients = Get-Recipient -ResultSize Unlimited
}

function Get-RecipientsForDomain {
  [CmdletBinding()]
  param (
    [string]$DomainName = ''
  )
  
  if ($DomainName -ne '') {

    Write-Verbose -Message ('Searching recipients for [{0}]' -f $DomainName)
    
    $filteredRecipients = $script:recipients | Where-Object {$_.EmailAddresses -like ('*@{0}' -f $DomainName)}

    $object = New-Object -TypeName psobject
    $object | Add-Member -MemberType NoteProperty -Name DomainName -Value $DomainName
    $object | Add-Member -MemberType NoteProperty -Name RecipientCount -Value ($filteredRecipients | Measure-Object).Count

    if($ExportUsersToCsv -and ((($filteredRecipients | Measure-Object).Count) -gt 0)) {
      $csvFile = Join-Path -Path $scriptPath -ChildPath ('Recipients-{0}.csv' -f $DomainName)
      $filteredRecipients | Sort-Object -Property Name | Select-Object -Property Name,PrimarySmtpAddress,RecipientType | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8 -Force -Confirm:$false
    }
  }

  $object
}

if($Domain -ne '') {
  
  Get-RecipientObjects
  
  Write-Verbose -Message ('Calling Get-RecipientsForDomain for [{0}]' -f $Domain)
  
  $domainList += Get-RecipientsForDomain -DomainName $Domain.Trim()

  $domainList
}
elseif ($DomainFile -ne '') {
  
  Get-RecipientObjects

  $domainFilePath = Join-Path -Path $scriptPath -ChildPath $DomainFile

  if(Test-Path -Path $domainFilePath) {
    $domainsToCheck = Get-Content -Path $domainFilePath
    foreach($Domain in $domainsToCheck) {
      Write-Verbose -Message ('Calling Get-RecipientsForDomain for [{0}]' -f $Domain)
      $domainList += Get-RecipientsForDomain -DomainName $Domain.Trim()
    }
  }

  $domainList
}
else {
  Write-Warning -Message 'Nothing to do.'
}
