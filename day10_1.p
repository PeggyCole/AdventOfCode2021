 
run readFile.

/*
---------------------------
Information
---------------------------
271245
---------------------------
OK   
---------------------------
*/

/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn       as character no-undo.
  define variable vcCorrupted  as character no-undo.
  define variable vlIncomplete as logical   no-undo.
  define variable viScore      as integer   no-undo.
  
  input from value("c:\temp\adventofcode\2021\day10_input").        
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    run getCorruptedCharacter (input vcLijn, output vcCorrupted).  
    
    case vcCorrupted:
      when ")":u then viScore = viScore + 3.
      when "]":u then viScore = viScore + 57.
      when "}":u then viScore = viScore + 1197.
      when ">":u then viScore = viScore + 25137.      
    end case.
  end.

  input close.
  
  message viScore view-as alert-box info.
  
end procedure.

procedure getCorruptedCharacter:
  define input  parameter  ipcLine       as character   no-undo.
  define output parameter  opcMissing    as character   no-undo.
  
  define variable viOpen as integer no-undo.
  define variable viClose as integer no-undo.
  
  define variable viCounter as integer no-undo.
  
  define variable vcRest as character no-undo.
  
  blockCounter:
  do viCounter = 1 to length(ipcLine):
    case substring(ipcLine, viCounter, 1):
      when "(":u 
        or when "[":u 
        or when "~{":u
        or when "<":u         
         then vcRest = vcRest + substring(ipcLine, viCounter, 1).         
      when ")" then do:
        if vcRest matches "*(":u then 
          vcRest = substring(vcRest, 1, length(vcRest) - 1).
        else do:
          opcMissing = ")":u.
          leave blockCounter.
        end.
      end.
      when "]":u then do:
        if vcRest matches "*[":u then 
          vcRest = substring(vcRest, 1, length(vcRest) - 1).
        else do:
          opcMissing = "]":u.
          leave blockCounter.
        end.
      end. 
      when "~}":u then do:
        if vcRest matches "*~{":u then 
          vcRest = substring(vcRest, 1, length(vcRest) - 1).
        else do:
          opcMissing = "~}":u.
          leave blockCounter.
        end.
      end.
      when ">":u then do:
        if vcRest matches "*<":u then 
          vcRest = substring(vcRest, 1, length(vcRest) - 1).
        else do:
          opcMissing = ">":u.
          leave blockCounter.
        end.
      end.
    end case.
  end.         
end procedure.


