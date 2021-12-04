session:debug-alert = yes.

define temp-table ttRowColumn
  field ttBoard as integer
  field ttDirection as character /* H of V */
  field ttRowColumn as integer
  field ttValues as character
  index PK as primary unique ttBoard ttDirection ttRowColumn .

define variable vcNumbers as character no-undo.
define variable viCurrentBoard as integer no-undo.
define variable viCurrentRow as integer no-undo.
define variable viRowTeller as integer no-undo.


define variable viBoard as integer no-undo.
define variable viWinningNumber as integer no-undo.
define variable viTotal as integer no-undo.

run readFile.
run playBingo (output viBoard, output viWinningNumber).  

for each ttRowColumn 
  where ttRowColumn.ttBoard = viBoard
  and ttRowColumn.ttDirection = "H":
  do viRowTeller = 1 to num-entries(ttRowColumn.ttValue, ",":u) :
    if entry(viRowTeller, ttRowColumn.ttValue, ",":u) ne "" then
      viTotal = viTotal + int(entry(viRowTeller, ttRowColumn.ttValue, ",":u)).     
  end.
end.

message viBoard viTotal skip viWinningNumber skip viTotal * viWinningNumber 
  view-as alert-box info.

  
  
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn as character no-undo.
  define variable viTeller as integer no-undo.

  empty temp-table ttRowColumn. 
  input from value("c:\temp\adventofcode\2021\day4_input").
  
  import unformatted vcNumbers.  

  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    vcLijn = trim(vcLijn).
    
    if vcLijn = "" then
      assign
        viCurrentBoard = viCurrentBoard + 1
        viCurrentRow = 0.    
    else do:
       vcLijn = replace(vcLIjn, "  ":u, " ").
       viCurrentRow = viCurrentRow + 1. 
       
       find ttRowColumn no-lock 
         where ttRowColumn.ttBoard = viCurrentBoard
         and ttRowColumn.ttDirection = "H":u
         and ttRowColumn.ttRowColumn = viCurrentRow
         no-error.
       if not avail ttRowColumn then
       do:
         create ttRowColumn.
         assign
           ttRowColumn.ttBoard = viCurrentBoard
           ttRowColumn.ttDirection = "H":u
           ttRowColumn.ttRowColumn = viCurrentRow.          
       end.
       if avail ttRowCOlumn then
         assign 
           ttRowColumn.ttValues = replace(vcLIjn, " ":u, ",":u).
           
       do viTeller = 1 to 5:
         find ttRowColumn no-lock 
           where ttRowColumn.ttBoard = viCurrentBoard
           and ttRowColumn.ttDirection = "V":u
           and ttRowColumn.ttRowColumn = viTeller
           no-error.    
           
         if not avail ttRowColumn then
         do:
           create ttRowColumn.
           assign
             ttRowColumn.ttBoard = viCurrentBoard
             ttRowColumn.ttDirection = "V":u
             ttRowColumn.ttRowColumn = viTeller.          
         end. 
         
         assign 
           ttRowColumn.ttValues = trim(ttRowColumn.ttValues + ",":u + entry(viTeller, vcLijn, " ":u), ",":u).
       end.    
    end.       
  end.

  input close.
end procedure.

procedure playBingo:
  define output parameter opiBoard as integer no-undo.
  define output parameter opiWinningNumber as integer no-undo.
  define variable viTeller as integer no-undo. 
  define variable viLookup as integer no-undo.
   
  block1:
  do viTeller = 1 to num-entries(vcNumbers, ",":u):
    for each ttRowColumn:
      viLookup = lookup(entry(viTeller, vcNumbers, ",":u), ttRowColumn.ttValues, ",":u).
      if viLookup > 0 then  do:
        /*ttRowColumn.ttValues = replace(ttRowColumn.ttValue, entry(viTeller, vcNumbers, ",":u), "").*/
        
        entry(viLookup, ttRowColumn.ttValues, ",":u) = "".  
      end.
        
      
      if trim(ttRowColumn.ttValues, ",":u) = "" then
      do:
         opiBoard = ttRowColumn.ttBoard .
         opiWinningNumber = int(entry(viTeller, vcNumbers, ",":u)).
         /*message "Board: " ttRowColumn.ttBoard view-as alert-box info.*/
         leave block1.
      end.
    end.            
  end.                        

end procedure.
