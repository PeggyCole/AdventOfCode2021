define temp-table ttReplace no-undo
  field ttFrom as character
  field ttTo as character
  .      
  
  
DEFINE VARIABLE vi AS INTEGER     NO-UNDO.  
DEFINE VARIABLE viResult AS INTEGER     NO-UNDO.
define variable vcResult as character no-undo.  
define variable vcNewResult as character no-undo.
DEFINE VARIABLE vcLetters AS CHARACTER   NO-UNDO.

run readFile.

do vi = 1 to 10:
  vcNewResult = "".
  do viResult = 1 to length(vcResult) - 1:
      find ttReplace no-lock
        where ttReplace.ttFrom = substring(vcResult, viResult, 1) + substring(vcResult, viResult + 1, 1)
        no-error.
        
      if avail ttReplace then do:
        vcNewResult = vcNewResult + substring(ttFrom, 1, 1) + ttTo.
        
        if not vcLetters matches "*" + substring(ttFrom, 1, 1) + "*" then
          vcLetters = vcLetters + ",":u + substring(ttFrom, 1, 1).
          
        if not vcLetters matches "*" + ttTo + "*" then
          vcLetters = vcLetters + ",":u + ttTo.
      end.
      else do:
      
        vcNewResult = vcNewResult + substring(vcResult, viResult, 1).
        
        if not vcLetters matches "*" + substring(vcResult, viResult, 1) + "*" then
          vcLetters = vcLetters + ",":u + substring(vcResult, viResult, 1).
      end.
  end.
  
  vcNewResult = vcNewResult + substring(vcResult, length(vcResult), 1).
  
  vcResult = vcNewResult.
end.

DEFINE VARIABLE viMax AS INTEGER     NO-UNDO.
DEFINE VARIABLE viMin AS INTEGER     NO-UNDO initial 99999.
DEFINE VARIABLE viLetter AS INTEGER     NO-UNDO.

vcLetters = trim(vcLetters).

do viLetter = 1 to num-entries(vcLetters, ",":u):
  if num-entries(vcResult, entry(viLetter, vcLetters, ",")) - 1 > viMax then
    viMax = num-entries(vcResult, entry(viLetter, vcLetters, ",")) - 1.
    
  if num-entries(vcResult, entry(viLetter, vcLetters, ",")) - 1 < viMin 
    and num-entries(vcResult, entry(viLetter, vcLetters, ",")) - 1 > 0
    then
    viMin = num-entries(vcResult, entry(viLetter, vcLetters, ",")) - 1.
  
end.



MESSAGE /*vcResult skip */
    num-entries(vcResult, "N") - 1 skip 
    num-entries(vcResult, "H":u) skip 
    num-entries(vcResult, "B":u) skip
    num-entries(vcResult, "C" )    skip 
    vcLetters skip viMax skip viMin skip viMax - viMin
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.


/*---------------------------
Information
---------------------------
701
---------------------------
OK   
---------------------------   */

  
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn    as character no-undo.
  
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
    else
      if vcLijn ne "" then
        vcResult = vcLijn.
    
  end.

  input close.
  
end procedure.
