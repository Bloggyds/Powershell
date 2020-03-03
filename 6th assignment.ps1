#https://blog.ipswitch.com/use-powershell-copy-item-cmdlet-transfer-files-winrm
#https://stackoverflow.com/questions/10741609/copy-file-remotely-with-powershell

function Transfer_file_PSRemoting


<#
.SYNOPSIS
This powershell script enable you to transfer files over posershell remoting.

.DESCRIPTION
This powershell script enable you to transfer files over posershell remoting.

.EXAMPLE
PS C:\> . '.\6th assignment.ps1'
PS C:\>  Transfer_file_PSRemoting -ComputerName Workstation1 -DomainUser company\administrator -Password User12345 -LocalFile .\sometxt.txt -Destination  C:/Users/sometxt.txt

.LINK
https://blog.ipswitch.com/use-powershell-copy-item-cmdlet-transfer-files-winrm
https://stackoverflow.com/questions/10741609/copy-file-remotely-with-powershell
https://stackoverflow.com/questions/10011794/hardcode-password-into-powershells-new-pssession


.Note 
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3259



#>

{
    [cmdletBinding()]

    param (
    [Parameter(Mandatory = $True , valuefrompipeline = $True)] $ComputerName,
    [Parameter(Mandatory = $true)] $DomainUser,
    [Parameter(Mandatory = $true)] $Password,
    [Parameter(Mandatory = $True)] $LocalFile,
    [Parameter(Mandatory = $True)] $Destination

        
    
    )

 $pw = convertto-securestring -AsPlainText -Force -String $Password
 $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "$DomainUser",$pw


    #Creating new PSSession using domain credentials 
    $Session = New-PSSession -ComputerName $ComputerName -Credential $cred
    #using Copy-Item prviding it with local file path and destination file path 
    Copy-Item -Path $LocalFile $Destination  -ToSession $Session


}