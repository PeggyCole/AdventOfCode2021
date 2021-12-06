define temp-table ttLanternfish
  field ttTimer as integer
  field ttUpToDate as integer
  field ttAantal as int64
  .
  
define variable viDay as integer     no-undo.
define variable viSequenceCurrentValue as int64 no-undo.


run readFile.

do viDay = 1 to 256:
  run newDay (input viDay).
end.

viSequenceCurrentValue = 0.

for each ttLanternfish:
  viSequenceCurrentValue = viSequenceCurrentValue + ttLanternfish.ttAantal.  
end.

message viSequenceCurrentValue view-as alert-box info. 

/*
---------------------------
Information (Press HELP to view stack trace)
---------------------------
1590327954513
---------------------------
OK   Help   
---------------------------
*/
  
/* --- Internal Procedures --- */  
procedure readFile:
  define variable vcLijn    as character no-undo.
  define variable viTeller  as integer   no-undo.
  
  empty temp-table ttLanternFish. 
  input from value("c:\temp\adventofcode\2021\day6_input").
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    do viTeller = 1 to num-entries(vcLijn, ",":u):
     find ttLanternfish no-lock 
        where ttLanternfish.ttTimer = int(entry(viTeller, vcLijn, ",":u))
        no-error.
        
      if not avail ttLanternfish then
      do:
        create ttLanternfish.
        assign
          ttLanternfish.ttTimer = int(entry(viTeller, vcLijn, ",":u)).
      end.
      
      ttLanternfish.ttAantal = ttLanternfish.ttAantal + 1.
    end.
   
  end.

  input close.
  
end procedure.


procedure newDay:
   define input parameter ipiDay as integer no-undo.

   define buffer bttLanternFish for ttLanternFish.
   
   for each ttLanternFish where ttLanternFish.ttUpToDate = ipiDay - 1 by ttLanternFish.ttTimer desc:
     if ttLanternFish.ttTimer = 0 then
     do:
       assign
         ttLanternFish.ttUpToDate = ipiDay
         ttLanternFish.ttTimer = 6.
         
      
      find bttLanternfish no-lock 
        where bttLanternfish.ttTimer = 8
        no-error.
        
      if not avail bttLanternfish then
      do:
        create bttLanternfish.
        assign
          bttLanternfish.ttTimer = 8.
      end.
      
      assign
        bttLanternfish.ttUpToDate = ipiDay
        bttLanternfish.ttAantal = bttLanternfish.ttAantal + ttLanternfish.ttAantal.  
     end.
     else do:
       assign
         ttLanternFish.ttUpToDate = ipiDay
         ttLanternFish.ttTimer = ttLanternFish.ttTimer - 1.
       
     end.  
   end.
   
   for each ttLanternfish by ttLanternFish.ttTimer:
     for each bttLanternfish where bttLanternfish.ttTimer = ttLanternfish.ttTimer
     and rowid(bttLanternfish) <> rowid(ttLanternfish):
     
       ttLanternfish.ttAantal = ttLanternfish.ttAantal + bttLanternfish.ttAantal.
       delete bttLanternfish.
     end.
   end.
   

end procedure.

