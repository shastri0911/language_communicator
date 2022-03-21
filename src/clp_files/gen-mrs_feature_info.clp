;generates output file "initial-mrs_info.dat" which contains id,MRS concept and their respective relation features.


(defglobal ?*mrs-fp* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-dbug)
(defglobal ?*count* = 1)

;(rel_name-ids viSeRya-viSeRaNa	20000	21000)
;(id-concept_label	21000	WodZA_3)
;(id-hin_concept-MRS_concept 21000 WodZA_3 _some_q) 
;(MRS_info id-MRS_concept 20010 _a_q)
;Rules to delete _a_q etc for concepts that already have some quantifiers like _some_q, _all_q, _every_q etc as viSeRana
;prawyeka baccA Kela rahe hEM. hara baccA Kela rahe hEM. saBI bacce Kela rahe hEM. prawyeka pedZa lambA hE.	
;Each kid is playing.          Every kid is playing.     All kids are playing.     Each tree is tall.
(defrule rm-qcon4quantifier
(declare (salience 10000))
(rel_name-ids mod	?vi 	?vina)
(id-hin_concept-MRS_concept ?vina ?qntfr ?vinaq) 
?f<-(MRS_info id-MRS_concept ?q_id  ?aq)
(test (eq (+ 10 ?vi) ?q_id))
(test (neq (str-index _q ?vinaq) FALSE))
(test (neq (str-index _q ?aq) FALSE))
=>
(retract ?f)
(printout ?*mrs-dbug* "(rule-rel-values   rm-qcon4quantifier  id-MRS_concept "?q_id" "?aq")"crlf)
)

;This rule changes the ARG1 value like x* of the passive verbs when k1 is present for the verb to i*
;Ex. (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 30000 _kill_v_1 h19 e20 x21 x22)
;changes to
;    (MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 30000 _kill_v_1 h19 e20 i21 x22)
;Ex. Ravana was killed by Rama.
(defrule passive-v-k1
(declare (salience 200))
?f1<-(sentence_type	pass-affirmative)
?f<-(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 ?kri ?mrscon ?lbl ?arg0 ?arg1 ?arg2)
(not (rel_name-ids kriyA-k1	?kri	?k1))
=>
(retract ?f1 ?f)
(bind ?a1 (str-cat "i" (sub-string 2 (str-length ?arg1) ?arg1)))  
;(assert (MRS_info   ?kri ?arg1  (explode$ ?a1) ))
(printout ?*mrs-fp* "(MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?arg2")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values passive-v-k1 MRS_info id-MRS_concept-LBL-ARG0-ARG1-ARG2 "?kri" "?mrscon" "?lbl" "?arg0" "?a1" "?arg2")"crlf)
)


;Rule for generating initial mrs info for concepts in file "id-concept_label-mrs_concept.dat"
(defrule mrs-info
(id-hin_concept-MRS_concept ?id  ?conLbl  ?mrsCon)
(MRS_concept-label-feature_values ?mrsCon $?vars)
=>
	(bind ?val (length$ (create$ $?vars)))
	(bind ?rel (create$ ))
	(bind ?v (create$ ))
	(loop-for-count (?i 1 ?val)
		(if (eq (oddp ?i) TRUE) then
			(bind ?rel_name (string-to-field (sub-string 1 (- (str-length (nth$ ?i $?vars)) 1) (nth$ ?i $?vars))))
			(bind ?rel (create$ ?rel ?rel_name))
		else
			(bind ?v1 (string-to-field (str-cat (sub-string 1 1 (nth$ ?i $?vars)) ?*count*)))
			(bind ?*count* (+ ?*count* 1))
			(bind ?v (create$ ?v ?v1))
		)
	)
        (bind ?l (length$ $?rel) )
        (bind ?str "")
	(loop-for-count (?i 1 ?l )
        	(bind ?str (str-cat ?str (nth$ ?i $?rel) "-")) 
	)
	(bind ?f (sub-string 1 (- (str-length ?str)1) ?str))
	(bind ?f1 (explode$ (str-cat "id-MRS_concept-"  ?f)))

        (assert (MRS_info  ?f1  ?id ?mrsCon  ?v))
        ;(printout ?*mrs-fp* "(MRS_info "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
        (printout ?*mrs-dbug* "(rule-rel-values mrs-info MRS_info "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
)

;Generate initial MRS info for concepts in "mrs_info.dat"
(defrule mrs-info-other
?f<-(MRS_info id-MRS_concept ?id  ?mrsCon )
(MRS_concept-label-feature_values ?mrsCon $?vars)
=>
(retract ?f )
	(bind ?val (length$ (create$ $?vars)))
	(bind ?rel (create$ ))
	(bind ?v (create$ ))
	(loop-for-count (?i 1 ?val)
		(if (eq (oddp ?i) TRUE) then
			(bind ?rel_name (string-to-field (sub-string 1 (- (str-length (nth$ ?i $?vars)) 1) (nth$ ?i $?vars))))
			(bind ?rel (create$ ?rel ?rel_name))
		else
			(bind ?v1 (string-to-field (str-cat (sub-string 1 1 (nth$ ?i $?vars)) ?*count*)))
			(bind ?*count* (+ ?*count* 1))
			(bind ?v (create$ ?v ?v1))
		)
	)
        (bind ?l (length$ $?rel) )
        (bind ?str "")
	(loop-for-count (?i 1 ?l )
        	(bind ?str (str-cat ?str (nth$ ?i $?rel) "-")) 
	)
	(bind ?f (sub-string 1 (- (str-length ?str)1) ?str))
	(bind ?f1 (explode$ (str-cat "id-MRS_concept-"  ?f)))

        (printout ?*mrs-fp* "(MRS_info "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
        (printout ?*mrs-dbug* "(rule-rel-values mrs-info-other "(implode$ (create$ ?f1))" "?id " "?mrsCon" "(implode$ (create$ ?v))")"crlf)
)

; (rule-rel-values printMRSfacts  MRS_info id-MRS_concept 10001 _of_p)
(defrule printMRSfacts
(declare (salience -9000))
?f<-(MRS_info ?rel  ?id ?mrscon ?lbl $?all)
=>
(retract ?f)
   (printout ?*mrs-fp* "(MRS_info "?rel" "?id" "?mrscon" "?lbl" "(implode$ (create$ $?all))")"crlf)
   (printout ?*mrs-dbug* "(rule-rel-values printMRSfacts  MRS_info "?rel" "?id" "?mrscon" "?lbl" "(implode$ (create$ $?all))")"crlf)
)
