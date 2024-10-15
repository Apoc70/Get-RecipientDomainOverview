# Get-RecipientDomainOverview.ps1

Find Exchange recipient objects for a single or multiple domains.

## Description

This script finds recipient objects for a single domain or a list of domains. An overview containing the number of found recipients is displayed as output.

You can export recipient details as CSV if needed.

Tested with Exchange Server 2016 and Exchange Server 2019.

## Requirements

- Windows Server 2016 or newer
- Utilizes the global function library found here: [https://scripts.granikos.eu](https://scripts.granikos.eu)
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

### Stay connected

- My Blog: [https://blog.granikos.eu](https://blog.granikos.eu)
- Bluesky: [https://bsky.app/profile/stensitzki.bsky.social](https://bsky.app/profile/stensitzki.bsky.social)
- LinkedIn: [https://www.linkedin.com/in/thomasstensitzki](https://www.linkedin.com/in/thomasstensitzki)
- YouTube: [https://www.youtube.com/@ThomasStensitzki](https://www.youtube.com/@ThomasStensitzki)
- LinkTree: [https://linktr.ee/stensitzki](https://linktr.ee/stensitzki)

For more Office 365, Cloud Security, and Exchange Server stuff checkout services provided by Granikos

- Website: [https://www.granikos.eu/en/](https://www.granikos.eu/en/)
- Bluesky: [https://bsky.app/profile/granikos.bsky.social](https://bsky.app/profile/granikos.bsky.social)