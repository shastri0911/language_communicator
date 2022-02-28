(defglobal ?*mrsdef* = samasa-fp)
(defglobal ?*defdbug* = samasa-dbug-fp)

;Rules for generating implicit compound nodes 
;Ex. 307:   usane basa+addA xeKA.
(defrule samasa
(id-concept_label	?compid	?comp)
(rel_name-ids ?rel	?compid ?dep)
(id-hin_concept-MRS_concept ?compid ?comp ?comp_mrs)
(test (eq (sub-string 1 1 (str-cat ?compid)) (sub-string 1 1 (str-cat ?dep))))
(test (neq (str-index "+"  ?comp) FALSE))

=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?compid 2) " compound)"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept " (+ ?compid 2)" compound)"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "(+ ?dep 10) " udef_q)"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "(+ ?dep 10)" udef_q)"crlf)

(bind ?index (str-index "+" ?comp_mrs))
(bind ?purvapada (sub-string 0 (- ?index 1) ?comp_mrs))
(bind ?uttarapada (sub-string (+ ?index 1) (str-length  ?comp_mrs) ?comp_mrs))

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?dep" "?purvapada")"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "?dep" "?purvapada")"crlf)

(printout ?*mrsdef* "(MRS_info id-MRS_concept "?compid" "?uttarapada")"crlf)
(printout ?*defdbug* "(rule-rel-values samasa id-MRS_concept "?compid" "?uttarapada")"crlf)
)


