

function Get-Auto_Login_Credentilas 
{

<#
.SYNOPSIS
This powershell script check registry looking for passwords stored in windows registry ..

.DESCRIPTION
This powershell script check registry looking for passwords stored in windows registry ..



.EXAMPLE
PS C:\> . .\assignment4.ps1
PS C:\> Get-Auto_Login_Credentila

.LINK
https://www.experts-exchange.com/questions/21011841/Automated-logons.html
https://github.com/HarmJ0y/PowerUp/blob/master/PowerUp.ps1


.Note 
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3259



#>
#https://www.experts-exchange.com/questions/21011841/Automated-logons.html
# copied from https://github.com/HarmJ0y/PowerUp/blob/master/PowerUp.ps1


  [CmdletBinding()] param()

    $AutoAdminLogon = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -ErrorAction SilentlyContinue)

    Write-Verbose "AutoAdminLogon key: $($AutoAdminLogon.AutoAdminLogon)"
    
    #Check if auto login is enabled by checking the value from registry key "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" with the name of "AutoAdminLogon"
    if ($AutoAdminLogon.AutoAdminLogon -ne 0){
        
        #Storing the registry attributes/hives in a variable 
        $DefaultDomainName = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultDomainName -ErrorAction SilentlyContinue).DefaultDomainName
        $DefaultUserName = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -ErrorAction SilentlyContinue).DefaultUserName
        $DefaultPassword = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -ErrorAction SilentlyContinue).DefaultPassword


        #Check if DefaultUserName is True then print the Values of those attributes
        if ($DefaultUserName) {
            $out = New-Object System.Collections.Specialized.OrderedDictionary
            $out.add('DefaultDomainName', $DefaultDomainName)
            $out.add('DefaultUserName', $DefaultUserName)
            $out.add('DefaultPassword', $DefaultPassword )
            $out
        }

        # Here we are checking the altrinative Domain value if the previous is not found, hence this is the behavior of windows when Enabling the AutoLogin Feaute  
        $AltDefaultDomainName = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AltDefaultDomainName -ErrorAction SilentlyContinue).AltDefaultDomainName
        $AltDefaultUserName = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AltDefaultUserName -ErrorAction SilentlyContinue).AltDefaultUserName
        $AltDefaultPassword = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AltDefaultPassword -ErrorAction SilentlyContinue).AltDefaultPassword


         #Check if DefaultUserName is True then print the Values of those attributes
        if ($AltDefaultUserName) {
            $out = New-Object System.Collections.Specialized.OrderedDictionary
            $out.add('AltDefaultDomainName', $AltDefaultDomainName)
            $out.add('AltDefaultUserName', $AltDefaultUserName)
            $out.add('AltDefaultPassword', $AltDefaultPassword )
            $out
        }
    }
        
}   