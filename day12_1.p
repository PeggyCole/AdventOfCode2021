define temp-table ttPath  no-undo
  field ttFrom as character case-sensitive
  field ttTo as character case-sensitive.
  
  
define temp-table ttFoundPath no-undo
  field ttPathSteps as character.

define variable viPaths as integer no-undo.


run readFile.

run searchPaths ("start", "start").

for each ttFoundPath by ttPathSteps :
  viPaths = viPaths + 1.
end.

message viPaths view-as alert-box info.

  
/* --- Internal Procedures --- */  
procedure readFile:
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
   
   define variablevcCurrentPath as character no-undo.
   
   define buffer ttPath for ttPath.
   
   for each ttPath where ttPath.ttFrom = ipcFrom:
     vcCurrentPath = ipcCurrentPath.
     
     if ttPath.ttTo eq lc(ttPath.ttTo) and lookup(ttPath.ttTo, vcCurrentPath, ",":u) > 0 then
       next.
       
     vcCurrentPath = vcCurrentPath + ",":u + ttPath.ttTo.
     
     if ttPath.ttTo = "end" then do:
       create ttFoundPath.
       assign 
         ttFoundPath.ttPathSteps = vcCurrentPath
         vcCurrentPath = "".
     end.
     else
       run searchPaths (input ttPath.ttTo, input vcCurrentPath).
     
   end.
   
end procedure


