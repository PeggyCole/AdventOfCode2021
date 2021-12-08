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
973292
---------------------------
OK   Help   
---------------------------    */


/* --- Functions --- */        
function fSortAlphabetically returns character (input  ipcFrom as character) :    
  define variable vcReturn     as character no-undo.  
  define variable viCounter     as integer   no-undo.
  define variable viCounter2    as integer   no-undo.
  define variable vlPlacefound as logical   no-undo.
  
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

  define variable vcArrayNumber as character no-undo extent 10.
  define variable Avoid0        as integer   no-undo initial 1.  /* zero-based array not available in OE so adding Avoid0 makes it more readable */
  
  define variable vcSegmentA as character no-undo.
  define variable vcSegmentB as character no-undo.
  define variable vcSegmentC as character no-undo.
  define variable vcSegmentE as character no-undo.
  define variable vcSegmentF as character no-undo.
  define variable vcSegmentG as character no-undo.
  
  run fillttPattern (input ipcSignals).
  
  /*  
      0:      1:      2:      3:      4:
   aaaa    ....    aaaa    aaaa    ....
  b    c  .    c  .    c  .    c  b    c
  b    c  .    c  .    c  .    c  b    c
   ....    ....    dddd    dddd    dddd
  e    f  .    f  e    .  .    f  .    f
  e    f  .    f  e    .  .    f  .    f
   gggg    ....    gggg    gggg    ....

      5:      6:      7:      8:      9:
   aaaa    aaaa    aaaa    aaaa    aaaa
  b    .  b    .  .    c  b    c  b    c
  b    .  b    .  .    c  b    c  b    c
   dddd    dddd    ....    dddd    dddd
  .    f  e    f  .    f  e    f  .    f
  .    f  e    f  .    f  e    f  .    f
   gggg    gggg    ....    gggg    gggg
 */
 
 
 /*fdaebc egc gc bgefc ecbagd becfa fagc afgbec gdcbfae bgdef | cgfa gcebad ebcadfg cefgbad*/
 
 
  run getNumber (8, 7, output vcArrayNumber[8 + Avoid0]). // number8 (length: 7): only one with length = 7 
  run getNumber (1, 2, output vcArrayNumber[1 + Avoid0]). // number1 (length: 2): only one with length = 2
  run getNumber (7, 3, output vcArrayNumber[7 + Avoid0]). // number7 (length: 3): only one with length = 3
  run getNumber (4, 4, output vcArrayNumber[4 + Avoid0]). // number4 (length: 4): only one with length = 4
  
  run getNumber3 (vcArrayNumber[1 + Avoid0], output vcArrayNumber[3 + Avoid0]).     // number3 (length: 5) = is the only one with length = 5 that contains all letters of number1 
  run getNumber9 (vcArrayNumber[3 + Avoid0], vcArrayNumber[4 + Avoid0], output vcArrayNumber[9 + Avoid0]).  // number9 (length: 6) = same letters as in (number3 + number4)
    
  run getSegmentByDifference (vcArrayNumber[7 + Avoid0], vcArrayNumber[1 + Avoid0], output vcSegmentA). // difference between number1 and number7 is 1 segment --> segment A 
  run getSegmentG (vcArrayNumber[3 + Avoid0], vcArrayNumber[1 + Avoid0], vcArrayNumber[4 + Avoid0], vcArrayNumber[7 + Avoid0], output vcSegmentG).  // difference between 3 and (1 + 4 + 7) is 1 segment --> segment G 
  run getSegmentByDifference (vcArrayNumber[9 + Avoid0], vcArrayNumber[3 + Avoid0], output vcSegmentB). // difference between number9 and number3 is 1 segment --> segment B  
  run getSegmentByDifference (vcArrayNumber[8 + Avoid0], vcArrayNumber[9 + Avoid0], output vcSegmentE). // difference between number8 and number9 is 1 segment --> segment E  
  
  run getNumber2 (vcSegmentE, output vcArrayNumber[2 + Avoid0]). // number2 (length:5): contains segment E 
  run getNumber (5, 5, output vcArrayNumber[5 + Avoid0]) . // number5 (length:5): only one left with length = 5
  
  run getSegmentByDifference (replace(vcArrayNumber[8 + Avoid0], vcSegmentB, ""), vcArrayNumber[2 + Avoid0], output vcSegmentF). // difference between (number8 - segmentB) and number2 is 1 segment --> segment F     
  run getSegmentByDifference (vcArrayNumber[9 + Avoid0], vcArrayNumber[5 + Avoid0], output vcSegmentC). // difference between number9 and number5 is 1 segment --> segment C  
   
  run getNumber0 (vcSegmentA, vcSegmentB, vcSegmentC, vcSegmentE, vcSegmentF, vcSegmentG, output vcArrayNumber[0 + Avoid0]). // number0 (length: 6): contains segments A, B, C, E, F, G
  run getNumber (6, 6, output vcArrayNumber[6 + Avoid0]). // number6: only one left    
   
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
  define output parameter opcSegment as character no-undo.
  
  find first ttPattern where length(ttPattern.ttSegments) = ipiLength and ttPattern.ttNumber = 99 no-error.
  if avail ttPattern then 
     assign 
       ttPattern.ttNumber = ipiNumber
       opcSegment = ttPattern.ttSegments.
end procedure. 

