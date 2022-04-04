;generates output file "info_neg_rstr-rstd.dat" which has info of restrictor-restricted for negation.

(defglobal ?*rstr-rstd* = open-rstr)
(defglobal ?*rstr-rstd-dbg* = debug_rstr)


;Restrictor-Restricted for neg: in (MRS_info ?rel1 ?id1 neg ?lbl ?ARG0 ?ARG1),  ARG1 value of kriyA should be equal to ARG0 value of karwA 
(defrule neg-rstd
?f<-(MRS_info ?rel1 ?id1 neg ?lbl ?ARG0  ?ARG1)
(MRS_info ?rel2 ?k1  ?mrsCon2 ?k1_lbl ?V_A1  $?v)
(MRS_info ?rel3 ?kri ?mrsConVerb ?V_lbl  ?V_A0  ?V_A1 $?vars)
(LTOP-INDEX h0 ?V_A0)
;(LTOP-INDEX h0 ?index)
;(test (neq (str-index ?index ?V_A0) FALSE))
=>
(retract ?f) ;#rAma ne pATa nahIM paDA.
(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1  "  " ?V_lbl ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-rstd Restr-Restricted  "?ARG1"  "?V_lbl")"crlf)
)

; Ex. mEM so nahIM sakawA hUz.
; Ex. I can not sleep. I cannot sleep. I can't sleep.
(defrule neg-modal
?f<-(MRS_info ?rel1 ?id1 ?modal ?lbl ?ARG0  ?ARG1)
?f1<-(MRS_info ?rel2 ?id2 neg ?lbl2 ?ARG0_2 ?ARG1_2 $?vars)
?f2<-(MRS_info ?rel3 ?id3 ?v ?lbl3 ?ARG0_3 ?ARG1_3 $?var)
(test (neq (str-index _v_modal ?modal) FALSE))
(test (neq (str-index _v_ ?v) FALSE))
(test (neq ?id1 ?id3))
(test (neq ?id2 ?id3))
=>
(retract ?f ?f1) 
(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1 " " ?lbl3 ")" crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-modal  Restr-Restricted  "?ARG1" "?lbl3")"crlf)

(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1_2" "?lbl")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values neg-modal  Restr-Restricted  "?ARG1_2" "?lbl")"crlf)
)

