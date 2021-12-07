define variable viCrabs            as integer no-undo extent.
define variable viMin              as integer no-undo.
define variable viMax              as integer no-undo.
define variable viCurrent          as integer no-undo.
define variable viCheapest         as integer no-undo.
define variable viCost             as integer no-undo.
etime(yes).
run readFile.

viCheapest = 999999999.
do viCurrent = viMin to viMax:
  
  run CalculateCost (input viCurrent, output viCost).
  
  if viCost <> 0 and viCost < viCheapest then
    viCheapest = viCost.
end.

message  viCheapest view-as alert-box info.

/*
---------------------------
Information
---------------------------
100727924
---------------------------
OK   
---------------------------

*/

  
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn    as character no-undo.
  define variable viTeller  as integer   no-undo.
  
  input from value("c:\temp\adventofcode\2021\day7_input").
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    extent(viCrabs) = num-entries(vcLIjn, ",":u).
    
    do viTeller = 1 to num-entries(vcLijn, ",":u):
      viCrabs[viTeller] = int(entry(viTeller, vcLijn, ",":u)).
      
      if (viMin <> 0 or viCrabs[viTeller] = 0) and viCrabs[viTeller] < viMin then
        viMin = viCrabs[viTeller].
        
      if viCrabs[viTeller] > viMax then
        viMax = viCrabs[viTeller].
    end.
  end.

  input close.
end procedure.

procedure CalculateCost:
  define input  parameter ipiCurrent as integer no-undo.
  define output parameter opiCost    as integer no-undo. 
  
  define variable viExtent      as integer no-undo.
  define variable viTotalExtent as integer no-undo.
  define variable vi            as integer no-undo.                        
  define variable viDiff        as integer no-undo.
  
  viTotalExtent = extent(viCrabs).
  
  blockSum:  
  do viExtent = 1 to viTotalExtent:
    viDiff = abs(ipiCurrent - viCrabs[viExtent]).
    
    opiCost = opiCost + (viDiff * (viDiff + 1) / 2).
  end.
  
end procedure.
