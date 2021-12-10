define temp-table ttScore no-undo
  field ttLijn as integer   
  field ttPoints as int64.

run readFile.

/*
---------------------------
Information
---------------------------
1685293086
---------------------------
OK   
---------------------------

*/

  
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn       as character no-undo.
  define variable vcCorrupted  as character no-undo.
  define variable vcRemaining  as character no-undo.
  define variable viScore      as int64     no-undo.  
  define variable viScores     as int64     no-undo extent 500.
  define variable viLijn       as integer   no-undo.     
  define variable viCounter    as integer   no-undo.
 
  input from value("c:\temp\adventofcode\2021\day10_input").        
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.     
   
    run getCorruptedCharacters (input vcLijn, output vcCorrupted).
    if vcCorrupted ne "" then next.  
    
    run getRemainingChars (input vcLijn, output vcRemaining).
    
    viScore = 0.
    if vcRemaining <> "" then
    do:           
      do viCounter = length(vcRemaining) to 1 by -1:      
        case substring(vcRemaining, viCounter, 1):
          when "(":u  then viScore = (viScore * 5) + 1.
          when "[":u  then viScore = (viScore * 5) + 2.
          when "~{":u then viScore = (viScore * 5) + 3.
          when "<":u  then viScore = (viScore * 5 ) + 4.      
        end case.  
      end.

      create ttScore.
      assign
        viLijn = viLijn + 1
        ttScore.ttLijn = viLijn
        ttScore.ttPoints = viScore.
    end.
  end.  
  input close.
  
  for each ttScore by ttScore.ttPoints:
    viCounter = viCounter + 1.
    
    if viCounter = (viLijn + 1) / 2 then do:
      message ttScore.ttPoints view-as alert-box info.
      leave.
    end.
  end.    
end procedure.


procedure getRemainingChars:
  define input  parameter  ipcLine           as character no-undo.
  define output parameter  opcRemainingChars as character no-undo.
  
  define variable viOpen      as integer   no-undo.
  define variable viClose     as integer   no-undo.  
  define variable viCounter   as integer   no-undo.
  define variable vcRemaining as character no-undo.
  
  do viCounter = 1 to length(ipcLine):
    case substring(ipcLine, viCounter, 1):
      when "(":u
        or when "[":u 
        or when "~{":u
        or when "<":u         
         then 
            assign 
              viOpen = viOpen + 1
              vcRemaining = vcRemaining + substring(ipcLine, viCounter, 1).
      when ")":u then do:
        viClose = viClose + 1.
        
        if vcRemaining matches "*(":u then 
          assign 
            vcRemaining = substring(vcRemaining, 1, length(vcRemaining) - 1).
      end.
      when "]":u then do:
        viClose = viClose + 1.
        
        if vcRemaining matches "*[":u then 
          assign 
            vcRemaining = substring(vcRemaining, 1, length(vcRemaining) - 1).
      end. 
      when "~}":u then do:
        viClose = viClose + 1.
        
        if vcRemaining matches "*~{":u then 
          assign 
            vcRemaining = substring(vcRemaining, 1, length(vcRemaining) - 1).
      end.
      when ">":u then do:
        viClose = viClose + 1.
        
        if vcRemaining matches "*<":u then 
          assign 
            vcRemaining = substring(vcRemaining, 1, length(vcRemaining) - 1).
        
      end.
    end case.   
  end.        
  
  if  viOpen <> viClose then 
    opcRemainingChars = vcRemaining.    
end procedure.

procedure getCorruptedCharacters:
  define input  parameter  ipcLine       as character   no-undo.
  define output parameter  opcMissing    as character   no-undo.
  
  define variable viCounter   as integer  no-undo.  
  define variable vcRemaining as character no-undo.
  
  blockCounter:
  do viCounter = 1 to length(ipcLine):
    case substring(ipcLine, viCounter, 1):
      when "(":u 
        or when "[":u 
        or when "~{":u
        or when "<":u         
         then vcRemaining = vcRemaining + substring(ipcLine, viCounter, 1).         
      when ")" then do:
        if vcRemaining matches "*(":u then 
          vcRemaining = substring(vcRemaining, 1, length(vcRemaining) - 1).
        else do:
          opcMissing = ")":u.
          leave blockCounter.
        end.
      end.
      when "]":u then do:
        if vcRemaining matches "*[":u then 
          vcRemaining = substring(vcRemaining, 1, length(vcRemaining) - 1).
        else do:
          opcMissing = "]":u.
          leave blockCounter.
        end.
      end. 
      when "~}":u then do:
        if vcRemaining matches "*~{":u then 
          vcRemaining = substring(vcRemaining, 1, length(vcRemaining) - 1).
        else do:
          opcMissing = "~}":u.
          leave blockCounter.
        end.
      end.
      when ">":u then do:
        if vcRemaining matches "*<":u then 
          vcRemaining = substring(vcRemaining, 1, length( vcRemaining) - 1).
        else do:
          opcMissing = ">":u.
          leave blockCounter.
        end.
      end.
    end case.
  end.       

end procedure.


