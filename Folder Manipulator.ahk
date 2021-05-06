;---------------------------------------------------------------------------------------------------------------------------------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; if already running, re-run
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;---------------------------------------------------------------------------------------------------------------------------------------------
; Select file, mass replace of words or characters
;https://www.reddit.com/r/AutoHotkey/comments/de2aaf/trying_to_read_a_file_and_send_the_contents_not/
;---------------------------------------------------------------------------------------------------------------------------------------------

Gui, Show, W750 H200, Folder Manipulator

Gui, Font, norm s14,		
Gui, Add, Button, x5 y5 w740 gLoadFolder, Load Folder
Gui, Add, Edit, X5 Y50 w740 -Wrap ReadOnly vEdit0Var,								;Creates Edit Box 1 with force uppercase, negates text wrapping

Gui, Add, Text, -Border BackgroundTrans X5 Y85 vTextInit1, File Name Variables:		;Create text "Instruction" at X:10, Y:10
Gui, Font, norm s14,														;Reset text to normal
Gui, Add, Edit, X5 Y109 w740 -Wrap vEdit1Var,								;Creates Edit Box 1 with force uppercase, negates text wrapping
;600 wide; 4 buttons; G|B||B||B||B|G; 600 - 2(5) = 590 - 3(10) = 560 / 4 = w140
Gui, Add, Button, x5 Y145 w178 h50 gBulk_File_Renamer, Bulk Rename Files
Gui, Add, Button, x+10 Y145 w178 h50 gFile_Renamer, Rename Files
Gui, Add, Button, x+10 Y145 w178 h50 gfolderCreate, Create Folders
Gui, Add, Button, x+10 Y145 w178 h50 gfolderRename, Rename Folders

;Default Edit box to directoy of script
Edit0Var = %A_WorkingDir%
GuiControl,, Edit0Var, %Edit0Var%

return

;----------------------------------------------------------------------Load Folder---------------------------------------------------------------
LoadFolder:
{
	Gui, Submit, NoHide
	Gui, +OwnDialogs
	FileSelectFolder, TreeRoot, *%A_WorkingDir%
	if !TreeRoot
		return
	SetWorkingDir, %TreeRoot%
	;Msgbox, Working directory is %A_WorkingDir%
	Edit0Var = %A_WorkingDir%
	GuiControl,, Edit0Var, %Edit0Var%
	return
}

;---------------------------------------------------------------Create Chapter.txt-------------------------------------------------------------------

