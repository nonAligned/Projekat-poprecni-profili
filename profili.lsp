; -------------------------------
; Dialog Functions
; -------------------------------

(defun LoadDialog(dialogName / dclId)
  (setq dclId (load_dialog "profili.dcl"))
  (new_dialog dialogName dclId)
  
	(start_dialog)
	
	(unload_dialog dclId)
)

; -------------------------------
; Main Entry Point
; -------------------------------

(defun c:NewCrossSection ( / csType )
  (vl-load-com)
  
  (LoadDialog "newcrosssection")
	
  (cond 
    ((equal csType "cs-type-1") 
     (alert "Tipski profil nije implementiran")
    )
    ((equal csType "cs-type-2") 
      (print "KPP")
    )
    (T 
     (alert "Prekid komande")
    )
  )
  
  (princ) ; Suppress return of extraneous results
)