define temp-table tntOctopus no-undo
  field ttRow as integer
  field ttColumn as integer
  field ttEnergyLevel as integer
  field ttFlashedThisStep as logical  
  index PK as primary unique ttRow ttColumn.

define variable viStep as integer no-undo.
define variable viFlashes as integer no-undo.

run readFile.

do viStep = 1 to 100:
  run doStep.
end.

message viFlashes view-as alert-box info.

/*---------------------------
Information
---------------------------
1599
---------------------------
OK   
---------------------------    */


  
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn    as character no-undo.
  define variable viRow     as integer   no-undo.
  define variable viColumn  as integer   no-undo.
  
  input from value("c:\temp\adventofcode\2021\day11_input").        
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    viRow = viRow + 1.
    do viColumn = 1 to length(vcLIjn):
      create tntOctopus.
      assign
        tntOctopus.ttRow = viRow
        tntOctopus.ttColumn = viColumn
        tntOctopus.ttEnergyLevel = int(substring(vcLijn, viColumn, 1)).
      
    end.
  end.

  input close.
  
end procedure.


procedure doStep:

  define buffer tntOctopus for tntOctopus.
  define buffer btntOctopus for tntOctopus.

  for each tntOctopus :
    assign
      ttFlashedThisStep = no  
      tntOctopus.ttEnergyLevel = ttEnergyLevel + 1.     
  end.
  
  
  blockrepeat:
  repeat:
    find first tntOctopus no-lock
      where tntOctopus.ttEnergyLevel > 9
      and tntOctopus.ttFlashedThisStep = no
      no-error.
    if not avail tntOctopus then leave blockrepeat.
    
    for each tntOctopus no-lock
      where tntOctopus.ttEnergyLevel > 9 
       and not tntOctopus.ttFlashedThisStep :
      /*if not tntOctopus.ttFlashedThisStep then*/
        viFlashes = viFlashes + 1.
        
      assign
        tntOctopus.ttEnergyLevel = 0
        tntOctopus.ttFlashedThisStep = yes.
        
        
      for each btntOctopus 
      where (btntOctopus.ttRow = tntOctopus.ttRow - 1 and (btntOctopus.ttColumn = tntOctopus.ttColumn - 1
                                                      or btntOctopus.ttColumn = tntOctopus.ttColumn + 1
                                                      or btntOctopus.ttColumn = tntOctopus.ttColumn))
            or
            (btntOctopus.ttRow = tntOctopus.ttRow    and (btntOctopus.ttColumn = tntOctopus.ttColumn - 1
                                                      or btntOctopus.ttColumn = tntOctopus.ttColumn + 1))                 
            or
            (btntOctopus.ttRow = tntOctopus.ttRow + 1 and (btntOctopus.ttColumn = tntOctopus.ttColumn - 1
                                                      or btntOctopus.ttColumn = tntOctopus.ttColumn + 1
                                                      or btntOctopus.ttColumn = tntOctopus.ttColumn))    
        :
        if btntOctopus.ttFlashedThisStep = no then
         btntOctopus.ttEnergyLevel = ttEnergyLevel + 1.      
      end.  
    end.
  end.
  
  
end procedure.



