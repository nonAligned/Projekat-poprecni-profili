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

newbikepath: dialog {
  label = "Dodajte novu biciklisticku stazu";
  :radio_row {
    label = "Tacka insertovanja";
    key = "insert-side";
    : radio_button {
      label = "Leva ivica";
      key = "left-side";
      action = "(setq insertSide \"left-side\")";
    }
    : radio_button {
      label = "Desna ivica";
      key = "right-side";
      action = "(setq insertSide \"right-side\")";
    }
  }
  : boxed_column {
    : edit_box { 
      key = "bikepath-width";
      label = "Sirina staze (m):";
      edit_width = 4;
      action = "(setq bikepathWidth $value)";
    }
  }
  spacer;
  ok_cancel;
  errtile;
}

newparking: dialog {
  label = "Dodajte novi parking";
  :radio_row {
    label = "Polozaj parkinga";
    key = "parking-side";
    : radio_button {
      label = "Levi parking"; 
      key = "left-parking";
      action = "(setq parkingSide 0)";
    }
    : radio_button {
      label = "Desni parking";
      key = "right-parking";
      action = "(setq parkingSide 1)";
    }
  }
  : boxed_column {
    : edit_box { 
      key = "parking-width";
      label = "Sirina parkinga (m):";
      edit_width = 4;
      action = "(setq parkingWidth $value)";
    }
  }
  spacer;
  ok_cancel;
  errtile;
}

newutilityelement: dialog {
  label = "Dodavanje infrastrukture";
  : boxed_column {
    : button { 
      label = "Dodaj podzemne instalacije";
      key = "undeground";
      action = "(setq elementType \"underground\")(done_dialog 1)";
    }
    : button { 
      label = "Dodaj javnu rasvetu";
      key = "public-lighting";
      action = "(setq elementType \"public-lighting\")(done_dialog 1)";     
    }
    : button { 
      label = "Dodaj drvored";
      key = "treeline";
      action = "(setq elementType \"treeline\")(done_dialog 1)";
    }
  }

  spacer;

  ok_cancel;
}

newundergroundutils: dialog {
  label = "Dodavanje podzemnih instalacija";
  : boxed_column {
    : button { 
      label = "Sve uz levu regulaciju";
      key = "full-left";
      action = "(setq utilityType \"full-left\")(done_dialog 1)";
    }
    : button { 
      label = "Sve uz desnu regulaciju";
      key = "full-right";
      action = "(setq utilityType \"full-right\")(done_dialog 1)";     
    }
    : button { 
      label = "Dodaj pojedinacno";
      key = "single-util";
      action = "(setq utilityType \"single-util\")(done_dialog 1)";
    }
  }

  spacer;

  ok_cancel;
}

newsingleutility: dialog {
  label = "Dodaj pojedinacnu instalaciju";
  : boxed_column {
    :button { 
      key = "electric";
      label = "Elektrovod";
      action = "(setq utilityName \"PP-Instalacije-elektro\")(done_dialog 1)";
    }
    :button { 
      key = "gas";
      label = "Gasovod";
      action = "(setq utilityName \"PP-Instalacije-gas\")(done_dialog 1)";
    }
    :button { 
      key = "water";
      label = "Vodovod";
      action = "(setq utilityName \"PP-Instalacije-vodovod\")(done_dialog 1)";
    }
    :button { 
      key = "telecom";
      label = "Telekom";
      action = "(setq utilityName \"PP-Instalacije-telekom\")(done_dialog 1)";
    }
    :button { 
      key = "sewageSanitary";
      label = "Kanalizacija fekalna";
      action = "(setq utilityName \"PP-Instalacije-kanalizacija-fekalna\")(done_dialog 1)";

    }
    :button { 
      key = "sewageStormwater";
      label = "Kanalizacija atmosferska";
      action = "(setq utilityName \"PP-Instalacije-kanalizacija-atmosferska\")(done_dialog 1)";

    }
    :button { 
      key = "sewageCombined";
      label = "Kanalizacija zajednicka";
      action = "(setq utilityName \"PP-Instalacije-kanalizacija-zajednicka\")(done_dialog 1)";
    }
  }
  spacer;
  ok_cancel;
}