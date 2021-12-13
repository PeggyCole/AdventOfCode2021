define temp-table ttDot no-undo
  field ttRow as integer
  field ttColumn as integer
  field ttValue as character
  index PK as primary unique ttRow ttColumn.
  
  
define temp-table ttFold no-undo
 field ttDirection as character
 field ttPosition as integer.
  
run readFile.

for each ttFold:
  if ttDirection = "y" then
    run foldY (input ttPosition).   
  else
    run foldX (input ttPosition).  
end.   


DEFINE VARIABLE viRow    AS INTEGER     NO-UNDO.
DEFINE VARIABLE viColumn AS INTEGER     NO-UNDO.
output to value("c:\temp\adventofcode\2021\day13_output.txt").
do viRow = 1 to 100:
  do viColumn = 1 to 100:
    find ttDot no-lock where ttDot.ttRow = viRow and ttDot.ttColumn = viColumn no-error.
    
    if avail ttDot then 
      put unformatted ttDot.ttValue.
    else
      put unformatted ".".
    
  end.
  
  put unformatted skip.
end.
output close.

os-command silent value("c:\temp\adventofcode\2021\day13_output.txt").


  
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn    as character no-undo.
  
  input from value("c:\temp\adventofcode\2021\day13_input").        
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    if num-entries(vcLijn, ",":u) = 2 then
    do:
      create ttDot.
      assign
        ttDot.ttRow = int(entry(2, vcLijn, ",":u)) + 1
        ttDot.ttColumn = int(entry(1, vcLijn, ",":u)) + 1
        ttDot.ttValue = "#".
    end.
    
    if vcLijn begins "fold along " then do:
      create ttFold. 
      assign 
        ttFold.ttDirection = (if vcLijn begins "fold along y" then "y" else "x")
        ttFold.ttPosition = int(entry(2, vcLijn, "=":u)) + 1.
     
    end.
  end.

  input close.
  
end procedure.

procedure foldX:
  define input parameter ipiFoldX as integer no-undo.
  
  define variable viTotalColumns as integer no-undo.
  
  viTotalColumns = ipiFoldX + (ipiFoldX - 1).
  
  define buffer ttDot for ttDot.
  define buffer bttDot for ttDot.

  for each ttDot where ttDot.ttColumn = ipiFoldX:
    delete ttDot.    
  end.
  
  for each ttDot 
    where ttDot.ttColumn > ipiFoldX 
    and ttDot.ttValue = "#":u
    by ttRow:
    find bttDot 
      where bttDot.ttColumn = (viTotalColumns - ttDot.ttColumn + 1)
      and bttDot.ttRow = ttDot.ttRow
      no-error.
      
    if not avail bttDot then
    do:
      create bttDot.
      assign
        bttDot.ttColumn = (viTotalColumns - ttDot.ttColumn + 1)
        bttDot.ttRow = ttDot.ttRow. 
    end.
    
    if avail bttDot then
      bttDot.ttValue = "#":u.
      
    delete ttDot.  
  end.

end.


procedure foldY:
  define input parameter ipiFoldY as integer no-undo.
  
  define variable viTotalRows as integer no-undo.
  
  viTotalRows = ipiFoldY + (ipiFoldY - 1).
  
  define buffer ttDot for ttDot.
  define buffer bttDot for ttDot.

  for each ttDot where ttDot.ttRow = ipiFoldY:
    delete ttDot.    
  end.
  
  for each ttDot 
    where ttDot.ttRow > ipiFoldY 
    and ttDot.ttValue = "#":u
    by ttRow:
    find bttDot 
      where bttDot.ttRow = (viTotalRows - ttDot.ttRow + 1)
      and bttDot.ttColumn = ttDot.ttColumn
      no-error.
      
    if not avail bttDot then
    do:
      create bttDot.
      assign
        bttDot.ttRow = (viTotalRows - ttDot.ttRow + 1)
        bttDot.ttColumn = ttDot.ttCOlumn.           
    end.
    
    if avail bttDot then
      bttDot.ttValue = "#":u.
      
    delete ttDot.  
  end.

end.
