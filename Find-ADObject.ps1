<#
.Synopsis
   Name: Find-ADObject.ps1
   A PowerShell function to search Active Directory for objects like Printers, Users, Groups and Computers. Supports wildcards as *
.DESCRIPTION
   A function to search Active Directory for objects.
   Category (Users, Computers, Groups and Printers) can be specified, or you can search all categories at the same time.
   It also supports wildcard so you don't have to know more then some of the text you are looking for.
.EXAMPLE
   Find-ADObject -Name *SearchText*
   Find-ADObject -Name *SearchText* -Category Users
   Category can be "Users", "Computers", "Groups" or "Printers"
.NOTES
   Original release Date: 18.06.2020
   Author: Flemming Sørvollen Skaret (https://github.com/flemmingss/)
.LINK
   https://github.com/flemmingss/
#>

function Find-ADObject
{
    Param(
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [Parameter(Mandatory=$false)]
    [ValidateSet("Computers", "Groups", "Printers", "Users")]
    [string]$Category
    )

    $Selected_Category = $Category

    if ($Selected_Category -eq "Computers")
        {
        [string]$Selected_Category = "computer"
        }
    if ($Selected_Category -eq "Groups")
        {
        [string]$Selected_Category = "group"
        }
    if ($Selected_Category -eq "Printers")
        {
        [string]$Selected_Category = "printQueue"
        }
    if ($Selected_Category -eq "Users")
        {
        [string]$Selected_Category = "user"
        }
        
    
    #If category not selected        
    if ($Selected_Category -ne "computer" -and $Selected_Category -ne "group" -and $Selected_Category -ne "printQueue" -and $Selected_Category -ne "user")
        {
        $Selected_Category_Array = @("computer", "group", "printQueue", "user")
        ForEach ($Selected_Category in $Selected_Category_Array)
            {
            $ObjectCategory = "$Selected_Category" #Options: printQueue, user, computer, group
            $strFilter = "(&(objectCategory=$ObjectCategory)(Name=$Name))"
            $objDomain = New-Object System.DirectoryServices.DirectoryEntry
            $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
            $objSearcher.SearchRoot = $objDomain
            $objSearcher.PageSize = 1000
            $objSearcher.Filter = $strFilter
            $objSearcher.SearchScope = "Subtree"
            $colProplist = "name"


            foreach ($i in $colPropList)
                {
                $objSearcher.PropertiesToLoad.Add($i) | Out-Null
                }
                $colResults = $objSearcher.FindAll()
                $outputresults = foreach ($objResult in $colResults)
     		        {
                    $objItem = $objResult.Properties
	    	   		$objItem.name
	    				        }

                

                if ($Selected_Category -eq "computer")
                    {
                    $results_computer = $outputresults
                    }

                if ($Selected_Category -eq "group")
                    {
                    $results_group = $outputresults
                    }

                if ($Selected_Category -eq "printQueue")
                    {
                    $results_printQueue = $outputresults
                    }

                if ($Selected_Category -eq "user")
                    {
                    $results_user = $outputresults
                    }

                }


        if ($results_computer -eq $null)
            {
            Write-Host "No matches in computers" -ForegroundColor Red
            }
        else
            {
            Write-Host "Matches in computers:" -ForegroundColor Green
            $results_computer
            }


        if ($results_group -eq $null)
            {
            Write-Host "No matches in groups" -ForegroundColor Red
            }
        else
            {
            Write-Host "Matches in groups:" -ForegroundColor Green
            $results_group
            }


        if ($results_printQueue -eq $null)
            {
            Write-Host "No matches in printers" -ForegroundColor Red
            }
        else
            {
            Write-Host "Matches in printers:" -ForegroundColor Green
            $results_printQueue
            }


        if ($results_user -eq $null)
            {
            Write-Host "No matches in users" -ForegroundColor Red
            }
        else
            {
            Write-Host "Matches in users:" -ForegroundColor Green
            $results_user
            }

        }

    #if category selected
    else 
        {
        $ObjectCategory = "$Selected_Category" #Options: printQueue, user, computer, group
        $strFilter = "(&(objectCategory=$ObjectCategory)(Name=$Name))"
        $objDomain = New-Object System.DirectoryServices.DirectoryEntry
        $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
        $objSearcher.SearchRoot = $objDomain
        $objSearcher.PageSize = 1000
        $objSearcher.Filter = $strFilter
        $objSearcher.SearchScope = "Subtree"
        $colProplist = "name"

        foreach ($i in $colPropList)
            {
            $objSearcher.PropertiesToLoad.Add($i) | Out-Null
            }
            $colResults = $objSearcher.FindAll()
            $outputresults = foreach ($objResult in $colResults)
     					        {
            $objItem = $objResult.Properties
	    	   		            $objItem.name
	    				        }
        
        if ($outputresults -eq $null)
            {
            Write-Host "No matches in $Category" -ForegroundColor Red
            }
        else
            {
            Write-Host "Matches in $Category :" -ForegroundColor Green
            $outputresults
            }

        }
}

#end of script
