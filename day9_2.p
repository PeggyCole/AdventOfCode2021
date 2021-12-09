/* Start OE with higher -s */

define temp-table ttDepth no-undo
  field ttRow as integer
  field ttColumn as integer
  field ttDepth as integer
  field ttChecked as logical
  field ttLowPoint as logical initial true
  index PK as primary unique ttRow ttColumn.
  
define temp-table ttBasin no-undo
  field ttSize as integer.
  
define variable viCounter as integer no-undo.
define variable viResult  as integer no-undo initial 1.
    
run readFile.

run findLowPoints.
run findBasins.

for each ttBasin by ttSize desc:
  assign
    viCounter = viCounter + 1
    viResult = viResult * ttBasin.ttSize.
      
  if viCounter = 3 then
    leave.
end.
  
message viResult view-as alert-box info.
  
  /*---------------------------
Information
---------------------------
1235430
---------------------------
OK   
---------------------------
*/

  
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn    as character no-undo.
  define variable viRow     as integer   no-undo.
  define variable viColumn  as integer   no-undo.
  
  input from value("c:\temp\adventofcode\2021\day9_input").
  
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    viRow = viRow + 1.
    do viColumn = 1 to length(vcLIjn):
      create ttDepth.
      assign
        ttDepth.ttRow = viRow
        ttDepth.ttColumn = viColumn
        ttDepth.ttDepth = int(substring(vcLijn, viColumn, 1)).       
    end.
  end.

  input close.
end procedure.


procedure findLowPoints:
  define buffer bttDepth for ttDepth.
  
  for each ttDepth where ttChecked = false by ttDepth.ttRow by ttDepth.ttColumn:
    for each bttDepth 
      where (bttDepth.ttRow = ttDepth.ttRow - 1 and bttDepth.ttColumn = ttDepth.ttColumn)
            or
            (bttDepth.ttRow = ttDepth.ttRow and (bttDepth.ttColumn = ttDepth.ttColumn - 1
                                                 or bttDepth.ttColumn = ttDepth.ttColumn + 1))
            or
            (bttDepth.ttRow = ttDepth.ttRow + 1 and bttDepth.ttColumn = ttDepth.ttColumn):
      if bttDepth.ttDepth <= ttDepth.ttDepth then ttDepth.ttLowPoint = false.      
    end.   
  end.
end procedure.


procedure findBasins:
  define buffer ttDepth for ttDepth.
  
  define variable viSize as integer no-undo.
  
  for each ttDepth where ttDepth.ttLowPoint by ttDepth.ttRow by ttDepth.ttColumn:
    ttDepth.ttChecked = true.
    
    run findNeighbours (input ttDepth.ttRow, input ttDepth.ttColumn, output viSize).
    
    create ttBasin.
    assign
      ttBasin.ttSize = viSize + 1.         
  end.                                     
end procedure.  

procedure findNeighbours:
  define input  parameter  ipiRow    as integer no-undo.
  define input  parameter  ipiColumn as integer no-undo.
  define output parameter  opiSize   as integer no-undo.
  
  define variable viSize as integer no-undo.
  
  define buffer ttDepth for ttDepth.
  
  for each ttDepth 
    where not ttDepth.ttChecked and
         ((ttDepth.ttRow = ipiRow - 1 and ttDepth.ttColumn = ipiColumn)
           or
          (ttDepth.ttRow =ipiRow and (ttDepth.ttColumn = ipiColumn - 1
                                      or ttDepth.ttColumn = ipiColumn + 1))
           or
          (ttDepth.ttRow = ipiRow + 1 and ttDepth.ttColumn = ipiColumn)):
     ttDepth.ttChecked = true.             
     
     if ttDepth.ttDepth <> 9 and ttDepth.ttDepth <> 9 then do:
       opiSize = opiSize + 1.
       
       run findNeighbours (ttDepth.ttRow, ttDepth.ttColumn, output viSize).
       
       opiSize = opiSize + viSize.
       
     end.  
  end.
end procedure.
