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
  
  run getNumber8. 
  run getNumber1. 
  run getNumber7. 
  run getNumber4.
  
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

procedure getNumber1:  
  find first ttPattern where length(ttPattern.ttSegments) = 2 and ttPattern.ttNumber = 99 no-error.
  if avail ttPattern then ttPattern.ttNumber = 1.
end procedure.  

procedure getNumber4:  
  find first ttPattern where length(ttPattern.ttSegments) = 4 and ttPattern.ttNumber = 99 no-error.
  if avail ttPattern then ttPattern.ttNumber = 4.
end procedure.

procedure getNumber7:  
  find first ttPattern where length(ttPattern.ttSegments) = 3 and ttPattern.ttNumber = 99 no-error.
  if avail ttPattern then ttPattern.ttNumber = 7.
end procedure.
 
procedure getNumber8:
  find first ttPattern where length(ttPattern.ttSegments) = 7 and ttPattern.ttNumber = 99 no-error.
  if avail ttPattern then ttPattern.ttNumber = 8.       
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
