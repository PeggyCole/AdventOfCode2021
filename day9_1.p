define temp-table ttDepth no-undo
  field ttRow as integer
  field ttColumn as integer
  field ttDepth as integer
  field ttLowPoint as logical initial true
  index PK as primary unique ttRow ttColumn.
  
define variable viRiskLevel as integer no-undo.  

run readFile.

run findLowPoints (output viRiskLevel).

message viRiskLevel view-as alert-box info.

/*---------------------------
Information
---------------------------
524
---------------------------
OK   
---------------------------   */


  
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
  define output parameter opiRiskLevel as integer no-undo.
  
  define buffer bttDepth for ttDepth.
  
  for each ttDepth by ttDepth.ttRow by ttDepth.ttColumn:
    for each bttDepth 
      where (bttDepth.ttRow = ttDepth.ttRow - 1 and bttDepth.ttColumn = ttDepth.ttColumn)
            or
            (bttDepth.ttRow = ttDepth.ttRow and (bttDepth.ttColumn = ttDepth.ttColumn - 1
                                                 or bttDepth.ttColumn = ttDepth.ttColumn + 1))
            or
            (bttDepth.ttRow = ttDepth.ttRow + 1 and bttDepth.ttColumn = ttDepth.ttColumn)    
      :
      if bttDepth.ttDepth <= ttDepth.ttDepth then ttDepth.ttLowPoint = false.
      
    end.
  end.
  
  for each ttDepth no-lock where ttLowPoint:
    opiRiskLevel = opiRiskLevel + ttDepth.ttDepth + 1.
  end.
end procedure.