procedure getNumber0:
  define input  parameter ipcSegmentA as character no-undo.
  define input  parameter ipcSegmentB as character no-undo.
  define input  parameter ipcSegmentC as character no-undo.
  define input  parameter ipcSegmentE as character no-undo.
  define input  parameter ipcSegmentF as character no-undo.
  define input  parameter ipcSegmentG as character no-undo.
  define output parameter opcSegment  as character no-undo.

  /* Zoek de 0 */
   find first ttPattern 
     where length(ttPattern.ttSegments) = 6
     and ttPattern.ttNumber = 99
     and ttPattern.ttSegments matches "*" + ipcSegmentA + "*":u
     and ttPattern.ttSegments matches "*" + ipcSegmentB + "*":u
     and ttPattern.ttSegments matches "*" + ipcSegmentC + "*":u
     and ttPattern.ttSegments matches "*" + ipcSegmentE + "*":u
     and ttPattern.ttSegments matches "*" + ipcSegmentF + "*":u
     and ttPattern.ttSegments matches "*" + ipcSegmentG + "*":u
     no-error.
     
   if avail ttPattern then
   do:
     ttPattern.ttNumber = 0.
     opcSegment = ttPattern.ttSegments.  
   end.
end procedure.

procedure getNumber2:
  define input parameter ipcSegementE as character no-undo.
  define output parameter opcSegment  as character no-undo.

  /* Zoek de 2 */
   find first ttPattern 
     where length(ttPattern.ttSegments) = 5 
     and ttPattern.ttNumber = 99
     and ttPattern.ttSegments matches "*" + ipcSegementE + "*":u
     no-error.
   if avail ttPattern then
     assign
       ttPattern.ttNumber = 2.
       opcSegment = ttPattern.ttSegments.  
   
end procedure.

procedure getNumber3:
  define input  parameter ipcNumber1 as character no-undo.
  define output parameter opcSegment as character no-undo.

  for each ttPattern where length(ttPattern.ttSegments) = 5 and ttPattern.ttNumber = 99: 
    if ttPattern.ttSegments matches "*":u + substring(ipcNumber1, 1 , 1)  + "*":u
      and ttPattern.ttSegments matches "*":u + substring(ipcNumber1, 2, 1)  + "*":u then
      assign
        ttPattern.ttNumber = 3
        opcSegment = ttPattern.ttSegments.      
 end.
 
end procedure. 

procedure getNumber9:
  define input  parameter ipcNumber3 as character no-undo.
  define input  parameter ipcNumber4 as character no-undo.
  define output parameter opcSegment as character no-undo.
  
  define variable vcDummy    as character no-undo.
  define variable viCounter  as integer   no-undo.
  define variable viCounter2 as integer   no-undo.

  block9:
  for each ttPattern where length(ttPattern.ttSegments) = 6 and ttPattern.ttNumber = 99: 
     vcDummy = ttPattern.ttSegments.
     
     do viCounter2 = 1 to length(ipcNumber3):
       if vcDummy matches "*" +  substring(ipcNumber3, viCounter2, 1) + "*" then
         vcDummy = replace(vcDummy, substring(ipcNumber3, viCounter2, 1), "").      
     end.
     do viCounter2 = 1 to length(ipcNumber4):
       if vcDummy matches "*" +  substring(ipcNumber4, viCounter2, 1) + "*" then
         vcDummy = replace(vcDummy, substring(ipcNumber4, viCounter2, 1), "").      
     end.
     
     if vcDummy = "" then do:
       assign
         ttPattern.ttNumber = 9
         opcSegment = ttPattern.ttSegments.
       
       leave block9.
     end.
  end.                      
end procedure.     

procedure getSegmentByDifference:
  define input parameter  ipcNumberFull       as character no-undo.
  define input parameter  ipcNumberDistract   as character no-undo.
  define output parameter opcSegment          as character no-undo.
  
  define variable viCounter     as integer   no-undo.
  define variable viCounter2    as integer   no-undo.
  
   do viCounter = 1 to length(ipcNumberFull):  
     do viCounter2 = 1 to length(ipcNumberDistract):
       if substring(ipcNumberFull, viCounter, 1) <> substring(ipcNumberDistract, viCounter2, 1) then
         ipcNumberFull = replace(ipcNumberFull, substring(ipcNumberDistract, viCounter2, 1), "").      
     end.
   end. 
   if length(ipcNumberFull) = 1 then opcSegment = ipcNumberFull.  
end procedure.

procedure getSegmentG:
  define input  parameter  ipcNumber3 as character no-undo.
  define input  parameter  ipcNumber1 as character no-undo.
  define input  parameter  ipcNumber4 as character no-undo.
  define input  parameter  ipcNumber7 as character no-undo.  
  define output parameter  opcSegment as character no-undo.

  define variable viCounter     as integer   no-undo.
  define variable viCounter2    as integer   no-undo.
  
  do viCounter = 1 to length(ipcNumber3):  
    do viCounter2 = 1 to length(ipcNumber1):
      if substring(ipcNumber3, viCounter, 1) <> substring(ipcNumber1, viCounter2, 1) then
        ipcNumber3 = replace(ipcNumber3, substring(ipcNumber1, viCounter2, 1), "").      
    end.
    do viCounter2 = 1 to length(ipcNumber4):
      if substring(ipcNumber3, viCounter, 1) <> substring(ipcNumber4, viCounter2, 1) then
        ipcNumber3 = replace(ipcNumber3, substring(ipcNumber4, viCounter2, 1), "").      
    end.
    do viCounter2 = 1 to length(ipcNumber7):
      if substring(ipcNumber3, viCounter, 1) <> substring(ipcNumber7, viCounter2, 1) then
        ipcNumber3 = replace(ipcNumber3, substring(ipcNumber7, viCounter2, 1), "").      
    end.
  end. 
  if length(ipcNumber3) = 1 then opcSegment = ipcNumber3.   
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
     vcFourDigits = vcFourDigits + string(ttPattern.ttNumber). 
  end.
   
  viTotalCount = viTotalCount + int(vcFourDigits).

end procedure.
