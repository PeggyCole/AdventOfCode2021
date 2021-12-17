
/*target area: x=85..145, y=-163..-108*/    
/*target area: x=20..30, y=--10..-5*/
  
define variable viMinx as integer     no-undo initial 85.
define variable viMaxx as integer     no-undo initial 145.
define variable viMiny as integer     no-undo initial -163.
define variable viMaxy as integer     no-undo initial -108. 
  
define variable viMoveX      as integer     no-undo.  
define variable viMoveY      as integer     no-undo.
define variable viMaxTargetY as integer     no-undo.
define variable viTargetY    as integer     no-undo.

do viMovex = 1 to viMaxx:
  do viMoveY = min(viMiny, viMaxy) to max(abs(viMiny), abs(viMaxy)):
    run getRoute (viMovex, viMoveY, output viTargetY).
    
    if viTargetY > viMaxTargetY then
     viMaxTargetY = viTargetY.
  end.
end.

message viMaxTargetY view-as alert-box. 

/*---------------------------
Message
---------------------------
13203
---------------------------
OK   
---------------------------
*/


procedure getRoute :

 define input  parameter ipiVelocityStartX as integer     no-undo.
 define input  parameter ipiVelocityStartY as integer     no-undo.
 define output parameter opiHighesty       as integer     no-undo.
 
 define variable viCurrentVelocityx as integer     no-undo.
 define variable viCurrentVelocityy as integer     no-undo. 
 define variable viCurrentTargetX   as integer     no-undo.
 define variable viCurrentTargetY   as integer     no-undo. 
 define variable vlHit              as logical     no-undo.
 define variable vlFirst            as logical     no-undo initial yes.
 
 assign
   viCurrentVelocityx = ipiVelocityStartX
   viCurrentVelocityy = ipiVelocityStartY.
  
 TakeAJump:
 repeat:
    if not vlFirst then
    do:            
       if viCurrentVelocityx > 0 then
         viCurrentVelocityx = viCurrentVelocityx - 1.
       if viCurrentVelocityx < 0 then
         viCurrentVelocityx = viCurrentVelocityx + 1.
         
         viCurrentVelocityy = viCurrentVelocityy - 1.
     end.
     else 
       vlFirst = no.
     
    assign
      viCurrentTargetX = viCurrentTargetX + viCurrentVelocityx
      viCurrentTargetY = viCurrentTargetY + viCurrentVelocityy.
    
    if viCurrentTargetY > opiHighesty then
      opiHighesty = viCurrentTargetY.
  
   if viCurrentTargetX ge viMinx and viCurrentTargetX le viMaxx 
     and viCurrentTargetY ge viMiny and viCurrentTargetY le viMaxy
     then do:
     vlHit = yes.
     leave TakeAJump.
   end.
   
   if viCurrentTargetX gt viMaxx
     or (viCurrentTargetY > 0 and viMaxY > 0 and viCurrentTargetY gt viMaxy) 
     or (viCurrentTargetY < 0 and viMaxY < 0 and  viCurrentTargetY lt viMaxy)
     then
     leave TakeAJump.
   
 END.

 if not vlHit then
   opiHighestY = 0.
   
 
end procedure.
