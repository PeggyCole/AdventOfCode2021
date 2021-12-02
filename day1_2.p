define variable vcLijn as character no-undo.
define variable viGetal1 as integer no-undo.
define variable viGetal2 as integer no-undo.
define variable viGetal3 as integer no-undo.
define variable viGetal0 as integer no-undo.
define variable viTeller as integer no-undo.
define variable viFound as integer no-undo.

input from value("c:\temp\adventofcode\2021\day1_input").

repeat on error undo, leave on endkey undo, leave:
  import unformatted vcLijn.
  
  viTeller = viTeller + 1.
  
   case viTeller mod 4:
    when 0 then viGetal0 = int(vcLijn).
    when 1 then viGetal1 = int(vcLijn).
    when 2 then viGetal2 = int(vcLijn).
    when 3 then viGetal3 = int(vcLijn).
  end case.
    
  if viTeller ge 4 then
    case viTeller mod 4:
      when 0 then if viGetal2 + viGetal3 + viGetal0 > viGetal1 + viGetal2 + viGetal3 then viFound = viFound + 1.
      when 1 then if viGetal3 + viGetal0 + viGetal1 > viGetal2 + viGetal3 + viGetal0 then viFound = viFound + 1.
      when 2 then if viGetal0 + viGetal1 + viGetal2 > viGetal3 + viGetal0 + viGetal1 then viFound = viFound + 1.
      when 3 then if viGetal1 + viGetal2 + viGetal3 > viGetal0 + viGetal1 + viGetal2 then viFound = viFound + 1.
    end case.      
end.

input close.

message viFound view-as alert-box info.
