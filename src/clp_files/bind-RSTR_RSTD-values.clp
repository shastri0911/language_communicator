;generates output file "mrs_info_with_rstr_rstd_values.dat" and contains information of all the restrictor restricted and MRS relation features values
(defglobal ?*rstr-rstd* = open-rstr)
(defglobal ?*rstr-rstd-dbg* = debug_rstr)

;This rule deletes a fact that belongs to a set id but the fact should not have the max ID and its MRS concept value should not end with "_q". For example, out of the following 3 facts for the phrase 'a new book' in the sentence: "The boy is reading a new book." "f-2' would be deleted.
  ;f-1    (initial_MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 21000 _a_q h8 x9 h10 h11)
  ;f-2    (initial_MRS_info id-MRS_concept-LBL-ARG0-ARG1 22000 _new_a_1 h16 x17 x18)
  ;f-3    (initial_MRS_info id-MRS_concept-LBL-ARG0-ARG1 23000 _book_n_of h5 x6 x7)
;Deleting the facts prevents from generating unwanted "Restr-Restricted * *" relations by the "initial-mrs-info" rule.
(defrule rm-mrs-info
(declare (salience 10000))
?f1<-(MRS_info ?rel1 ?id1 ?noendsq  ?lbl1 ?arg  $?arg1)
?f2<-(MRS_info ?rel2 ?id2 ?noendsq1 ?lbl2 ?arg0 $?arg11)
(test (eq (sub-string 1 1 (implode$ (create$ ?id1))) (sub-string 1 1 (implode$ (create$ ?id2)))))
(test (neq (sub-string (- (str-length ?noendsq1)    1) (str-length ?noendsq1) ?noendsq1) "_q"))
(test (neq (sub-string (- (str-length ?noendsq)    1) (str-length ?noendsq) ?noendsq) "_q"))
(test (< ?id2 ?id1))
=>
(retract ?f1)
(printout ?*rstr-rstd*   "(MRS_info  "?rel1 " " ?id1 " " ?noendsq " " ?lbl1 " " ?arg " " (implode$ (create$ $?arg1)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  rm-mrs-info  "?rel1 " " ?id1 " " ?noendsq " " ?lbl1 " " ?arg " " (implode$ (create$ $?arg1)) ")"crlf)
)

;If id of two facts are identical or they are of the same set and id of one fact has value *_q for MRS_concept,
;	then Generate (Restr-Restricted RSTR_of_*_q LBL_the_other_fact)
;	     Replace ARG0 value of *_q with ARG0 value of the other fact 	
;INPUT sentence: He will help a blind man.
;INPUT facts:
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20010 _a_q h7 x8 h9 h10)
;OUTPUT: 
;(MRS_info id-MRS_concept-LBL-ARG0-RSTR-BODY 20010 _a_q h7 x12 h9 h10)
(defrule mrs-info_q
?f<-(MRS_info ?rel1 ?id1 ?endsWith_q ?lbl1 ?x ?rstr $?vars)
(MRS_info ?rel2 ?id2 ?mrsCon ?lbl2 ?ARG_0 $?v)
(test (neq ?endsWith_q ?mrsCon))
;(test (neq ?endsWith_q def_implicit_q))
(test (eq (sub-string 1 1 (implode$ (create$ ?id1))) (sub-string 1 1 (implode$ (create$ ?id2)))))
(test (eq (sub-string (- (str-length ?endsWith_q) 1) (str-length ?endsWith_q) ?endsWith_q) "_q"))
(test (neq (sub-string (- (str-length ?mrsCon) 1) (str-length ?mrsCon) ?mrsCon) "_p"))
=>
(retract ?f)
(printout ?*rstr-rstd* "(Restr-Restricted     "?rstr  "  " ?lbl2 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values mrs-info_q  Restr-Restricted  "?rstr"  "?lbl2 ")"crlf)

(printout ?*rstr-rstd*   "(MRS_info  "?rel1 " " ?id1 " " ?endsWith_q " " ?lbl1 " " ?ARG_0 " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  mrs-info_q "?rel1 " " ?id1 " " ?endsWith_q " " ?lbl1 " "?ARG_0 " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
)

;want to bind LBL of '_home_p' with RSTR of 'def_implicit_q
(defrule defimplicitq
?f<-(MRS_info ?rel1 ?id def_implicit_q ?lbl1 ?x ?rstr $?vars)
(MRS_info ?rel2 ?id _home_p ?lbl2 ?ARG_0 $?v)
=>
(retract ?f)
(printout ?*rstr-rstd* "(Restr-Restricted     "?rstr  "  " ?lbl2 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values defimplicitq  Restr-Restricted  "?rstr"  "?lbl2 ")"crlf)

(printout ?*rstr-rstd*   "(MRS_info  "?rel1 " " ?id " def_implicit_q " ?lbl1 " " ?x " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values defimlicitq "?rel1 " " ?id " def_implicit_q  " ?lbl1 " "?x " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
)

;want to bind LBL of '_yesterday_a_1|_today_a_1|_tomorrow_a_1' with RSTR of 'def_implicit_q
(defrule dummy
?f<-(MRS_info ?rel1 ?id def_implicit_q ?lbl1 ?x ?rstr $?vars)
(MRS_info ?rel2 ?id _yesterday_a_1|_today_a_1|_tomorrow_a_1 ?lbl2 ?ARG_0 $?v)
=>
(retract ?f)
(printout ?*rstr-rstd* "(Restr-Restricted     "?rstr  "  " ?lbl2 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values defimplicitq  Restr-Restricted  "?rstr"  "?lbl2 ")"crlf)

(printout ?*rstr-rstd*   "(MRS_info  "?rel1 " " ?id " def_implicit_q " ?lbl1 " " ?x " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  mrs-info_q "?rel1 " " ?id " def_implicit_q  " ?lbl1 " "?x " " ?rstr " " (implode$ (create$ $?vars)) ")"crlf)
)

;Restrictor for LTOP Restrictor-Restricted when neg is present
(defrule LTOP-neg-rstd
(MRS_info ?rel	?id ?mrsCon ?lbl $?vars)
(test (neq (str-index neg ?mrsCon) FALSE))
=>
(printout ?*rstr-rstd* "(Restr-Restricted  h0 "?lbl ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  LTOP-neg-rstd  Restr-Restricted  h0 "?lbl ")"crlf)
)

; written by sakshi yadav (NIT Raipur) date- 02.06.19
;want to bind RSTR of def_explicit_q  with LBL of poss
(defrule defexpq
(rel_name-ids viSeRya-r6	?id  ?id1)
(MRS_info ?rel1 ?id poss ?lbl2 ?ARG_0 ?ARG1 ?ARG2)
?f<-(MRS_info ?rel2 ?id def_explicit_q ?lbl1 ?x ?rstr $?v)
=>
(retract ?f)
(printout ?*rstr-rstd* "(Restr-Restricted     "?rstr  "  " ?lbl2 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values defexpq Restr-Restricted  "?rstr"  "?lbl2 ")"crlf)

(printout ?*rstr-rstd*   "(MRS_info " ?rel2 " " ?id  " def_explicit_q " ?lbl1 " " ?x " " ?rstr " " (implode$ (create$ $?v)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  defexpq " ?rel2 " " ?id " def_explicit_q  " ?lbl1 " "?x " " ?rstr " " (implode$ (create$ $?v)) ")"crlf)
)


;;Restrictor for LTOP Restrictor-Restricted default value
(defrule LTOP-rstd
(MRS_info ?rel	?id ?mrsCon ?lbl $?vars)
(not (MRS_info ?rel1 ?id1 neg ?lbl1 $?v))
=>
(if (or (neq (str-index possible_ ?mrsCon) FALSE) (neq (str-index sudden_ ?mrsCon) FALSE) )
then
  (printout ?*rstr-rstd* "(Restr-Restricted  h0 "?lbl ")" crlf)
  (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-rstd Restr-Restricted  h0 "?lbl ")"crlf)

else
        (if (neq (str-index _v_ ?mrsCon) FALSE)
then
        (printout ?*rstr-rstd* "(Restr-Restricted  h0  "?lbl ")" crlf)) 
        (printout ?*rstr-rstd-dbg* "(rule-rel-values LTOP-rstd  Restr-Restricted  h0 "?lbl ")"crlf)
)     
)


(defrule print-sf_etc
(declare (salience -1000))
?f1<- (id-SF-TENSE-MOOD-PROG-PERF ?rel1 $?vars) 
=>
;(retract ?f1)
(printout ?*rstr-rstd*   "(id-SF-TENSE-MOOD-PROG-PERF  "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  print-sf_etc id-SF-TENSE-MOOD-PROG-PERF  "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
)

(defrule print-mrs
(declare (salience -1000))
?f1<-(MRS_info ?rel1  $?vars)
=>
;(retract ?f1)
(printout ?*rstr-rstd*   "(MRS_info  "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  print-mrs  "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
)


(defrule print-ltop
(declare (salience -1000))
?f1<- (LTOP-INDEX ?rel1  $?vars) 
=>
;(retract ?f1)
(printout ?*rstr-rstd*   "(LTOP-INDEX  "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values  print-ltop LTOP-INDEX  "?rel1 " " (implode$ (create$ $?vars)) ")"crlf)
)
