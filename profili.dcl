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
      }
      : edit_box { 
        label = "*Rastojanje leva regulacija-osa (m):";
        key = "axis-distance-left";
        edit_width = 4;
      }
      : edit_box { 
        label = "*Rastojanje desna regulacija-osa (m):";
        key = "axis-distance-right";
        edit_width = 4;
      }   
  }

  : boxed_column {
    label = "Prostorne informacije";
    : edit_box { 
      label = "*Orijentacija profila (desno):";
      key = "street-orientation";
    }
    : column {
      alignment = left;
      width = 10;
      : edit_box { 
        label = "Od tacke:";
        key = "axis-point-1";
        edit_width = 4;
      }
      : edit_box { 
        label = "Do tacke:";
        key = "axis-point-2";
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