# Part of the below Code's Credite goes to the following URLs
#http://obscuresecurity.blogspot.com/2014/05/dirty-powershell-webserver.html
#https://gist.github.com/19WAS85/5424431
#https://gist.github.com/jakobii/429dcef1bacacfa1da254a5353bbeac7
#https://gist.github.com/theit8514/58a31895ae901206f6957a382f61618b
#https://4sysops.com/archives/building-a-web-server-with-powershell/
#https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/creating-powershell-web-server



function Powershell_WebServer {


<#
.SYNOPSIS
This powershell script is a simple web server in powershell wihch could be used to list,delete,downlaod and upload files over http.

.DESCRIPTION
This powershell script is a simple web server in powershell wihch could be used to list,delete,downlaod and upload files over http.

.EXAMPLE
PS C:\> . '.\7th assignment.ps1'
PS C:\> Powershell_WebServer

.LINK
Part of the below Code's Credite goes to the following URLs
http://obscuresecurity.blogspot.com/2014/05/dirty-powershell-webserver.html
https://gist.github.com/19WAS85/5424431
https://gist.github.com/jakobii/429dcef1bacacfa1da254a5353bbeac7
https://gist.github.com/theit8514/58a31895ae901206f6957a382f61618b
https://4sysops.com/archives/building-a-web-server-with-powershell/
https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/creating-powershell-web-server


.Note 
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3259



#>


 [cmdletBinding()]

    param (
    [Parameter(Mandatory = $True , valuefrompipeline = $True)] $IP,
    [Parameter(Mandatory = $true)] $Port,
    [Parameter(Mandatory = $false)] [String] $WebDir = "."

    
    )

   
   $routes = @{
      
      "/Home" = { return '<html><body><h1>There is no place like home</h1></body></html>' };

       
    
       "/Dir" = { return dir $WebDir }



       "/Stop" = {         '<html><body><h1>Connection Died</h1></body></html>'
                                exit;
        
                        }

      "/download" = { return (Get-Content (Join-Path $WebDir ($Context.Request.QueryString[0])))
                       return "Downloaded" };

      # Deletes the file out of the web root specificed in the query string 
      "/delete" = { (rm (Join-Path $WebDir ($Context.Request.QueryString[0])))
                     return "Succesfully deleted" };

      # Creates a file based on the contents of an uploaded file via a get request (in the future should be based off of POST contents of an actual file upload); Works like /upload?name=lol&value=trololol
      "/upload" = { (Set-Content -Path (Join-Path $WebDir ($Context.Request.QueryString[0])) -Value ($Context.Request.QueryString[1]))
                     return "Succesfully uploaded" };
                     
  
    }
    #Creating listener and adding url prefixes which we will be lisening on 
    $listener = New-Object System.Net.HttpListener
    $URLlistener = "http://" + $IP + ":" + $Port +"/"
    $listener.Prefixes.Add($URLlistener)
    $listener.Start()


   #Creating New-PSDrive to prevent directory listing 
    New-PSDrive -Name MyPowerShellSite -PSProvider FileSystem -Root $PWD.Path
    $psdrive = Get-PSDrive -Name MyPowerShellSite

    #Printing Current Working Directory after creating New-PSDrive
    write-host "========================================================" -ForegroundColor DarkGreen
    write-host "Current Working Directory:$psdrive.Root"  -ForegroundColor DarkGreen
    write-host "========================================================"  -ForegroundColor DarkGreen

    

    

    if ($listener.IsListening) {write-host "Listening on " $listener.Prefixes} 
    else {write-host "Listener is closed"}
       
     
    # While loop will be running if lisener is equal to true other wise it will exit this function
    While ($listener.IsListening) {
      
      try {
        $Context = $listener.GetContext()
        $Response = $Context.Response
        $Request = $Context.Request
        $requestUrl = $Context.Request.Url
      
        
         Write-Host ''
         Write-Host "> $requestUrl"
         $localPath = $requestUrl.LocalPath
         $route = $routes.Get_Item($requestUrl.LocalPath)
         # Check the reponse of the request if it  404 which means not found we will be printing the result 
        if ($route -eq $null) {$Response.StatusCode = 404  
                                write-host $Response.StatusCode}
       
        else {
          $content =  & $route
          $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
          $Context.Response.ContentLength64 = $buffer.Length
          $Context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
        
        
       
        }
        
        $Response.Close()
        $Status = $Response.StatusCode
        #Printing the result 
        Write-Host "< $Status"

         
    } 

    catch {}
    
    

    }








}