define variable vcLijn as character no-undo.

DEFINE VARIABLE viForward AS INTEGER     NO-UNDO.
DEFINE VARIABLE viDepth   AS INTEGER     NO-UNDO.

input from value("c:\temp\adventofcode\2021\day2_input").

repeat on error undo, leave on endkey undo, leave:
  import unformatted vcLijn.
  
  if vcLijn begins "forward" then
    viForward = viForward + int(entry(2, vcLIjn, " ")).
    
  if vcLijn begins "down" then
    viDepth = viDepth + int(entry(2, vcLIjn, " ")).  
    
  if vcLijn begins "up" then
    viDepth = viDepth - int(entry(2, vcLIjn, " ")).    
end.

input close.


message viForward skip viDepth skip viForward * viDepth
  view-as alert-box info.
  
