using System.*.

define temp-table ttPosition no-undo
  field ttColumn as character extent 12.       
 
define variable vcLijn        as character no-undo.
define variable vcGammaRate   as character no-undo.
define variable vcEpsilonRate as character no-undo. 
define variable viLength      as integer   no-undo.
define variable viTeller      as integer   no-undo. 
 
create ttPosition. 
 
input from value("c:\temp\adventofcode\2021\day3_input").
repeat on error undo, leave on endkey undo, leave:
  import unformatted vcLijn.
  
  if viLength = 0 then
    viLength = length(vcLijn).
    
  do viTeller = 1 to viLength:
    ttColumn[viTeller] = ttColumn[viTeller] + substring(vcLijn, viTeller, 1).
  end.
end.
input close.

do viTeller = 1 to viLength:
  vcGammaRate = vcGammaRate + (if num-entries(ttColumn[viTeller], "0")  > num-entries(ttColumn[viTeller], "1") then "0" else "1").
end.

do viTeller = 1 to viLength:
  vcEpsilonRate = vcEpsilonRate + (if substring(vcGammaRate, viTeller, 1) = "0" then "1" else "0").
end.

message "Gamma: " Convert:ToInt32(vcGammaRate, 2)   skip 
        "Epsilon: " Convert:ToInt32(vcEpsilonRate, 2) skip 
        "x: " Convert:ToInt32(vcGammaRate, 2)   *  Convert:ToInt32(vcEpsilonRate, 2) 
  view-as alert-box info.
  
