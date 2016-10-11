(defglobal ?*nod-gen* = 0)
;;(defglobal ?*f*)

(deffacts bulb-robot
	(grid 5 4)
	(warehouse 2 3)
	(max-bulb 3)
	(robot 1 3 0 lamp 3 4 3 lamp 4 2 2 lamp 5 4 2 level 0)
	)
	
(defrule left
  ?f<-(robot ?x $?y level ?level)
	  (max-depth ?prof)
	  (test  (> ?x 1))
	   (test (> ?prof ?level))
    =>
  (assert (robot (- ?x 1) $?y level (+ ?level 1) ))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))	
  
  )

(defrule right
	;;(declare (salience (- 0 ?*f*)))
  ?f<-(robot ?x $?y level ?level)
	  (grid ?xg ?)
	  (max-depth ?prof)
	  (test  (< ?x ?xg))
	  (test (> ?prof ?level))
	  ;;(test (control (create$ $?x 0 ?y $?z) ?level))
    =>
  (assert (robot (+ ?x 1) $?y level (+ ?level 1) ))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))	  
  
  )
  
(defrule up
  ?f<-(robot ?x ?y $?z level ?level)
	  (grid ?xg ?yg)
	  (max-depth ?prof)
	  (test  (< ?y ?yg))
	  (test (> ?prof ?level))

    =>
  (assert (robot ?x (+ ?y 1) $?z level (+ ?level 1) ))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))	
)  
  
(defrule down
  ?f<-(robot ?x ?y $?z level ?level)
	  (max-depth ?prof)
	  (test  (> ?y 1))
	  (test (> ?prof ?level))

    =>
  (assert (robot ?x (- ?y 1) $?z level (+ ?level 1) ))
  (bind ?*nod-gen* (+ ?*nod-gen* 1))	 
)

(defrule load
  ?f<-(robot ?x ?y ?z $?rest level ?level)
      (max-depth ?prof)
	  (warehouse ?x ?y)
	  (max-bulb ?mb)
	  ;;(test AND (= ?x $wx) (= $y $wy))
	  (test (< ?z ?mb))
	  (test (> ?prof ?level))

	=>
   (assert (robot ?x ?y ?mb $?rest level (+ ?level 1)))
   (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule replace
  ?f<-(robot ?x ?y ?z $?antes lamp ?x ?y ?zl $?despues level ?level)
	  (max-depth ?prof)
      (test (>= ?z ?zl))
	  (test (> ?prof ?level))

	=>
	  (assert (robot ?x ?y (- ?z ?zl) $?antes $?despues level (+ ?level 1)))
	  (bind ?*nod-gen* (+ ?*nod-gen* 1))
)  

(defrule goal
  (declare (salience 100))
  ?f<-(robot ?x ?y ?z level ?level)
  =>
    (printout t "SOLUTION FOUND AT LEVEL " ?level crlf)
	(printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES " ?*nod-gen* crlf)
    (printout t "GOAL FACT " ?f crlf)
	(halt)
  
)

;;(deffunction control (?state ?level)
  ;;  (bind ?*f* (misplaced ?state))
    ;;(bind ?*f* (+ ?*f* ?level 1))
	
	
;;(deffunction misplaced (?state)
	;;(bind ?misp 0)
	;;(if (<> (nth$ 1 ?state)  1) then  (bind ?misp (+ ?misp 1)))
	;;(if (<> (nth$ 2 ?state)  2) then  (bind ?misp (+ ?misp 1)))
	;;(if (<> (nth$ 3 ?state)  3) then  (bind ?misp (+ ?misp 1)))
	;;(if (<> (nth$ 4 ?state)  8) then  (bind ?misp (+ ?misp 1)))
	;; (if (<> (nth$ 5 ?state)  0) then  (bind ?misp (+ ?misp 1)));;
	;;(if (<> (nth$ 6 ?state)  4) then  (bind ?misp (+ ?misp 1)))
	;;(if (<> (nth$ 7 ?state)  7) then  (bind ?misp (+ ?misp 1)))
	;;(if (<> (nth$ 8 ?state)  6) then  (bind ?misp (+ ?misp 1)))
	;;(if (<> (nth$ 9 ?state)  5) then  (bind ?misp (+ ?misp 1)))
       ;;?misp)
	   
(deffunction start ()
        (reset)
	;;(set-salience-evaluation when-activated))
	(printout t "Maximum depth:= " )
	(bind ?prof (read))
	(printout t "Search strategy " crlf "    1.- Breadth" crlf "    2.- Depth" crlf )
	(bind ?a (read))
	(if (= ?a 1)
	       then    (set-strategy breadth)
	       else   (set-strategy depth))
        (printout t " Execute run to start the program " crlf)
			(assert (max-depth ?prof))
)