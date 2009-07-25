(*
 *
 *		AppleScript which handles input and opens Terminal
 *
 *		Based on modified version by JiHO:
 *			http://maururu.net/2007/enhanced-open-terminal-here-for-leopard/
 *
 *		Modified from Marc Liyanage
 *			http://www.entropy.ch/software/applescript/
 *		and Jonathan Austin
 *			http://forums.macosxhints.com/showthread.php?p=426240#post426240 
 *		
 *)


-- =================
-- = Event Handlers =
-- =================

on open untitled theObject
	-- This is triggered when the application icon is clicked
	
	-- Get the path of the frontmost Finder window
	tell application "Finder"
		try
			set thisFolder to (the target of the front window) as alias
		on error
			set thisFolder to startup disk
		end try
	end tell
	
	my openTerm(thisFolder)	
	
	quit
	
end open untitled


on open theObject
	-- This is triggered when some documents/folders are dropped on the icon

	repeat with thisItem in theObject
		my openTerm(thisItem)
	end repeat

	quit
end open


-- =================
-- = Open Terminal =
-- =================
on openTerm(theItem)
	
	-- Get the POSIX path of the item (dropped or Finder selection)
	set thePath to POSIX path of theItem
	-- display dialog thePath
	
	-- Strip out file name to keep just directory (`dirname` like in Applescript)
	repeat until thePath ends with "/"
		set thePath to text 1 thru -2 of thePath
	end repeat
	-- display dialog thePath
	
	-- Set the command line to run
	set cdCommand to "cd " & quoted form of thePath & "; clear"
	
	-- `cd` to there in Terminal
	tell application "Terminal"
		activate
				-- Make a new tab
				tell application "System Events" to tell process "Terminal" to ¬
					keystroke "t" using command down
					-- NB: There _must_ be a better way to open a new tab
				do script cdCommand  in window 1
	end tell
end openTerm
