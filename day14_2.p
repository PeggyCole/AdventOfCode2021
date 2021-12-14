define temp-table ttReplace no-undo
  field ttFrom as character
  field ttTo as character
  index ttFrom ttFrom.      
  
define temp-table ttResult no-undo 
  field ttShortString as character
  field ttFlag as logical
  field ttOccurs as int64
  index ttFlag ttFlag.
  
define temp-table ttDiffChar no-undo
  field ttCharacter as character
  field ttOccurs as int64. 

define buffer bttresult for ttresult.

define variable vlFlag as logical   no-undo initial yes.  
define variable vi     as integer   no-undo.  
define variable viMax  as int64     no-undo.
define variable viMin  as int64     no-undo initial 9999999.

run readFile.

do vi = 1 to 40:
   vlFlag = not vlFlag.
   
   for each ttResult where ttResult.ttFlag = vlFlag by ttResult.ttShortString :
      
      find first ttReplace no-lock
        where ttReplace.ttFrom = ttResult.ttShortString no-error.
        
        
      if avail ttReplace then
      do:
        find ttDiffChar where ttDiffChar.ttCharacter = ttTo no-error.
          if not avail ttDiffChar then
          do:
            create ttDiffChar.
            assign
              ttDiffChar.ttCharacter =  ttTo.
          end.
          ttDiffChar.ttOccurs = ttDiffChar.ttOccurs + ttResult.ttOccurs.
          
          
        find bttResult no-lock
          where bttResult.ttShortString = substring(ttFrom, 1, 1) + ttTo
          and bttResult.ttFlag <> vlFlag
          no-error.
          
        if not avail bttResult then do:
          create bttResult.
          assign 
            bttResult.ttShortString = substring(ttFrom, 1, 1) + ttTo.          
        END.
        if avail bttResult then
          assign 
            bttResult.ttFlag = not vlFlag
            bttResult.ttOccurs = bttResult.ttOccurs + ttResult.ttOccurs.
        
        
        find bttResult no-lock
          where bttResult.ttShortString = ttTo + substring(ttFrom, 2, 1)
          and bttResult.ttFlag <> vlFlag
          no-error.
          
        if not avail bttResult then do:
          create bttResult.
          assign 
            bttResult.ttShortString = ttTo + substring(ttFrom, 2, 1).          
        END.
        if avail bttResult then
          assign 
            bttResult.ttFlag = not vlFlag
            bttResult.ttOccurs = bttResult.ttOccurs + ttResult.ttOccurs.
            
      end.
      else do:  
        find bttResult no-lock
          where bttResult.ttShortString = ttResult.ttShortString
          and bttResult.ttFlag <> vlFlag
          no-error.
          
        if not avail bttResult then do:
          create bttResult.
          assign 
            bttResult.ttShortString = ttResult.ttShortString.          
        END.
        if avail bttResult then
          assign 
            bttResult.ttFlag = not vlFlag
            bttResult.ttOccurs = bttResult.ttOccurs + ttResult.ttOccurs.
      
      END.
    end.
    
   for each ttResult no-lock where ttResult.ttFlag = vlFlag:
     delete ttResult.
   end.
end.



for each ttDiffchar by ttDiffchar.ttOccurs:
  viMin = ttDiffChar.ttoccurs.
  leave.
end.
for each ttDiffchar by ttDiffchar.ttOccurs desc:
  viMax = ttDiffChar.ttoccurs.
  leave.
end.

MESSAGE 
    viMax - viMin
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    
    
/*
---------------------------
Information
---------------------------

3459822539451
---------------------------
OK   
---------------------------
*/



            
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn    as character no-undo.
  define variable viCounter AS INTEGER     no-undo.
  
  input from value("c:\temp\adventofcode\2021\day14_input").        
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    if num-entries(vcLijn, "-":u) = 2 then
    do:
      vcLijn = replace(vcLijn, " -> ", ",").
      create ttReplace.
      assign
        ttFrom = entry(1, vcLijn, ",":u)
        ttTo = entry(2, vcLijn, ",":u).
    end.
    else do:
      if vcLijn ne "" then do:
        do viCounter = 1 to length(vcLijn):
          if viCOunter <= length(vcLIjn) - 1 then do:
             
            create ttResult.
            assign 
              ttResult.ttShortString = substring(vcLijn, viCounter, 1) + substring(vcLIjn, viCounter + 1, 1)
              ttResult.ttFlag = false
              ttResult.ttOccurs = ttResult.ttOccurs + 1.
          end.
          
          find ttDiffChar where ttDiffChar.ttCharacter = substring(vcLijn, viCounter, 1) no-error.
          if not avail ttDiffChar then
          do:
            create ttDiffChar.
            assign
              ttDiffChar.ttCharacter =  substring(vcLijn, viCounter, 1).
          end.
          ttDiffChar.ttOccurs = ttDiffChar.ttOccurs + 1.
        end.
      end.
    end.
  end. 
  input close.
  
end procedure.
