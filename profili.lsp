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
            ((equal dialogName "newaxisroad")
              (action_tile "accept" "(TestDialog)")
            )
            ((equal dialogName "newedgesidewalks")
              (action_tile "accept" "(TestDialog)")
            )
            ((equal dialogName "newbikepath")
              (set_tile "insert-side" "left-side")
              (action_tile "accept" "(TestDialog)")
              (action_tile "cancel" "(setq bikepathWidth nil)(done_dialog 0)")
            )
            ((equal dialogName "newparking")
              (set_tile "parking-side" "left-parking")
              (action_tile "accept" "(TestDialog)")
              (action_tile "cancel" "(setq parkingWidth nil)(done_dialog 0)")
            )
            ((equal dialogName "newtrafficelement")
              (action_tile "accept" "(setq elementType \"0\")(done_dialog 1)")
              (action_tile "cancel" "(setq elementType \"0\")(done_dialog 0)") 
            )
            ((equal dialogName "newutilityelement")
              (action_tile "accept" "(setq elementType \"0\")(done_dialog 1)")
              (action_tile "cancel" "(setq elementType \"0\")(done_dialog 0)") 
            )
            ((equal dialogName "newundergroundutils")
              (action_tile "accept" "(setq utilityType \"0\")(done_dialog 1)")
              (action_tile "cancel" "(setq utilityType \"0\")(done_dialog 0)") 
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
      ((equal dialogName "newaxisroad")
        (ValidateDialogNAR)
      )
      ((equal dialogName "newedgesidewalks")
        (ValidateDialogNES)
      )
      ((equal dialogName "newbikepath")
        (ValidateDialogNBP)
      )
      ((equal dialogName "newparking")
        (ValidateDialogNP)
      )
    ) 
    (if isDialogValid
      (done_dialog 1)
    )
  )
  
  (defun ValidateDialogNP()
    (if (not (distof (get_tile "parking-width")))
      (progn
        (set_tile "error" "Uneta vrednost nije broj")
        (mode_tile "parking-width" 2)
        (setq isDialogValid nil)
      )
    )   
  )
  
  (defun ValidateDialogNBP()
    (if (not (distof (get_tile "bikepath-width")))
      (progn
        (set_tile "error" "Uneta vrednost nije broj")
        (mode_tile "bikepath-width" 2)
        (setq isDialogValid nil)
      )
    )
  )
  
  (defun ValidateDialogNES()
    (if (not (distof (get_tile "left-sidewalk")))
      (progn
        (set_tile "error" "Uneta vrednost nije broj")
        (mode_tile "left-sidewalk" 2)
        (setq isDialogValid nil)
      )
    )
    (if (not (distof (get_tile "right-sidewalk")))
      (progn
        (set_tile "error" "Uneta vrednost nije broj")
        (mode_tile "right-sidewalk" 2)
        (setq isDialogValid nil)
      )
    )
  )
  
  (defun ValidateDialogNAR()
    (if (not (distof (get_tile "width-left")))
      (progn
        (set_tile "error" "Uneta vrednost nije broj")
        (mode_tile "width-left" 2)
        (setq isDialogValid nil)
      )
    )
    (if (not (distof (get_tile "width-right")))
      (progn
        (set_tile "error" "Uneta vrednost nije broj")
        (mode_tile "width-right" 2)
        (setq isDialogValid nil)
      )
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
  (if (not (tblsearch "LAYER" layerName)) (command "._LAYER" "SET" "0" "")(command "._LAYER" "SET" layerName ""))
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

(defun SetDynPropValue ( blk prp val )
  (setq prp (strcase prp))
  (vl-some
      '(lambda ( x )
          (if (= prp (strcase (vla-get-propertyname x)))
              (progn
                  (vla-put-value x (vlax-make-variant val (vlax-variant-type (vla-get-value x))))
                  (cond (val) (t))
              )
          )
      )
      (vlax-invoke blk 'getdynamicblockproperties)
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

(defun DrawPline(firstPoint secondPoint lineWidth lineScale layer)
  (command "._LAYER" "SET" layer "")
  (command "._CELTSCALE" (rtos lineScale 2))
  (command "._PLINE" 
    firstPoint
    "WIDTH" (strcat (rtos lineWidth 2)) (strcat (rtos lineWidth 2))
    secondPoint
    ""
  )
  (command "._CELTSCALE" "1")
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

(defun SetDimStyleCurrent (dimName / acdoc)
 (setq acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
 (if (tblsearch "DIMSTYLE" dimName)
   (vla-put-activeDimstyle
     acdoc
     (vla-item (vla-get-Dimstyles acdoc) dimName)
   )
 )
)

(defun AddLinDim(dimX1 dimX2 dimY posY dimStyleName layerName)
  (command "._LAYER" "SET" layerName "")
  (SetDimStyleCurrent dimStyleName)
  (setvar "DIMSCALE" scale)

  (command
    "._DIMLINEAR"
    (strcat (rtos dimX1 2) "," (rtos dimY 2))
    (strcat (rtos dimX2 2) "," (rtos dimY 2))
    (strcat (rtos dimX1 2) "," (rtos posY 2))
  )
  
  (command "._LAYER" "SET" "0" "")
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
      (InsertBlock "Kota1" "0" 0 0 "1" "0")
      (entdel (entlast))
    )
  )
  (if (not (tblsearch "DIMSTYLE" "Poprecni profil priblizno"))
    (progn
      (InsertBlock "Kota2" "0" 0 0 "1" "0")
      (entdel (entlast))
    )
  )
  (SetDimStyleCurrent "Poprecni profil")
)

(defun GenerateId( / cdate)
  (setq cdate (SplitStr (rtos (getvar "CDATE") 2) "."))
  (strcat (strcase (substr (getvar "USERNAME") 1 2)) "-" (substr (car cdate) 3) (cadr cdate) "-" (substr (rtos (getvar "MILLISECS") 2 0) 2 4))
)

(defun DrawGround(leftX rightX y / leftEndpoint rightEndpoint)
  (setq leftEndpoint (strcat (rtos leftX 2) "," (rtos y 2)))
  (setq rightEndpoint (strcat (rtos rightX 2) "," (rtos y 2)))
  (DrawPline leftEndpoint rightEndpoint (* 0.05 scale) 1 "03-Tlo")
)

(defun DrawAxis(bottomY topY x / bottomPoint topPoint)
  (setq bottomPoint (strcat (rtos x 2) "," (rtos bottomY 2)))
  (setq topPoint (strcat (rtos x 2) "," (rtos topY 2)))
  (DrawPline bottomPoint topPoint (* 0.015 scale) (* 0.025 scale) "05-Osovina")
)

(defun DrawRegLines(leftX rightX bottomY midY topY / leftLineBottomPoint leftLineTopPoint rightLineBottomPoint rightLineTopPoint)
  (setq leftLineBottomPoint (strcat (rtos leftX 2) "," (rtos bottomY 2)))
  (setq leftLineTopPoint (strcat (rtos leftX 2) "," (rtos topY 2)))
  (setq rightLineBottomPoint (strcat (rtos rightX 2) "," (rtos bottomY 2)))
  (setq rightLineTopPoint (strcat (rtos rightX 2) "," (rtos topY 2)))
  
  (DrawPline leftLineBottomPoint leftLineTopPoint (* 0.03 scale) (* 0.05 scale) "04-Regulacija")
  (DrawPline rightLineBottomPoint rightLineTopPoint (* 0.03 scale) (* 0.05 scale) "04-Regulacija")
  
  (WriteDText "Poprecni profil" "BC" (strcat (rtos (- leftX 0.1) 2) "," (rtos midY 2)) (* 0.2 scale) "90" "РЕГУЛАЦИОНА ЛИНИЈА" "01-Tekst")
  (WriteDText "Poprecni profil" "TC" (strcat (rtos (+ rightX 0.15) 2) "," (rtos midY 2)) (* 0.2 scale) "90" "РЕГУЛАЦИОНА ЛИНИЈА" "01-Tekst")
  
)

(defun InsertOrientation(blockX blockY textX textY / textInsertPoint)
  (setq textInsertPoint (strcat (rtos textX 2) "," (rtos textY 2)))
  (InsertBlock "PP-Orijentacija" "01-Tekst" blockX blockY scale "0")
  (WriteDText "Poprecni profil" "BC" textInsertPoint (* 0.2 scale) "0" (strcase streetOrientation) "01-Tekst")
)

(defun AddInitialDims(left right mid axis maxYPosition spacing)
  (AddLinDim left right mid maxYPosition "Poprecni profil" "30-Kote saobracaj")
  (AddLinDim left axis mid (- maxYPosition spacing) "Poprecni profil" "30-Kote saobracaj")
  (AddLinDim axis right mid (- maxYPosition spacing) "Poprecni profil" "30-Kote saobracaj")
)

(defun AddTrafficDims(x1 x2 posY dimType dimLine)
  (cond
    ((equal dimLine 4)
      (if (or (and (< x1 axisX)(> x2 axisX))(and (< x2 axisX)(> x1 axisX)))
      (progn
        (AddLinDim x1 axisX groundY posY dimType "30-Kote saobracaj")
        (AddLinDim axisX x2 groundY posY dimType "30-Kote saobracaj")
      )
      (AddLinDim x1 x2 groundY posY dimType "30-Kote saobracaj")
      )  
    )
    ((equal dimLine 3)
      (AddLinDim leftX x1 groundY posY "Poprecni profil priblizno" "30-Kote saobracaj")
      (AddLinDim x1 x2 groundY posY "Poprecni profil" "30-Kote saobracaj")
      (AddLinDim x2 rightX groundY posY "Poprecni profil priblizno" "30-Kote saobracaj")
    )
  )
  
)

; -------------------------------
; Green Area Functions
; -------------------------------

(defun AddGreen ( / firstPoint secondPoint insertPoint greenWidth vlaObj)
  (setvar "OSMODE" OSNAPSETTINGS)
  
  (setq firstPoint (car (getpoint "\nPokazite prvu tacku zelenila:")))
  (setq secondPoint (car (getpoint "\nPokazite drugu tacku zelenila:")))
  
  (setvar "OSMODE" 0)
  
  (if (= firstPoint secondPoint)
    (alert "Tacke moraju biti razlicite!")
    (progn
      (if (< firstPoint secondPoint)
        (progn
          (setq greenWidth (- secondPoint firstPoint))
          (setq insertPoint firstPoint)
        )
        (progn
          (setq greenWidth (- firstPoint secondPoint))
          (setq insertPoint secondPoint)
        )
      )
      (InsertBlock "Zelenilo-DYN" "14-Zelena povrsina" insertPoint groundY "1" "0")
      (setq vlaObj (vlax-ename->vla-object (entlast)))

      (SetDynPropValue vlaObj "sirina" greenWidth)
      (SetDynPropValue vlaObj "razmera" (* scale 100))
        
      (vla-update vlaObj)
      
      (vlax-release-object vlaObj)
      
      (SetDimStyleCurrent "Poprecni profil priblizno")
      (AddTrafficDims insertPoint (+ insertPoint greenWidth) (- upperDimsY (* dimSpacing 3.0)) "Poprecni profil priblizno" 4)
    )
  )
)

; -------------------------------
; Parking Functions
; -------------------------------

(defun AddParking( / parkingSide insertPoint parkingWidth vlaObj)
  (setq parkingSide 0)
  (LoadDialog "newparking")
  
  (if (and parkingWidth (not (= parkingWidth "0")))
    (progn
      (setvar "OSMODE" OSNAPSETTINGS)
      (cond
        ((equal parkingSide 0)
          (setq insertPoint (car (getpoint "\nPokazite desnu ivicu parkinga:"))) 
          (setq insertPoint (- insertPoint (atof parkingWidth)))
        )
        ((equal parkingSide 1)
          (setq insertPoint (car (getpoint "\nPokazite levu ivicu parkinga:")))
          (setq insertPoint (+ insertPoint (atof parkingWidth)))
        )
      )
      (setvar "OSMODE" 0)

      (InsertBlock "Parking-DYN" "13-Parking" insertPoint groundY "1" "0")
      (setq vlaObj (vlax-ename->vla-object (entlast)))

      (SetDynPropValue vlaObj "sirina" (atof parkingWidth))
      (SetDynPropValue vlaObj "polozaj" parkingSide)
      (SetDynPropValue vlaObj "razmera" (* scale 100))
        
      (vla-update vlaObj)
      
      (vlax-release-object vlaObj)
      (SetDimStyleCurrent "Poprecni profil")
      (cond
        ((equal parkingSide 0)
          (AddTrafficDims insertPoint (+ insertPoint (atof parkingWidth)) (- upperDimsY (* dimSpacing 3.0)) "Poprecni profil" 4)
        )
        ((equal parkingSide 1)
          (AddTrafficDims insertPoint (- insertPoint (atof parkingWidth)) (- upperDimsY (* dimSpacing 3.0)) "Poprecni profil" 4)
        )
      )
    ) 
    
  )
)

; -------------------------------
; Bikepath Functions
; -------------------------------

(defun AddBikepath( / insertSide insertPoint bikepathWidth vlaObj)
  (setq insertSide "left-side")
  (LoadDialog "newbikepath")
  
  (cond
    ((and bikepathWidth (not (= bikepathWidth "0")))
      (setvar "OSMODE" OSNAPSETTINGS)
      (setq insertPoint (car (getpoint "\nPokazite tacku insertovanja staze:")))
      (setvar "OSMODE" 0)
      (if insertPoint
        (progn
          (cond
            ((equal insertSide "right-side")
              (setq insertPoint (- insertPoint (atof bikepathWidth)))
            )
          )
          (InsertBlock "Biciklisticka-DYN" "12-Biciklisticka staza" insertPoint groundY "1" "0")
          (setq vlaObj (vlax-ename->vla-object (entlast)))
  
          (SetDynPropValue vlaObj "sirina" (atof bikepathWidth))
          (SetDynPropValue vlaObj "razmera" (* scale 100))
            
          (vla-update vlaObj)
          
          (vlax-release-object vlaObj)

          (SetDimStyleCurrent "Poprecni profil")
          (AddTrafficDims insertPoint (+ insertPoint (atof bikepathWidth)) (- upperDimsY (* dimSpacing 3.0)) "Poprecni profil" 4)
        )
      )     
    )
  )
)

; -------------------------------
; Sidewalk Functions
; -------------------------------

(defun AddSingleSidewalk(firstPoint secondPoint / insertPoint sidewalkWidth vlaObj)
  (if (< firstPoint secondPoint)
    (progn
      (setq sidewalkWidth (- secondPoint firstPoint))
      (setq insertPoint firstPoint)
    )
    (progn
      (setq sidewalkWidth (- firstPoint secondPoint))
      (setq insertPoint secondPoint)
    )
  )
  (InsertBlock "Trotoar-DYN" "11-Trotoar" insertPoint groundY "1" "0")
  
  (setq vlaObj (vlax-ename->vla-object (entlast)))
  
  (SetDynPropValue vlaObj "sirina" sidewalkWidth)
  (SetDynPropValue vlaObj "razmera" (* scale 100))
    
  (vla-update vlaObj)
  
  (vlax-release-object vlaObj)
  
  (SetDimStyleCurrent "Poprecni profil")
  (AddTrafficDims insertPoint (+ insertPoint sidewalkWidth) (- upperDimsY (* dimSpacing 3.0)) "Poprecni profil" 4)
)

(defun AddEdgeSidewalks(widthLeft widthRight)
  (if (not (equal widthLeft 0))
    (progn
      (InsertBlock "Trotoar-DYN" "11-Trotoar" leftX groundY "1" "0")
    
      (setq vlaObj (vlax-ename->vla-object (entlast)))
      
      (SetDynPropValue vlaObj "sirina" widthLeft)
      (SetDynPropValue vlaObj "razmera" (* scale 100))
        
      (vla-update vlaObj)
      
      (vlax-release-object vlaObj)
      
      (SetDimStyleCurrent "Poprecni profil")
      (AddTrafficDims leftX (+ leftX widthLeft) (- upperDimsY (* dimSpacing 3.0)) "Popercni profil" 4)
    )
  )
  
  (if (not (equal widthRight 0))
    (progn
      (InsertBlock "Trotoar-DYN" "11-Trotoar" (- rightX widthRight) groundY "1" "0")
    
      (setq vlaObj (vlax-ename->vla-object (entlast)))
      
      (SetDynPropValue vlaObj "sirina" widthRight)
      (SetDynPropValue vlaObj "razmera" (* scale 100))
        
      (vla-update vlaObj)
      
      (vlax-release-object vlaObj)
      
      (SetDimStyleCurrent "Poprecni profil")
      (AddTrafficDims (- rightX widthRight) rightX (- upperDimsY (* dimSpacing 3.0)) "Popercni profil" 4)
    )
  )
)

(defun AddSidewalk( / sidewalkType widthLeft widthRight firstPoint secondPoint)
  (LoadDialog "newsidewalk")
  
  (cond
    ((equal sidewalkType "edge-sidewalks")
      (LoadDialog "newedgesidewalks")
      (if widthLeft
        (setq widthLeft (atof widthLeft))
        (setq widthLeft 0)
      )
      (if widthRight
        (setq widthRight (atof widthRight))
        (setq widthRight 0)
      )
      (AddEdgeSidewalks widthLeft widthRight)
    )
    ((equal sidewalkType "single-sidewalk")
      (setvar "OSMODE" OSNAPSETTINGS)
      (setq firstPoint (car (getpoint "\nPokazite prvu tacku trotoara:")))
      (setq secondPoint (car (getpoint "\nPokazite drugu tacku trotoara:")))
      (setvar "OSMODE" 0)
      (if (= firstPoint secondPoint)
        (alert "Tacke moraju biti razlicite!")
        (AddSingleSidewalk firstPoint secondPoint)
      )
    )
  )
)

; -------------------------------
; Roadway Functions
; -------------------------------

(defun AddSingleRoad(firstPoint secondPoint / roadWidth vlaObj)
  (InsertBlock "Kolovoz-DYN" "10-Kolovoz" firstPoint groundY "1" "0")
  
  (setq vlaObj (vlax-ename->vla-object (entlast)))
  
  (if (< firstPoint secondPoint)
    (progn
      (setq roadWidth (- secondPoint firstPoint))
      (setdynpropvalue vlaObj "sirina levo" 0)
      (setdynpropvalue vlaObj "sirina desno" roadWidth)
    )
    (progn
      (setq roadWidth (- firstPoint secondPoint))
      (setdynpropvalue vlaObj "sirina levo" roadWidth)
      (setdynpropvalue vlaObj "sirina desno" 0)
    )
  )
  (SetDynPropValue vlaObj "razmera" (* scale 100))
    
  (vla-update vlaObj)
  
  (vlax-release-object vlaObj)
  
  (SetDimStyleCurrent "Poprecni profil")
  (AddTrafficDims firstPoint secondPoint (- upperDimsY (* dimSpacing 3.0)) "Popercni profil")
)

(defun AddAxisRoad (widthLeft widthRight / vlaObj)
  (InsertBlock "Kolovoz-DYN" "10-Kolovoz" axisX groundY "1" "0")
  
  (setq vlaObj (vlax-ename->vla-object (entlast)))
  
  (SetDynPropValue vlaObj "sirina levo" widthLeft)
  (SetDynPropValue vlaObj "sirina desno" widthRight)
  (SetDynPropValue vlaObj "razmera" (* scale 100))
    
  (vla-update vlaObj)
  
  (vlax-release-object vlaObj)
  
  (SetDimStyleCurrent "Poprecni profil")
  (AddTrafficDims (- axisX widthLeft) (+ axisX widthRight) (- upperDimsY (* dimSpacing 3.0)) "Popercni profil" 4)
  (AddTrafficDims (- axisX widthLeft) (+ axisX widthRight) (- upperDimsY (* dimSpacing 2.0)) "Poprecni profil" 3)
)

(defun AddRoadway( / roadType widthLeft widthRight firstPoint secondPoint)
  (LoadDialog "newroadway")
  
  (cond
    ((equal roadType "axis-road")
      (LoadDialog "newaxisroad")
      (if (and (not widthLeft)(not widthRight))
        (alert "Morate uneti bar jedno rastojanje od ose!")
        (progn
          (if (not widthLeft)(setq widthLeft "0"))
          (if (not widthRight)(setq widthRight "0"))
          (AddAxisRoad (atof widthLeft) (atof widthRight))
        )
      )
    )
    ((equal roadType "single-road")
      (setvar "OSMODE" OSNAPSETTINGS)
      (setq firstPoint (car (getpoint "\nPokazite prvu tacku kolovoza:")))
      (setq secondPoint (car (getpoint "\nPokazite drugu tacku kolovoza:")))
      (setvar "OSMODE" 0)
      (if (= firstPoint secondPoint)
        (alert "Tacke moraju biti razlicite!")
        (AddSingleRoad firstPoint secondPoint)
      )
    )
  )
)

; -------------------------------
; Main Traffic Elements Function
; -------------------------------

(defun AddTrafficElements( / elementType)
  (setq elementType "1")
  
  (while (not (equal elementType "0"))
    (LoadDialog "newtrafficelement")
    (cond
      ((equal elementType "roadway")
        (AddRoadway)
      )
      ((equal elementType "sidewalk")
        (AddSidewalk)
      )
      ((equal elementType "bikepath")
        (AddBikepath)
      )
      ((equal elementType "parking")
        (AddParking)
      )
      ((equal elementType "green")
        (AddGreen)
      )
    )
  )
)

; -------------------------------
; Underground Utilities Functions
; -------------------------------

(defun AddUndergroundUtility(blockName positionX / isPointFree vlaObj)
  (setq isPointFree 1)
  
  (foreach point lowerDimsLeftList 
    (if (equal point positionX 0.1)
      (setq isPointFree nil)
    )
  )
  
  (foreach point lowerDimsRightList
    (if (equal point positionX 0.1)
      (setq isPointFree nil)
    )
  )
  
  (if isPointFree
    (progn
      (InsertBlock blockName "20-Instalacije" positionX groundY "1" "0")
  
      (setq vlaObj (vlax-ename->vla-object (entlast)))
      
      (SetDynPropValue vlaObj "rastojanjeopisa" (* 6.5 scale))
      (SetDynPropValue vlaObj "razmera" (* scale 100))
      
      (vla-update vlaObj)
      
      (vlax-release-object vlaObj)
      
      (cond
        ((< positionX axisX)
          (setq lowerDimsLeftList (append lowerDimsLeftList (list positionX)))
        )
        ((> positionX axisX)
          (setq lowerDimsRightList (append lowerDimsRightList (list positionX))) 
        )
      )
    )
    (alert "Na pokazanom mestu vec postoji instalacija")
  )
)

(defun AddSingleUtility( / utilityName insertPoint)
  (LoadDialog "newsingleutility")
  
  (if utilityName
    (progn
      (setvar "OSMODE" OSNAPSETTINGS)
      (setq insertPoint (car (getpoint "\nPokazite poziciju nove instalacije:")))
      (setvar "OSMODE" 0)

      (if insertPoint
        (if (or (member insertPoint lowerDimsLeftList)(member insertPoint lowerDimsRightList))
          (alert "Na selektovanoj poziciji vec postoji instalacija")
          (progn
            (AddUndergroundUtility utilityName insertPoint)
          )
        )
      )
    )  
  )
)

(defun AddUtilitySet(position)
  (cond
    ((equal position "left")
      (AddUndergroundUtility "PP-Instalacije-elektro" (+ leftX 0.5))
      (AddUndergroundUtility "PP-Instalacije-gas" (+ leftX 1.25))
      (AddUndergroundUtility "PP-Instalacije-vodovod" (+ leftX 2.0))
      (AddUndergroundUtility "PP-Instalacije-telekom" (+ leftX 2.75))
    )
    ((equal position "right")
      (AddUndergroundUtility "PP-Instalacije-elektro" (- rightX 0.5))
      (AddUndergroundUtility "PP-Instalacije-gas" (- rightX 1.25))
      (AddUndergroundUtility "PP-Instalacije-vodovod" (- rightX 2.0))
      (AddUndergroundUtility "PP-Instalacije-telekom" (- rightX 2.75))
    )
  )
)

(defun AddUndergroundUtilities( / utilityType)
  (setq utilityType "1")
  
  (while (not (equal utilityType "0"))
    (LoadDialog "newundergroundutils")
    (cond
      ((equal utilityType "full-left")
        (if (> (- axisX leftX) 2.75)
          (AddUtilitySet "left")
          (alert "Nema dovoljno prostora za standardno postavljanje")
        )
      )
      ((equal utilityType "full-right")
        (if (> (- axisX leftX) 2.75)
          (AddUtilitySet "right")
          (alert "Nema dovoljno prostora za standardno postavljanje")
        )
      )
      ((equal utilityType "single-util")
        (AddSingleUtility)
      )
    )
  )
)

; -------------------------------
; Main Utility Elements Function
; -------------------------------

(defun AddUtilityElements( / elementType)
  (setq elementType "1")
  
  (while (not (equal elementType "0"))
    (LoadDialog "newutilityelement")
    (cond
      ((equal elementType "underground")
        (AddUndergroundUtilities)
      )
      ((equal elementType "public-lighting")
        ;(AddPublicLighting)
      )
      ((equal elementType "treeline")
        ;(AddTreeline)
      )
    )
  )
)

; -------------------------------
; Cross Section Type 2 Main Workflow
; -------------------------------

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
  (setq titleSecond (strcat (rtos (* 28.7 scale) 2) "," (rtos (* 16.5 scale) 2)))
  (setq subtitleFirst (strcat (rtos (* 21.0 scale) 2) "," (rtos (* 16.25 scale) 2)))
  (setq subtitleSecond (strcat (rtos (* 28.7 scale) 2) "," (rtos (* 14.75 scale) 2)))
  (setq axisPointFirst (strcat (rtos (* 21.0 scale) 2) "," (rtos (* 14.5 scale) 2)))
  (setq axisPointSecond (strcat (rtos (* 28.7 scale) 2) "," (rtos (* 13.5 scale) 2)))
  
  (WriteDText "Poprecni profil" "BL" bottomLeft (* 0.25 scale) 0 (GenerateId) "01-Tekst")
  (WriteDText "Poprecni profil" "TL" topLeft (* 0.25 scale) 0 "ЈП \"Урбанизам\" Завод за урбанизам, 21 000 Нови Сад, Бул. цара Лазара бр.3/III" "01-Tekst")
  (WriteMText "Poprecni profil" "TC" titleFirst titleSecond (* 0.5 scale) "КАРАКТЕРИСТИЧНИ ПОПРЕЧНИ ПРОФИЛ" "01-Tekst")
  (WriteMText "Poprecni profil" "TC" subtitleFirst subtitleSecond (* 0.35 scale) (strcat "Улица " streetName " " (rtos width 2 1) " m") "01-Tekst")
  (WriteMText "Poprecni profil" "TC" axisPointFirst axisPointSecond (* 0.25 scale) (strcat "од ОТ " axisPoint1 " до ОТ " axisPoint2) "01-Tekst")
)

(defun DrawCrossSection ( / groundX groundY upperMaxY lowerMaxY leftX rightX axisX upperDimsY lowerDimsY dimSpacing lowerDimsLeftList lowerDimsRightList)
  (setq groundX (* 10.75 scale))
  (setq groundY (* 8.0 scale))
  (setq upperMaxY (+ groundY (* 4.0 scale)))
  (setq lowerMaxY (- groundY (* 4.0 scale)))
  (setq leftX (- groundX (/ width 2)))
  (setq rightX (+ groundX (/ width 2)))
  (setq axisX (+ leftX (atof axisDistanceLeft)))
  (setq upperDimsY (+ groundY (* 8.5 scale)))
  (setq lowerDimsY (- groundY (* 5.5 scale)))
  (setq dimSpacing (* (getvar 'DIMDLI) scale))
  
  
  (DrawGround leftX rightX groundY)
  (DrawAxis lowerMaxY upperMaxY axisX)
  (DrawRegLines leftX rightX lowerMaxY groundY upperMaxY)
  (InsertOrientation rightX (+ upperMaxY 0.5) (+ rightX scale) (+ upperMaxY 0.75))
  (AddInitialDims leftX rightX groundY axisX upperDimsY dimSpacing)
  
  (ZoomAndRegen)
  
  (AddTrafficElements)
  (AddUtilityElements)
)

; -------------------------------
; Cross Section Type 2 Entry Point
; -------------------------------

(defun NewCsType2(/ streetName streetOrientation axisDistanceLeft axisDistanceRight axisPoint1 axisPoint2 scale width)
  (LoadDialog "newcstype2")
  
  (setq width (+ (atof axisDistanceLeft) (atof axisDistanceRight)))
  (if (equal axisPoint1 "")
    (setq axisPoint1 "00000")
  )
  (if (equal axisPoint2 "")
    (setq axisPoint2 "00000")
  )
  
  (cond
    ((<= width 18.0) (setq scale 1.0))
    ((<= width 36.0) (setq scale 2.0))
    ((<= width 54.0) (setq scale 3.0))
    (t (progn (alert "Trenutno nije moguće iscrtavanje ulice šire od 54 metra.") (exit)))
  )
  
  (ImportInitialStyles)
  (DrawFrame)
  (WriteText)
  (DrawCrossSection)
  
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
  
  (setq OSNAPSETTINGS (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  
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
  
  (setvar "OSMODE" OSNAPSETTINGS)
  
  (princ) ; Suppress return of extraneous results
)