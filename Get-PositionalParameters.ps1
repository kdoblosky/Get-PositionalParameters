Function Get-PositionalParameters([string]$CommandName) {
    <#
        .SYNOPSIS
            Displays the positional parameters for each parameter set of the specified command

        .DESCRIPTION
            Displays the positional parameters for each parameter set of the specified command

        .PARAMETER CommandName
            The name of the command to list positional parameters for.

        .EXAMPLE
            $> Get-PositionalParameters Select-String
            
            ParameterSet File: 
            -------------------
            Position 1 - Pattern
            Position 2 - Path

            ParameterSet Object: 
            ---------------------
            Position 1 - Pattern

            ParameterSet LiteralFile: 
            --------------------------
            Position 1 - Pattern

        .EXAMPLE
			$> pos ac
			
            Alias to Add-Content

			ParameterSet Path: 
			------------------
			Position 1 - Path
			Position 2 - Value

			ParameterSet LiteralPath: 
			-------------------------
			Position 2 - Value
			
		.EXAMPLE
			$> Get-PositionalParameters asdf
			
			Invalid Command Name

        .NOTES
            Author: Kevin Doblosky
            Date Created: 2014-03-06
    #>

    # Empty line to make the output more readable
    ""

    # Get the command
    $cmd = Get-Command $CommandName -ErrorAction SilentlyContinue

    # Check if it's an alias - if so, get the aliased command
    if ($cmd -is [System.Management.Automation.AliasInfo]) {
        "Alias to $($cmd.ResolvedCommandName)"
        ""
        $cmd = Get-Command $cmd.ResolvedCommandName
    }


    if ($cmd -eq $null) {
        "Invalid Command Name"
    } else {
        # Loop through all the parameter sets
        $cmd | Select-Object -ExpandProperty ParameterSets | ForEach-Object {

            # Write the header for the parameter set
            $paramSetHeader = "ParameterSet $($_.Name): "
            $paramSetHeader
            "-" * ($paramSetHeader.Length -1)

            # Get the positional parameters, and sort them
            $parameters = $_.Parameters | Select-Object Name, Position | ? { $_.Position -ge 0 } | Sort-Object Position
        
            # Write the parameters in order
            if ( ($parameters | Measure-Object | Select-Object -ExpandProperty Count) -ge 1) {
                $parameters | % { "Position $($_.Position + 1) - $($_.Name)" }
            } else {
                "No positional parameters"
            }

            # Empty line to make the output more readable
            ""
        }
    }
}

Set-Alias -Name pos -Value Get-PositionalParameters