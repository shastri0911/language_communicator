;generates output file "info_neg_rstr-rstd.dat" which has info of restrictor-restricted for negation.

(defglobal ?*rstr-rstd* = open-rstr)
(defglobal ?*rstr-rstd-dbg* = debug_rstr)

;Restrictor-Restricted for neg: in (MRS_info ?rel1 ?id1 ?mrsCon ?lbl ?ARG0 ?ARG1) check ?mrsCon is equal to neg and ARG1 value of kriyA should be equal to ARG0 value of karwA 
(defrule neg-rstd
?f<-(MRS_info ?rel1 ?id1 ?mrsCon ?lbl ?ARG0_1 ?ARG1)
(MRS_info ?rel3 ?id3 ?mrsCon3 ?lbl1 ?ARG0_3 $?vars)
(MRS_info ?rel2 ?id2 ?mrsCon2 ?lbl2 ?ARG0_2 ?ARG0_3 $?v)
(LTOP-INDEX h0 ?index)
(test (neq (str-index neg ?mrsCon) FALSE))
(test (neq (str-index ?index ?ARG0_2) FALSE))
=>
(retract ?f) ;#rAma ne pATa nahIM paDA.
(printout ?*rstr-rstd* "(Restr-Restricted     "?ARG1  "  " ?lbl2 ")"crlf)
(printout ?*rstr-rstd-dbg* "(rule-rel-values   neg-rstd  Restr-Restricted  "?ARG1"  "?lbl2")"crlf)
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

