# Get-RecipientDomainOverview.ps1

Find Exchange recipient objects for a single or multiple domains.

## Description

This script finds recipient objects for a single domain or a list of domains. An overview containing the number of found recipients is displayed as output.

You can export recipient details as CSV if needed.

Tested with Exchange Server 2016 and Exchange Server 2019.

## Requirements

- Windows Server 2016 or newer
- Utilizes the global function library found here: [http://scripts.granikos.eu](http://scripts.granikos.eu)
- Exchange Server 2016+
- Exchange Management Shell (EMS)

## Updates

- 2021-09-14, v1.0, Initial Community Release

## Parameters

### DomainFile

Filename of a simple txt file containing one domain name per row.

### Domain
A single domain name.

### ExportUsersToCsv
   
 Switch to export recipients. The script creates a single file per domain.

## Examples

``` PowerShell
.\Get-RecipientDomainOverview.ps1 -DomainFile .\domains.txt -ExportUsersToCsv
```

Search for recipients that have a proxy address of domains provided in the TXT file domains.txt and export all users to a CSV file

``` PowerShell
.\Get-RecipientDomainOverview.ps1 -Domain varunagroup.de
```

Search for recipients that have a proxy address of varunagroup.de and display the summary only

## Note

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE
RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

## Credits

Written by: Thomas Stensitzki

## Stay connected

- My Blog: [http://justcantgetenough.granikos.eu](http://justcantgetenough.granikos.eu)
- Twitter: [https://twitter.com/stensitzki](https://twitter.com/stensitzki)
- LinkedIn: [http://de.linkedin.com/in/thomasstensitzki](http://de.linkedin.com/in/thomasstensitzki)
- Github: [https://github.com/Apoc70](https://github.com/Apoc70)
- MVP Blog: [https://blogs.msmvps.com/thomastechtalk/](https://blogs.msmvps.com/thomastechtalk/)
- Tech Talk YouTube Channel (DE): [http://techtalk.granikos.eu](http://techtalk.granikos.eu)

For more Office 365, Cloud Security, and Exchange Server stuff checkout services provided by Granikos

- Blog: [http://blog.granikos.eu](http://blog.granikos.eu)
- Website: [https://www.granikos.eu/en/](https://www.granikos.eu/en/)
- Twitter: [https://twitter.com/granikos_de](https://twitter.com/granikos_de)