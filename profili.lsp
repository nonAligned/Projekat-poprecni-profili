; -------------------------------
; Dialog Functions
; -------------------------------

(defun LoadDialog(dialogName / dclId)
  (if (not (setq dclId (load_dialog (findfile "profili.dcl"))))
    (progn
      (alert "DCL fajl nije pronadjen.")
      (exit)
    )
    (progn
      (if (not (new_dialog dialogName dclId))
        (progn
          (alert "U ucitanom fajlu nema trazene definicije")
          (exit)
        )
        (progn
          (cond
            ((equal dialogName "newcstype2")
              (action_tile "accept" "(TestDialog)")
            )
          )
          
	        (start_dialog)
          
	        (unload_dialog dclId)
        )
      )
    )
  )
  
  (defun TestDialog( / isDialogValid)
    (setq isDialogValid 1)
    
    (cond
      ((equal dialogName "newcstype2")
        (ValidateDialogNCST2)
      )
    ) 
    (if isDialogValid
      (done_dialog 1)
    )
  )
  
  (defun ValidateDialogNCST2()
    (if (equal (get_tile "street-name") "")
      (progn
        (set_tile "error" "Ime ulice je obavezno")
        (mode_tile "street-name" 2)
        (setq isDialogValid nil)
      )
    )
    (if (equal (get_tile "street-orientation") "")
      (progn
        (set_tile "error" "Orijentacija je obavezna")
        (mode_tile "street-orientation" 2)
        (setq isDialogValid nil)
      )
    )
    (if (equal (get_tile "axis-distance-left") "")
      (progn
        (set_tile "error" "Rastojanje je obavezno")
        (mode_tile "axis-distance-left" 2)
        (setq isDialogValid nil)
      )
    ) 
    (if (not (distof (get_tile "axis-distance-left")))
      (progn
        (set_tile "error" "Rastojanje mora biti broj")
        (mode_tile "axis-distance-left" 2)
        (setq isDialogValid nil)
      )
    )
    (if (equal (get_tile "axis-distance-right") "")
      (progn
        (set_tile "error" "Rastojanje je obavezno")
        (mode_tile "axis-distance-right" 2)
        (setq isDialogValid nil)
      )
    )
    (if (not (distof (get_tile "axis-distance-right")))
      (progn
        (set_tile "error" "Rastojanje mora biti broj")
        (mode_tile "axis-distance-right" 2)
        (setq isDialogValid nil)
      )
    )
  )
)

; -------------------------------
; Utility Functions
; -------------------------------


; -------------------------------
; Cross Section Type 2 Functions
; -------------------------------

(defun NewCsType2(/ streetName streetOrientation axisDistanceLeft axisDistanceRight axisPoint1 axisPoint2 scale)
  (loadDialog "newcstype2")
  
  
)

; -------------------------------
; Main Entry Point
; -------------------------------

(defun c:NewCrossSection ( / csType)
  (vl-load-com)
  
  (LoadDialog "newcrosssection")
	
  (cond 
    ((equal csType "cs-type-1") 
      (alert "Tipski profil nije implementiran")
    )
    ((equal csType "cs-type-2") 
      (NewCsType2)
    )
    (T 
      (alert "Prekid komande")
    )
  )
  
  (princ) ; Suppress return of extraneous results
)