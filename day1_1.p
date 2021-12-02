define variable vcLijn as character no-undo.
define variable viGetal as integer no-undo.
define variable viPrev as integer no-undo.
define variable viFound as integer no-undo.

input from value("c:\temp\adventofcode\2021\day1_input").

repeat on error undo, leave on endkey undo, leave:
  import unformatted vcLijn.
  
  viGetal = int(vcLijn).
  
  if viPrev <> 0 and viGetal > viPrev then
    viFound = viFound + 1.
    
    
  viPrev = viGetal.  
  
end.

input close.

message viFound view-as alert-box info.
