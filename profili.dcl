newcrosssection: dialog {
  label = "Novi poprecni profil";
  : radio_row {
    label = "Tip profila";
    key = "cs-type";
    : radio_button {
      label = "Tipski profil";
      key = "cs-type-1";
      action = "(setq csType \"cs-type-1\")";
    }
    : radio_button {
      label = "Karakteristicni profil";
      key = "cs-type-2";
      action = "(setq csType \"cs-type-2\")";
    }
  }

  ok_cancel;
}

newcstype2: dialog {
  label = "Karakteristicni poprecni profil";
  : boxed_column {
    label = "Naziv i dimezije";
      : edit_box { 
        label = "*Naziv ulice:";
        key = "street-name";
        action = "(setq streetName $value)";
      }
      : edit_box { 
        label = "*Rastojanje leva regulacija-osa (m):";
        key = "axis-distance-left";
        action = "(setq axisDistanceLeft $value)";
        edit_width = 4;
      }
      : edit_box { 
        label = "*Rastojanje desna regulacija-osa (m):";
        key = "axis-distance-right";
        action = "(setq axisDistanceRight $value)";
        edit_width = 4;
      }   
  }

  : boxed_column {
    label = "Prostorne informacije";
    : edit_box { 
      label = "*Orijentacija profila (desno):";
      key = "street-orientation";
      action = "(setq streetOrientation $value)";
    }
    : column {
      alignment = left;
      width = 10;
      : edit_box { 
        label = "Od tacke:";
        key = "axis-point-1";
        action = "(setq axisPoint1 $value)";
        edit_width = 4;
      }
      : edit_box { 
        label = "Do tacke:";
        key = "axis-point-2";
        action = "(setq axisPoint2 $value)";
        edit_width = 4;
      } 
    }
  }

  : text {
    value = "* Obavezno polje";
  }

  spacer;

  ok_cancel;

  errtile;
}

newtrafficelement: dialog {
  label = "Dodavanje saobracajnih elementa";
  : boxed_column {
    : button { 
      label = "Dodaj kolovoz";
      key = "roadway";
      action = "(setq elementType \"roadway\")(done_dialog 1)";
    }
    : button { 
      label = "Dodaj trotoar";
      key = "sidewalk";
      action = "(setq elementType \"sidewalk\")(done_dialog 1)";     
    }
    : button { 
      label = "Dodaj biciklisticku stazu";
      key = "bikepath";
      action = "(setq elementType \"bikepath\")(done_dialog 1)";
    }
    : button { 
      label = "Dodaj parking";
      key = "parking";
      action = "(setq elementType \"parking\")(done_dialog 1)";
    }
    : button { 
      label = "Dodaj zelenilo";
      key = "green";
      action = "(setq elementType \"green\")(done_dialog 1)";
    }
  }

  spacer;

  ok_cancel;
}

newroadway: dialog {
  label = "Dodajte novi kolovoz";
  : button { 
    key = "axis-road";
    label = "Kolovoz u osi";
    action = "(setq roadType \"axis-road\")(done_dialog 1)";
  }
  : button { 
    key = "single-road";
    label = "Pojedinacni kolovoz";
    action = "(setq roadType \"single-road\")(done_dialog 1)";
  }
  
  spacer;

  ok_cancel;

}

newaxisroad: dialog {
  label = "Novi kolovoz u osi";
  : boxed_column {
    : edit_box { 
      key = "width-left";
      label = "Sirina levo od ose (m):";
      action = "(setq widthLeft $value)";
      edit_width = 4;
    }
    : edit_box { 
      key = "width-right";
      label = "Sirina desno od ose (m):";
      action = "(setq widthRight $value)";
      edit_width = 4;
    }
  }

  spacer;

  ok_cancel;

  errtile;
}

newsidewalk: dialog {
  label = "Dodajte novi trotoar";
  : boxed_column {
    : button { 
      label = "Obostrani trotoari uz reg. linije";
      key = "edge-sidewalks";
      action = "(setq sidewalkType \"edge-sidewalks\")(done_dialog 1)";
    }
    : button { 
      label = "Pojedinacni trotoar";
      key = "single-sidewalk";
      action = "(setq sidewalkType \"single-sidewalk\")(done_dialog 1)";
    }
  }

  spacer;

  ok_cancel;
}

newedgesidewalks: dialog {
  label = "Trotoari uz regulaciju";
  : boxed_column {
    : edit_box { 
      key = "left-sidewalk";
      label = "Sirina levog trotoara (m):";
      edit_width = 4;
      action = "(setq widthLeft $value)";
    }
    : edit_box { 
      key = "right-sidewalk";
      label = "Sirina desnog trotoara (m):";
      edit_width = 4;
      action = "(setq widthRight $value)";
    }
  }

  ok_cancel;

  errtile;
}