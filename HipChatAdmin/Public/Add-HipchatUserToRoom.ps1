#requires -version 5

<#
.SYNOPSIS
	Adds a HipChat user to a HipChat room.
.DESCRIPTION
	Adds an existing HipChat user to an existing HipChat room.
.PARAMETER MentionName
	Required: The user's mention name (@name).
.PARAMETER RoomName
	Required: The name of the room.
.PARAMETER ApiToken
	Required: Your HipChat API Token. You can obtain an API Token from the
	HipChat website by navigating to Account Settings > API Access.
.NOTES
	Version:        1.0
	Author:         Corey Fonseca
	Creation Date:  3/19/17
	Purpose/Change: Full Functionality
.EXAMPLE
	Add-HipchatUserToRoom -MentionName 'JohnSmith' -RoomName 'Development' -ApiToken 'REXsCauSe553gsoIJg1Gj4zwNsSAwS'
	Adds @JohnSmith to the Development room.

#>
function Add-HipchatUserToRoom{

    [CmdletBinding()]
	Param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Enter the users mention name (@name)")][Alias('UserName')][string[]]$MentionName,
    	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Enter the room name")][string]$RoomName,
		[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Enter your API Token")][Alias('ApiKey')][string]$ApiToken
    )

    BEGIN {}

    PROCESS {

		Foreach ($Name in $MentionName) {
			$Uri = "https://api.hipchat.com/v2/room/"+$RoomName+"/member/@"+$Name+"?auth_token="+$ApiToken
			# Send API Request #
			$Call = (
				Invoke-WebRequest `
					-Uri $Uri `
					-Method PUT `
					-ContentType "application/json"
			)
			
			# Check response status code #
			if ($Call.StatusCode -eq '204') {
				Write-Verbose "User $Name Added Successfully!"
				$OutputObject = New-Object -TypeName PSObject
				$OutputObject | Add-Member -MemberType 'NoteProperty' -Name 'Name' -Value $name
				$OutputObject | Add-Member -MemberType 'NoteProperty' -Name 'StatusCode' -Value $Call.StatusCode
				Write-Output $OutputObject
			} else {
				Write-Error "Failed to add user $Name!"
			}
		}

	}

	END {}
    
}
