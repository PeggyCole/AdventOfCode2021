define temp-table ttPath  no-undo
  field ttFrom as character case-sensitive
  field ttTo   as character case-sensitive.
  
define variable viPaths as integer no-undo.

run readFile.

run searchPaths ("start", "start").

message viPaths view-as alert-box info.

/*---------------------------
Information
---------------------------
143562
---------------------------
OK   
---------------------------  */


  
/* --- Internal Procedures --- */  
procedure readFile:
  define buffer ttCave for ttCave.
  
  define variable vcLijn        as character no-undo.
  
  input from value("c:\temp\adventofcode\2021\day12_input").        
  
  repeat on error undo, leave on endkey undo, leave:
    import unformatted vcLijn.
    
    create ttPath.
    assign
       ttFrom = entry(1, vcLIjn, "-":u)
       ttTo = entry(2, vcLIjn, "-":u) .
      
    create ttPath.
    assign
       ttFrom = entry(2, vcLIjn, "-":u)
       ttTo = entry(1, vcLIjn, "-":u) .           
  end.

  input close.
  
end procedure.

procedure searchPaths:
   define input parameter ipcFrom        as character no-undo.
   define input parameter ipcCurrentPath as character no-undo.
   
   define variable vcCurrentPath         as character   no-undo case-sensitive.
   define variable vcSingleCaves         as character   no-undo case-sensitive.
   define variable vcCurrentEntry        as character   no-undo case-sensitive.
   define variable viCounter             as integer     no-undo.
   define variable vlAlreadyOneCaveTwice as logical     no-undo.
   
   define buffer ttPath for ttPath.
   define buffer bttPath for ttPath.

   blockPath:
   for each ttPath where ttPath.ttFrom = ipcFrom:
     vcCurrentPath = ipcCurrentPath.
     
     if ttPath.ttTo eq lc(ttPath.ttTo) and lookup(ttPath.ttTo, vcCurrentPath, ",":u) > 0 then do:
       if ttPath.ttTo = "start":u or ttPath.ttTo = "end":u then
         next.
       else do:
         vlAlreadyOneCaveTwice = false.
         vcSingleCaves = "".
         
         blockCounter:
         do viCounter = 1 to num-entries(vcCurrentPath, ",":u):
           vcCurrentEntry = entry(viCounter, vcCurrentPath, ",":u).
           
           if vcCurrentEntry eq lc(vcCurrentEntry) then
           do:
             if lookup (vcCurrentEntry, vcSingleCaves, ",":u) = 0 then
               vcSingleCaves = vcSingleCaves + ",":u + vcCurrentEntry.
             else do:
               vlAlreadyOneCaveTwice = true.
               leave blockCounter.
             end.
           end.
         end.
         
         if vlAlreadyOneCaveTwice then next blockPath.     
       end.
     end.  
     
     vcCurrentPath = vcCurrentPath + ",":u + ttPath.ttTo.
     
     if ttPath.ttTo = "end":u then 
       assign
         viPaths = viPaths + 1
         vcCurrentPath = "".
     else
       run searchPaths (input ttPath.ttTo, input vcCurrentPath).
     
   end.
   
end procedure


