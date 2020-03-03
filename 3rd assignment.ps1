function Get-Dir_Perm {

<#
.SYNOPSIS

This powershell script enumerate directories inside c:\windows\system32 which are writable by non admin users..

.DESCRIPTION

This powershell script enumerate directories inside c:\windows\system32 which are writable by non admin users..

.PARAMETER Path
Specifies the the Directory path to recursevly enumerate them.


.EXAMPLE

PS C:\> . '.\3rd assignment.ps1'
PS C:\> Get-Dir_Perm

.LINK

https://social.technet.microsoft.com/wiki/contents/articles/31139.powershell-how-to-get-folder-permissions.aspx
https://community.spiceworks.com/topic/1162170-get-folder-permissions-export-to-file-and-sort
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_objects?view=powershell-7
https://serverfault.com/questions/336121/how-to-ignore-an-error-in-powershell-and-let-it-continue


.Note 
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3259



#>

param (
    [Parameter(Mandatory = $false , valuefrompipeline = $false)] $Path
   
   
   
    
    )


#Get-ChildItem .\Windows -Recurse | where-object {($_.PsIsContainer)} | Get-ACL | Format-List
#https://social.technet.microsoft.com/wiki/contents/articles/31139.powershell-how-to-get-folder-permissions.aspx


#https://community.spiceworks.com/topic/1162170-get-folder-permissions-export-to-file-and-sort
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_objects?view=powershell-7

#Get-ChildItem C: | where { $_.PsIsContainer -eq $false } | Format-List

# taken from https://serverfault.com/questions/336121/how-to-ignore-an-error-in-powershell-and-let-it-continue
$ErrorActionPreference = 'SilentlyContinue'

#Listing all dirctory recursevly inside C:\Windows\System32 
$AllFolders = Get-ChildItem -Path C:\Windows\System32 -Recurse -force -ErrorAction SilentlyContinue | Where-Object {$_.PsIsContainer -eq $true}
$Results = @()

#looping through each directory found and check permission of each folder that are not part of "domain admins / Administrator /  "
Foreach ($Folder in $AllFolders) {
    $Acl = Get-Acl -Path $Folder.FullName -ErrorAction SilentlyContinue
    foreach ($Access in $acl.Access) { try {
        if ($Access.IdentityReference -notlike "BUILTIN\Administrators" -and $Access.IdentityReference -notlike "domain\Domain Admins" -and $Access.IdentityReference -notlike "CREATOR OWNER" -and $access.IdentityReference -notlike "NT AUTHORITY\SYSTEM" -and $access.IdentityReference -notlike "NT SERVICE\TrustedInstaller" -and ($Access.FileSystemRights -match "write" -or $Access.FileSystemRights -match "Full" -or $Access.FileSystemRights -match "Modify" ) ) {
            $Properties = [ordered]@{'FolderName'=$Folder.FullName;'AD Group'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
            $Results += New-Object -TypeName PSObject -Property $Properties
        
        }
      } catch {"not able to read permission"}
    }
}

$Results 



}