txtCreate:
{
	Gui, Submit, NoHide							;Submits all data from Edit Box 1 after each change
	string1 =
	stringArray1 := StrSplit(Edit1Var , ",")
	
	for index, element0 in stringArray1
	{	
		if(InStr(element0, "-") != 0)
		{
			stringArray2 := StrSplit(element0 , "-")
			element1 := stringArray2[1]
			element2 := stringArray2[2] + 1
			countLength2 := strlen(element2)
			while (element1 < element2)
			{	
				countLength1 := strlen(element1)
				if(countLength1 <= countLength2)
				{
					;Msgbox, counter is %counter%`n length of counter is %countLength%`n Number of columns is %nCol%
					loopnum := (countLength2 - countLength1)
					countExt = %element1%
					Loop, %loopnum%
					{
						countExt = 0%countExt%
					}
				}
				string1 = %string1%%countExt% - `n
				element1 := element1 + 1
			}
		}
		else
			string1 = %string1%%element0% - `n
	}
	FileAppend, %string1%, %A_WorkingDir%\Chapter List.txt
	;Exitapp
	return
}

;---------------------------------------------------------------Create Folders-------------------------------------------------------------------

folderCreate:
{
	Gui, Submit, NoHide							;Submits all data from Edit Box 1 after each change

	stringArray1 := StrSplit(Edit1Var , ",")
	
	for index, element0 in stringArray1
	{	
		if(InStr(element0, "-") != 0)					; if element has a dash
		{
			stringArray2 := StrSplit(element0 , "-")	; string split dashed element into first and last number
			element1 := stringArray2[1]					
			element2 := stringArray2[2] + 1
			countLength2 := strlen(stringArray2[2])	; length of 2nd element
			while (element1 < element2)				; while first element number < last element number
			{	
				countLength1 := strlen(element1)	; get length of current number
				; if length not equal, add zeros for padding
				if(countLength1 <= countLength2)	
				{
					;Msgbox, counter is %counter%`n length of counter is %countLength%`n Number of columns is %nCol%
					loopnum := (countLength2 - countLength1)
					countExt = %element1%
					Loop, %loopnum%
					{
						countExt = 0%countExt%
					}
				}
				FileCreateDir, %A_WorkingDir%\%countExt%
				element1 := element1 + 1
			}
		}
		else
			FileCreateDir, %A_WorkingDir%\%element0%
	}
	;Exitapp
	return
}

;---------------------------------------------------------------Rename Folders-------------------------------------------------------------------

folderRename:
{
	Gui, Submit, NoHide							;Submits all data from Edit Box 1 after each change

	stringArray1 := StrSplit(Edit1Var , ",")
	
	FileList := ""
	arrayCount := 0
	Loop, Files, %A_WorkingDir%\*.*, D
	{
		FileList .= A_LoopFileName "`n"
		arrayCount := arrayCount + 1
	}
	;Msgbox, %FileList%
	FolderListArray := StrSplit(FileList , "`n")
	folderCounter = 0
	
	for index, element0 in stringArray1
	{	
		if(InStr(element0, "-") != 0)					; if element has a dash
		{
			stringArray2 := StrSplit(element0 , "-")	; string split dashed element into first and last number
			element1 := stringArray2[1]					
			element2 := stringArray2[2] + 1
			countLength2 := strlen(stringArray2[2])	; length of 2nd element
			while (element1 < element2)				; while first element number < last element number
			{	
				folderCounter += 1
				folderElement := FolderListArray[folderCounter]
				;Msgbox, %folderElement%
				countLength1 := strlen(element1)	; get length of current number
				; if length not equal, add zeros for padding
				if(countLength1 <= countLength2)	
				{
					;Msgbox, counter is %counter%`n length of counter is %countLength%`n Number of columns is %nCol%
					loopnum := (countLength2 - countLength1)
					countExt = %element1%
					Loop, %loopnum%
					{
						countExt = 0%countExt%
					}
				}
				FileMoveDir, %A_WorkingDir%\%folderElement%\, %A_WorkingDir%\%countExt%
				element1 := element1 + 1
			}
		}
		else
		{
			folderCounter += 1
			folderElement := FolderListArray[folderCounter]
			FileMoveDir, %A_WorkingDir%\%folderElement%\, %A_WorkingDir%\%element0%\
		}
	}
	;Exitapp
	return
}

;---------------------------------------------------------------Rename Files-------------------------------------------------------------------

File_Renamer:
{
	Gui, Submit, NoHide							;Submits all data from Edit Box 1 after each change
	counter := 0
	nOF := 0	;Number of files
	nCol := 	; Number of tens of files, 1, 10, 100, 1000, etc
	FileList := ""
	FileExtList := []
	Loop, Files, *.*
	{
		if A_LoopFileAttrib contains H,R,S  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
		continue  ; Skip this file and move on to the next one.
		
		FileList .= A_LoopFileName "`n"
		FileExtList.Push(A_LoopFileExt)
		nOF++
	}
	nCol := strlen(nOF)
	;Msgbox, Max count is %nOF%`n number of columns is %nCol%
	
	Loop, Parse, FileList, `n
	{	
		if A_LoopFileAttrib contains H,R,S  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
		continue  ; Skip this file and move on to the next one.
		
		ele_path := FileExtList[A_Index]			;ele_path = next word array element
		;Msgbox, A_Index = %A_Index%`n A_LoopFileExt = %A_LoopFileExt%`n %ele_path%
		countLength := strlen(counter)
		countExt = %counter%
		if(countLength < nCol)
		{
			;Msgbox, counter is %counter%`n length of counter is %countLength%`n Number of columns is %nCol%
			loopnum := (nCol - countLength)
			Loop, %loopnum%
			{
				countExt = 0%countExt%
			}
		}
		FileMove, %A_LoopField%, %A_WorkingDir%\%Edit1Var%%countExt%.%ele_path%
		counter++
	}
	SplashTextOn, 300, 30, Files at %Edit0Var% have been renamed.
    Sleep, 1000 ; wait 1 seconds
    SplashTextOff ; remove the text
	return
}

;---------------------------------------------------------------Bulk Rename Files-------------------------------------------------------------------

Bulk_File_Renamer:
{
	Gui, Submit, NoHide							;Submits all data from Edit Box 1 after each change
	
	FileList := ""
	arrayCount := 0
	Loop, Files, %A_WorkingDir%\*.*, D
	{
		FileList .= A_LoopFileName "`n"
		arrayCount := arrayCount + 1
	}
	;Msgbox, %FileList%
	FolderListArray := StrSplit(FileList , "`n")
	Loop, %arrayCount%
	{
		element := FolderListArray[A_Index]
		;Msgbox, %element%
	
		counter := 0
		nOF := 0	;Number of files
		nCol := 	; Number of tens of files, 1, 10, 100, 1000, etc
		FileList := ""
		FileExtList := []
		Loop, Files, %A_WorkingDir%\%element%\*.*
		{
			if A_LoopFileAttrib contains H,R,S  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
			continue  ; Skip this file and move on to the next one.
			
			FileList .= A_LoopFileName "`n"
			FileExtList.Push(A_LoopFileExt)
			nOF++
		}
		nCol := strlen(nOF)
		;Msgbox, Max count is %nOF%`n number of columns is %nCol%
		
		Loop, Parse, FileList, `n
		{	
			if A_LoopFileAttrib contains H,R,S  ; Skip any file that is either H (Hidden), R (Read-only), or S (System). Note: No spaces in "H,R,S".
			continue  ; Skip this file and move on to the next one.
			
			ele_path := FileExtList[A_Index]			;ele_path = next word array element
			;Msgbox, A_Index = %A_Index%`n A_LoopFileExt = %A_LoopFileExt%`n %ele_path%
			countLength := strlen(counter)
			countExt = %counter%
			if(countLength < nCol)
			{
				;Msgbox, counter is %counter%`n length of counter is %countLength%`n Number of columns is %nCol%
				loopnum := (nCol - countLength)
				Loop, %loopnum%
				{
					countExt = 0%countExt%
				}
			}
			if(ele_path != "")
			{
				;Msgbox, %A_WorkingDir%\%element%\%A_LoopField%`nRenamed to: %A_WorkingDir%\%element%\%Edit1Var%-%element%-%countExt%.%ele_path%
				FileMove, %A_WorkingDir%\%element%\%A_LoopField%, %A_WorkingDir%\%element%\%Edit1Var%-%element%-%countExt%.%ele_path%
			}
			counter++
		}
		SplashTextOn, 500, 30, Files at %Edit0Var%\%element%\ have been renamed.
		Sleep, 500 ; wait 1 seconds
		SplashTextOff ; remove the text
	}
	return
}

;----------------------------------------------------------------------------------------------------------------------------------------------

GuiClose:
close:
GuiEscape:
Exitapp