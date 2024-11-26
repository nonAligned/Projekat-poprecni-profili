; -------------------------------
; DIALOG FUNCTIONS
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
; UTILITY FUNCTIONS
; -------------------------------

(defun Cleanup()
  (command "_.ERASE" "ALL" "")
  (command "_.PURGE" "ALL" "*" "N")
)

(defun ZoomAndRegen()
  (command "_.ZOOM" "E")
  (command "_.REGEN")
)

(defun LoadLineType(lTypeName)
  (if (not (tblsearch "LTYPE" lTypeName)) (command "_.LINETYPE" "LOAD" lTypeName "" ""))
)

(defun MakeLayer(layerName layerColor layerLineType)
  (if (not (tblsearch "LAYER" layerName)) (command "_.LAYER" "MAKE" layerName "COLOR" layerColor "" "LTYPE" layerLineType "" ""))
)

(defun InsertBlock(blockName layerName iX iY blockScale blockRotation)
  (command "._LAYER" "SET" layerName "")
  (if (not (tblsearch "BLOCK" blockName))
    (progn
      (command 
        "-INSERTCONTENT"
        (findfile blockDefinitionFile)
        blockName
        (strcat (rtos iX 2) "," (rtos iY 2))
        blockScale blockScale blockRotation
      )
    )
    (command
      "._INSERT"
      blockName
      (strcat (rtos iX 2) "," (rtos iY 2))
      blockScale blockScale blockRotation
    )
  )
)

(defun DrawRectangle(firstPoint secondPoint lineWidth layer)
  (command "._LAYER" "SET" layer "")
  (command "._RECTANG" 
    "WIDTH" (rtos lineWidth 2)
    firstPoint
    secondPoint
  )
)

