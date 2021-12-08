define variable viTotalCount as integer no-undo.

define temp-table ttPattern no-undo
  field ttNumber as integer 
  field ttSegments as character.  
  
define variable vcLijn    as character no-undo.
define variable viCounter  as integer   no-undo.

input from value("c:\temp\adventofcode\2021\day8_input").

repeat on error undo, leave on endkey undo, leave:
  import unformatted vcLijn.

  run solveLine (trim(entry(1, vcLijn, "|":u)), trim(entry(2, vcLijn, "|":u))).
end.

input close.

message viTotalCount view-as alert-box info.

/*---------------------------
Information (Press HELP to view stack trace)
---------------------------
294
---------------------------
OK   Help   
---------------------------    */

/* --- Functions --- */        
function fSortAlphabetically returns character (input  ipcFrom as character) :    
  define variable vcReturn      as character no-undo.  
  define variable viCounter     as integer   no-undo.
  define variable viCounter2    as integer   no-undo.
  define variable vlPlacefound  as logical   no-undo.
  
  do viCounter = 1 to length(ipcFrom):
    vlPlaceFound = false.    
      
    blockTeller2:  
    do viCounter2 = 1 to length(vcReturn):
      if substring(ipcFrom, viCounter, 1) < substring(vcReturn, viCounter2, 1) then
      do:
        assign
          vlPlaceFound = true
           vcReturn = substring(vcReturn, 1, viCounter2 - 1) + substring(ipcFrom, viCounter, 1) + substring(vcReturn, viCounter2).
        leave blockTeller2.
      end.
    end.
    
    if not vlPlaceFound then 
      vcReturn = vcReturn + substring(ipcFrom, viCounter, 1).  
  end.  
 
 return vcReturn.  
end function.   

/* --- Internal Procedures --- */  
 
procedure solveLine:
  define input parameter ipcSignals    as character no-undo.
  define input parameter ipcFourDigits as character no-undo.

  run fillttPattern (input ipcSignals).
  
  run getNumber (8, 7). // number8 (length: 7): only one with length = 7 
  run getNumber (1, 2). // number1 (length: 2): only one with length = 2
  run getNumber (7, 3). // number7 (length: 3): only one with length = 3
  run getNumber (4, 4). // number4 (length: 4): only one with length = 4
  
  run AddToTotal (ipcFourDigits).   
end procedure.

procedure fillTTPattern:
  define input parameter ipcSignals as character no-undo.
  
  define variable viCounter as integer no-undo.
  
  empty temp-table ttPattern.   
  
  do viCounter = 1 to num-entries(ipcSignals, " "):
    create ttPattern.
    assign
      ttPattern.ttNumber = 99 
      ttPattern.ttSegments = fSortAlphabetically(entry(viCounter, ipcSignals, " ":u)).
  end.
end procedure.

procedure getNumber:  
  define input  parameter ipiNumber  as integer   no-undo.  
  define input  parameter ipiLength  as integer   no-undo.
  
  find first ttPattern where length(ttPattern.ttSegments) = ipiLength and ttPattern.ttNumber = 99 no-error.
  if avail ttPattern then ttPattern.ttNumber = ipiNumber.
      
end procedure. 

procedure AddToTotal:
  define input parameter ipcFourDigits as character no-undo.
  
  define variable vcFourDigits as character no-undo.
  define variable viCounter    as integer   no-undo.
  
  do viCounter = 1 to num-entries(ipcFourDigits, " ":u):
    find first ttPattern no-lock
      where ttPattern.ttSegments = fSortAlphabetically(entry(viCounter, ipcFourDigits, " ":u))
      no-error.
       
   if avail ttPattern then 
     if ttPattern.ttNumber = 1 or ttPattern.ttNumber = 4 or ttPattern.ttNumber = 7 or ttPattern.ttNumber = 8 then
       viTotalCount = viTotalCount + 1.    
  
  end.
end procedure.
