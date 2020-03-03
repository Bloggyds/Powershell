

function Enumerate_All_Shares {

 <#
.SYNOPSIS

This powershell script Enumerate all shares.

.DESCRIPTION

This powershell script Enumerate all shares and marks the open share seperatley.

.PARAMETER Target
Specifies the the Target ComputerName or IP.


.EXAMPLE

PS C:\> . '.\2nd Assignment.ps1'
PS C:\> Enumerate_All_Shares -Target 10.10.10.10

.LINK

 https://docs.microsoft.com/en-us/previous-versions/windows/desktop/secrcw32prov/win32-logicalsharesecuritysetting#properties
 https://social.technet.microsoft.com/Forums/en-US/a67e3ffd-5e41-4e2f-b1b9-c7c2f29a3a12/adding-permissions-to-an-existing-share?forum=winserverpowershell

.Note 
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3259



#>  

    param (
    [Parameter(Mandatory = $True , valuefrompipeline = $True)] $Target
   
   
 
   
    
    )


    $Shares = gwmi -Class win32_share -ComputerName $Target | select -ExpandProperty Name  
    $global:Open_Share = ""
    
    #1st for loop hte at will list all share found
    foreach ($share in $Shares) { 			$objShareSec = Get-WMIObject -Class Win32_LogicalShareSecuritySetting -Filter "name='$share'"  -ComputerName $Target
                                    $ACL = $null  

    Write-host "Share $share found "
     

   try {
    Write-host " Checking Share $share Permissions"
    # the following code Foreach loop and printing of $ACL is taken from Microsoft 
    #https://docs.microsoft.com/en-us/previous-versions/windows/desktop/secrcw32prov/win32-logicalsharesecuritysetting#properties
    #https://social.technet.microsoft.com/Forums/en-US/a67e3ffd-5e41-4e2f-b1b9-c7c2f29a3a12/adding-permissions-to-an-existing-share?forum=winserverpowershell
    $SD = $objShareSec.GetSecurityDescriptor().Descriptor
  
  #Second for loop will check permission of security descriptor of each share and map that has full control 
  foreach ($ace in $SD.DACL) {     $UserName = $ace.Trustee.Name  
      If ($ace.Trustee.Domain -ne $Null) {$UserName = "$($ace.Trustee.Domain)\$UserName"}
      If ($ace.Trustee.Name -eq $Null) {$UserName = $ace.Trustee.SIDString }
<# Access mask values
# fullcontrol = 2032127
# change = 1245631
  read = 1179817 #>

  #Check if this share is open

  
      if ($ace.Trustee.Name -eq "EveryOne" -and $ace.AccessMask -eq "2032127" -and $ace.AceType -eq 0) {write-host "  ===================================================
        Share $share is wide open to everybody
        ===================================================" -ForegroundColor DarkGreen 
        $global:Open_Share += "$share"
  }
    [Array]$ACL += New-Object Security.AccessControl.FileSystemAccessRule($UserName, $ace.AccessMask, $ace.AceType)
    }
    
    

   
    } 
    catch {}
    $ACL   
     
    }





    Write-host " Open Shares found on IP:   " -ForegroundColor white -NoNewline
    ;   Write-host "\\$Target" -ForegroundColor Green -NoNewline;     Write-host "\$global:Open_Share" -ForegroundColor Green -NoNewline





}