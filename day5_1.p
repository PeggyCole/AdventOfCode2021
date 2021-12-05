session:debug-alert = yes.

define temp-table ttPosition
  field ttX as integer
  field ttY as integer
  field ttLines as integer
  index PK as primary unique ttX ttY
  .
  
define variable viCount as integer     no-undo.

run readFile.

for each ttPosition no-lock
  where ttPosition.ttLines ge 2:
  viCount = viCount + 1.
end.

message viCount view-as alert-box info.  


  
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn    as character no-undo.
  define variable viTeller  as integer   no-undo.
  define variable viFromX   as integer   no-undo.
  define variable viFromY   as integer   no-undo.
  define variable viToX     as integer   no-undo.
  define variable viToY     as integer   no-undo.
  define variable viFrom    as integer   no-undo.
  define variable viTo      as integer   no-undo.
  
  empty temp-table ttPosition. 
  input from value("c:\temp\adventofcode\2021\day5_input").
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    vcLijn = trim(vcLijn).
    
    vcLijn = replace(vcLIjn, " -> ":u, ",").
    
    viFromX = int(entry(1, vcLIjn, ",":u)).
    viFromY = int(entry(2, vcLIjn, ",":u)).
    viToX = int(entry(3, vcLIjn, ",":u)). 
    viToY = int(entry(4, vcLIjn, ",":u)) .
    
    
    if viFromX <> viTOX and viFromY = viTOY then
    do:
      if viFromX < viToX then
        assign
          viFrom = viFromX
          viTo = viToX.
      else
        assign
          viFrom = viToX
          viTo = viFromX.
          
      do viTeller = viFrom to viTo:
        run FillTT (viTeller, viFromY).                
      end.
    end.
    
    if viFromY <> viToY and viFromX = viToX then
    do:
      if viFromY < viToY then
        assign
          viFrom = viFromY
          viTo = viToY.
      else
        assign
          viFrom = viToY
          viTo = viFromY.
          
      do viTeller = viFrom to viTo:
        run FillTT (viFromX, viTeller).        
      end.                                         
    end.
  end.

  input close.
end procedure.


procedure FillTT:
  define input parameter ipiX as integer no-undo.
  define input parameter ipiY as integer no-undo.
  
  find ttPosition no-lock
    where ttPosition.ttX = ipiX
    and ttPosition.ttY = ipiY
          no-error.
          
  if not avail ttPosition then
  do:
    create ttPosition.
    assign
      ttPosition.ttX = ipiX
      ttPosition.ttY = ipiY.
  end.
        
  if avail ttPosition then 
    assign 
      ttLines = ttLines + 1.

end procedure

