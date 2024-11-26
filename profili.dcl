newcrosssection:dialog {
    label="Novi poprecni profil";
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