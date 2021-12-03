define variable vcLijn    as character no-undo.
define variable viColumn  as integer   no-undo.
define variable viGetal   as integer   no-undo extent 4.
define variable viTeller  as integer   no-undo.
define variable viFound   as integer   no-undo.

input from value("c:\temp\adventofcode\2021\day1_input").

repeat on error undo, leave on endkey undo, leave:
  import unformatted vcLijn.
  
  assign
    viTeller = viTeller + 1
    viColumn = (viTeller mod 4).
    
  if viColumn = 0 then viColumn = 4.
  
  viGetal[viColumn] = int(vcLijn).
  
  if viTeller ge 4 then do:
    case viColumn:
      when 1 then if viGetal[viColumn + 2] + viGetal[viColumn + 3] + viGetal[viColumn] > viGetal[viColumn + 1] + viGetal[viColumn + 2] + viGetal[viColumn + 3] then viFound = viFound + 1.
      when 2 then if viGetal[viColumn + 2] + viGetal[viColumn - 1] + viGetal[viColumn] > viGetal[viColumn + 1] + viGetal[viColumn + 2] + viGetal[viColumn - 1] then viFound = viFound + 1.
      when 3 then if viGetal[viColumn - 2] + viGetal[viColumn - 1] + viGetal[viColumn] > viGetal[viColumn + 1] + viGetal[viColumn - 2] + viGetal[viColumn - 1] then viFound = viFound + 1.
      when 4 then if viGetal[viColumn - 2] + viGetal[viColumn - 1] + viGetal[viColumn] > viGetal[viColumn - 3] + viGetal[viColumn - 2] + viGetal[viColumn - 1] then viFound = viFound + 1.      
    end case. 
  end.
end.

input close.

message viFound view-as alert-box info.