(defun SetDimScale(dimStyleName newScale)
  (command "._DIMSTYLE" "RESTORE" dimStyleName)
  (setvar 'DIMSCALE newScale)
  (command "_DIMSTYLE" "SAVE" dimStyleName "YES")
)

(defun WriteDText(style justify insertPoint height rotation content layer)
  (command "._LAYER" "SET" layer "")
  (command "._TEXT"
    "STYLE" style
    "JUSTIFY" justify
    insertPoint height rotation
    content
  )
)

(defun WriteMText(style justify firstPoint secondPoint height content layer)
  (command "._LAYER" "SET" layer "")
  (command 
    "_.MTEXT"
    firstPoint
    "_Justify" justify 
    "_Style" style
    "_Height" height 
    secondPoint
    content
    ""
  )
)

(defun SplitStr ( s d / p )
  (if (setq p (vl-string-search d s))
    (cons (substr s 1 p) (SplitStr (substr s (+ p 1 (strlen d))) d))
    (list s)
  )
)

; -------------------------------
; CROSS SECTION FUNCTIONS
; -------------------------------

; -------------------------------
; Helper Functions
; -------------------------------

(defun ImportDimStyles()
  (if (not (tblsearch "DIMSTYLE" "Poprecni profil"))
    (progn
      (InsertBlock "Kote" "0" 0 0 "1" "0")
      (entdel (entlast))
    )
  )
)

(defun ImportInitialStyles()
  (LoadLineType "DASHED2")
  (LoadLineType "ACAD_ISO02W100")
  (LoadLineType "ACAD_ISO04W100")
  
  (MakeLayer "00-Okvir" "7" "Continuous")
  (MakeLayer "01-Tekst" "7" "Continuous")
  (MakeLayer "02-Legenda" "7" "Continuous")
  (MakeLayer "03-Tlo" "7" "Continuous")
  (MakeLayer "04-Regulacija" "7" "ACAD_ISO02W100")
  (MakeLayer "05-Osovina" "6" "ACAD_ISO04W100")
  
  (MakeLayer "10-Kolovoz" "7" "Continuous")
  (MakeLayer "11-Trotoar" "7" "Continuous")
  (MakeLayer "12-Biciklisticka staza" "7" "Continuous")
  (MakeLayer "13-Parking" "7" "Continuous")
  (MakeLayer "14-Zelena povrsina" "72" "Continuous")
  
  (MakeLayer "20-Instalacije" "143" "Continuous")
  (MakeLayer "21-Rasveta" "7" "Continuous")
  (MakeLayer "22-Drvored" "7" "Continuous")
  
  (MakeLayer "30-Kote saobracaj" "7" "Continuous")
  (MakeLayer "31-Kote instalacije" "7" "Continuous")
  (MakeLayer "32-Pomocna linija" "7" "DASHED2")

  (ImportDimStyles)
  (SetDimScale "Poprecni profil priblizno" scale)
  (SetDimScale "Poprecni profil" scale)
)

(defun DrawFrame ( / outerFirst outerSecond innerFirst innerSecond)
  (setq outerFirst "0,0")
  (setq outerSecond (strcat (rtos (* 29.7 scale) 2) "," (rtos (* 21.0 scale) 2)))
  (setq innerFirst (strcat (rtos (* 0.5 scale) 2) "," (rtos (* 0.5 scale) 2)))
  (setq innerSecond (strcat (rtos (* 29.2 scale) 2) "," (rtos (* 18.5 scale) 2)))
  
  (DrawRectangle outerFirst outerSecond 0 "00-Okvir")
  (DrawRectangle innerFirst innerSecond (* 0.05 scale) "00-Okvir")

  (ZoomAndRegen)
)

(defun WriteText ( / bottomLeft topLeft titleFirst titleSecond subtitleFirst subtitleSecond axisPointFirst axisPointSecond)
  (setq bottomLeft (strcat (rtos (* 0.75 scale) 2) "," (rtos (* 0.75 scale) 2)))
  (setq topLeft (strcat (rtos (* 0.75 scale) 2) "," (rtos (* 18.25 scale) 2)))
  (setq titleFirst (strcat (rtos (* 21.00 scale) 2) "," (rtos (* 18.0 scale) 2)))
  (setq titleSecond (strcat (rtos (* 28.7 scale) 2) "," (rtos (* 16.0 scale) 2)))
  (setq subtitleFirst (strcat (rtos (* 21.0 scale) 2) "," (rtos (* 15.75 scale) 2)))
  (setq subtitleSecond (strcat (rtos (* 28.7 scale) 2) "," (rtos (* 13.75 scale) 2)))
  (setq axisPointFirst (strcat (rtos (* 21.0 scale) 2) "," (rtos (* 13.75 scale) 2)))
  (setq axisPointSecond (strcat (rtos (* 28.7 scale) 2) "," (rtos (* 12.25 scale) 2)))
  
  (WriteDText "Poprecni profil" "BL" bottomLeft (* 0.25 scale) 0 (GenerateId) "01-Tekst")
  (WriteDText "Poprecni profil" "TL" topLeft (* 0.25 scale) 0 "ЈП \"Урбанизам\" Завод за урбанизам, 21 000 Нови Сад, Бул. цара Лазара бр.3/III" "01-Tekst")
  (WriteMText "Poprecni profil" "TC" titleFirst titleSecond (* 0.5 scale) "КАРАКТЕРИСТИЧНИ ПОПРЕЧНИ ПРОФИЛ" "01-Tekst")
  (WriteMText "Poprecni profil" "TC" subtitleFirst subtitleSecond (* 0.35 scale) (strcat "Улица " streetName " " (rtos width 2 1) " m") "01-Tekst")
  (WriteMText "Poprecni profil" "MC" axisPointFirst axisPointSecond (* 0.25 scale) (strcat "од ОТ " axisPoint1 " до ОТ " axisPoint2) "01-Tekst")
)

(defun GenerateId( / cdate)
  (setq cdate (SplitStr (rtos (getvar "CDATE") 2) "."))
  (strcat (strcase (substr (getvar "USERNAME") 1 2)) "-" (substr (car cdate) 3) (cadr cdate) "-" (substr (rtos (getvar "MILLISECS") 2 0) 2 4))
)

; -------------------------------
; Cross Section Type 2 Entry Point
; -------------------------------

(defun NewCsType2(/ streetName streetOrientation axisDistanceLeft axisDistanceRight axisPoint1 axisPoint2 scale width)
  (LoadDialog "newcstype2")
  
  (setq width (+ (atof axisDistanceLeft) (atof axisDistanceRight)))
  
  (cond
    ((<= width 18.0) (setq scale 1.0))
    ((<= width 36.0) (setq scale 2.0))
    ((<= width 54.0) (setq scale 3.0))
    (t (progn (alert "Trenutno nije moguće iscrtavanje ulice šire od 54 metra.") (exit)))
  )
  
  (ImportInitialStyles)
  (DrawFrame)
  (WriteText)
)

; -------------------------------
; MAIN ENTRY POINT
; -------------------------------

(defun c:NewCrossSection ( / csType blockDefinitionFile)
  (vl-load-com)
  
  (Cleanup)
  
  (setq blockDefinitionFile "Blokovi.dwg")
  
  (if (not (findfile blockDefinitionFile))
    (progn
      (alert "Fajl sa blokovima nije pronadjen.")
      (exit)
    )
  )
  
  (setq OSNAPSETTINGS (getvar 'OSMODE))
  (setvar 'OSMODE 0)
  
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