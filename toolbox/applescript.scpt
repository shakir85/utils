tell application "iTerm"
	activate
	
	if (count of windows) = 0 then
		-- Case 1: iTerm2 was closed, open a new window
		set newWindow to (create window with default profile)
		set targetSession to current session of newWindow
	else
		-- Case 2: iTerm2 is open, create a new tab in the current window
		tell current window
			create tab with default profile
			set targetSession to current session
		end tell
	end if
	
	-- Case 3: In all cases, source zsh profile then run the command
	tell targetSession
		write text "echo hi"
	end tell
end tell
