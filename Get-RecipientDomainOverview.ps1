<#
    .SYNOPSIS
    Find Exchange recipient objects for a single or multiple domains.
   
    Thomas Stensitzki
	
    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE 
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
	
    Version 1.0, 2021-09-14

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
  [string]$DomainFile = '',
  [string]$Domain = '',
  [switch]$ExportUsersToCsv
)

# Script Path
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

$domainList = @()

function Get-RecipientsForDomain {
  param (
    [string]$DomainName = ''
  )
  
  if ($DomainName -ne '') {

    Write-Verbose -Message ('Searching recipients for [{0}]' -f $DomainName)
    
    $recipients = Get-Recipient -ResultSize Unlimited | Where {$_.EmailAddresses -like "*@$DomainName"}

    $object = New-Object -TypeName psobject
    $object | Add-Member -MemberType NoteProperty -Name DomainName -Value $DomainName
    $object | Add-Member -MemberType NoteProperty -Name RecipientCount -Value ($recipients | Measure-Object).Count

    if($ExportUsersToCsv) {
        $csvFile = Join-Path -Path $scriptPath -ChildPath ('Recipients-{0}.csv' -f $DomainName)
        $recipients | Sort-Object Name | Select Name,PrimarySmtpAddress,RecipientType | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8 -Force -Confirm:$false
    }
  }

  $object
}

if($Domain -ne '') {
  Write-Host ('Calling Get-RecipientsForDomain for [{0}]' -f $DomainName)
  
    $domainList += Get-RecipientsForDomain -DomainName $Domain.Trim()

    $domainList
}
elseif ($DomainFile -ne '') {
    $domainFilePath = Join-Path -Path $scriptPath -ChildPath $DomainFile

    if(Test-Path -Path $domainFilePath) {
        $domainsToCheck = Get-Content -Path $domainFilePath
        foreach($Domain in $domainsToCheck) {
            $domainList += Get-RecipientsForDomain -DomainName $Domain.Trim()
        }
    }

    $domainList
}
else {
  Write-Warning 'Nothing to do.'
}
