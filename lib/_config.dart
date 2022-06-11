import 'package:flutter/material.dart';

class Config {
  //User Preferences
  static final Color HIGHLIGHT_COLOR = Color(0xFF62d9b5);
  static final Color PRIMARY_COLOR = Color(0xFF242728);

  //Cities
  static final String MAINCITY = "Lusaka";
  static final String ALTCITY1 = "Mumbai";
  static final String ALTCITY2 = "Kyoto";

  //Ovi API
  static final String OVI_API_URL = "http://notes.ovidware.com/core/api.php";
  static final String OVI_USER_ID = "1";
  static final String OVI_NOTE_ID = "590";
  static final String OVI_JOURNAL_ID = "591";
  static final String OVI_SHORTCUTS_ID = "592";

  //Weather API
  static final String WEATHER_KEY = "9bc6faa8afe24d1d992111550222405";

  //SideMenu
  static final int MENU_NOTEINDEX = 0;
  static final int MENU_JOURNALINDEX = 1;
  static final int MENU_SHORTCUTSINDEX = 2;
}
