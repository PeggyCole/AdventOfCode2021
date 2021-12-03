using System.*.

define temp-table ttLijn no-undo
  field ttWaarde as character.
 
define variable viOxigen as integer no-undo.
define variable viCO2    as integer no-undo.  

run GetValue (1, "MOST",   output viOxigen).
run GetValue (0, "FEWEST", output viCO2). 

message viOxigen skip viCO2 skip viOxigen * viCO2 view-as alert-box info.




/* ----- internal procedures ----- */
procedure GetValue:
  define input  parameter ipiCheckBit as integer   no-undo.
  define input  parameter ipcCOunt    as character no-undo.
  define output parameter opiValue    as integer   no-undo.  
  
  define variable vcBit     as character no-undo.    
  define variable viLength  as integer   no-undo.
  define variable viTeller  as integer   no-undo.

  run readFile.
  find first ttLijn no-lock no-error.
  viLength = length(ttWaarde).

  do viTeller = 1 to viLength:
    run CheckBits (viTeller, ipiCheckBit, ipcCount, output vcBit).
    find ttLijn no-lock no-error.
    if not avail ttLijn then
      run DeletettLines (viTeller, vcBit).
  end.
  find ttLijn no-lock no-error. 
  opiValue = Convert:ToInt32(ttWaarde, 2).
  
end procedure.  
 
procedure readFile:
  define variable vcLijn as character no-undo.

  empty temp-table ttLijn. 
  input from value("c:\temp\adventofcode\2021\day3_input").

  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
  
    create ttLijn.
    assign
      ttWaarde = vcLijn.
  end.

  input close.

end procedure.
 
procedure CheckBits:   
  define input parameter ipiPosition as integer   no-undo.
  define input parameter ipiWinsAtEQ as integer   no-undo.  
  define input parameter ipcCount    as character no-undo.
  define output parameter opcBit     as character no-undo.
  
  define variable viCount1 as integer no-undo.
  define variable viCount0 as integer no-undo.
   
  for each ttLijn:
     if substring(ttWaarde, ipiPosition, 1) = "0" then
       viCount0 = viCount0 + 1.
  
     if substring(ttWaarde, ipiPosition, 1) = "1" then
       viCount1 = viCount1 + 1.    
  end.
  
  if ipcCount = "MOST" then
  do:       
    if viCount0 > viCount1 then opcBit = "0".
    if viCount0 < viCount1 then opcBit = "1".
    if viCount0 = viCount1 then do:
      if ipiWinsAtEQ = 0 then
        opcBit = "0".
      
      if ipiWinsAtEQ = 1 then
        opcBit = "1".
    end.
  end.
  else do:
    if viCount0 > viCount1 then opcBit = "1".
    if viCount0 < viCount1 then opcBit = "0".
    if viCount0 = viCount1 then do:
      if ipiWinsAtEQ = 0 then
        opcBit = "0".
      
      if ipiWinsAtEQ = 1 then
        opcBit = "1".
    end.      
  end.
end procedure.  

procedure DeletettLines:
  define input parameter ipiPosition        as integer   no-undo.
  define input parameter ipcCharacterToKeep as character no-undo.

  for each ttLijn exclusive-lock where substring(ttWaarde, ipiPosition, 1) <> ipcCharacterToKeep:
    delete ttLijn.
  end.

end procedure.
