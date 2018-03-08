;;; defining agents, global and local variables
breed [individual1s individual1]
breed [individual2s individual2]
individual1s-own [energy group preg hat give rece id effi]
individual2s-own [energy group preg hat give rece id effi]
globals [in-min1 in-min2 in-eff1 in-eff2 sel-eff1 sel-eff2 e1 e2 ee s1 s2 seas totenergy totenergy1 totenergy2 epoch n1 n2 cum_pop_size1 cum_pop_size2 avg_pop_size1 avg_pop_size2 ratio_pop_size]
;;; Parameters

;;; Observer methods (GUI)

to setup
  clear-all
  reset-ticks
  setup-individual1s
  setup-individual2s
end

to go
  tick
  do-totenergy
  do-sucess
  do-individual1s
  do-individual2s
  divide
  death
  do-totenergy
  do-sharing
  do-init
  do-final
  if ticks > 5000 [stop]
;  
end

;;; Individuals methods
to do-sucess
;  set s1 tot_res / (max_energy * (count individual1s))
;  set s2 tot_res / (max_energy * (count individual2s))
  set s1 tot_res / totenergy1
  set s2 tot_res / totenergy2
;set s1 0.71
;set s2 0.71
end


to setup-individual1s
  create-individual1s ini_pop
  ask individual1s [set id who]
  ask individual1s [ setxy random-xcor random-ycor ]
  ask individual1s [set shape "square"]
  ask individual1s [set color green]
  ask individual1s [set energy max_energy]
  ask individual1s [set preg (random 364 + 1)]
  ask individual1s [set give 1]
  ask individual1s [set rece 1]
  random-seed 137
  foreach sort individual1s[
    ifelse Random_efficiency? 
  [ask individual1s [set effi ((random-float 0.5) + 0.5)]]
  [ask individual1s [set effi 0.7]]
  ]
end
to setup-individual2s
  create-individual2s ini_pop
  ask individual2s [set id who]
  ask individual2s [ setxy random-xcor random-ycor ]
  ask individual2s [set shape "square"]
  ask individual2s [set color red]
  ask individual2s [set energy max_energy]
  ask individual2s [set preg (random 364 + 1)]
  ask individual2s [set give 1]
  ask individual2s [set rece 1]
  random-seed 137
  foreach sort individual2s[
    ifelse Random_efficiency? 
    [ ask individual2s [set effi ((random-float 0.5) + 0.5)] ] 
    [ ask individual2s [set effi 0.7] ]
  ]  
end



to do-individual1s
  ask individual1s 
  [ifelse random-float 1 < (s1 * effi)
    [set energy max_energy]
    [set energy energy - 1]
    ]
end

to do-individual2s
  ask individual2s 
  [ifelse random-float 1 < (s2 * effi)
    [set energy max_energy]
    [set energy energy - 1]
    ]
end

to divide
  ask individual1s[
    set hat remainder ticks preg
    if hat = 0 [hatch 1 [
        setxy random-xcor random-ycor
        set preg (random 364 + 1)
        ]]
    ]
  ask individual2s[
    set hat remainder ticks preg
    if hat = 0 [hatch 1 [
        setxy random-xcor random-ycor
        set preg (random 364 + 1)
        ]]
    ]
end
to death
  ask individual1s[
    if energy < 1 [die]
  ]
  ask individual2s[
    if energy < 1 [die]    
  ]
end

to do-totenergy
  set totenergy1 sum [energy] of individual1s
  set totenergy2 sum [energy] of individual2s
  set totenergy totenergy1 + totenergy2
  if ticks > disc_time [ 
  set cum_pop_size1 (cum_pop_size1 + (count individual1s))
  set avg_pop_size1 cum_pop_size1 / (ticks - disc_time)
  set cum_pop_size2 (cum_pop_size2 + (count individual2s))
  set avg_pop_size2 cum_pop_size2 / (ticks - disc_time)
  set ratio_pop_size avg_pop_size2 / avg_pop_size1
  ]
end


to do-sharing
  
set e1 count individual2s with [energy = max_energy]
set e2 count individual2s with [energy = 1]
set ee min (list e1 e2)
ask n-of ee individual2s with [energy = 1] [set energy energy + 1]
ask n-of ee individual2s with [energy = max_energy] [set energy energy - 1]
end

to do-init
  if ticks = 1 
  [
  set in-eff1 max [effi] of individual1s
  set in-eff2 max [effi] of individual2s
  set in-min1 min [effi] of individual1s
  set in-min2 min [effi] of individual2s
  ]
end

to do-final
  if ticks = 5000 
  [
  set sel-eff1 max [effi] of individual1s
  set sel-eff2 max [effi] of individual2s
  ]
end
