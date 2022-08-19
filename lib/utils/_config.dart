import 'package:flutter/material.dart';

class Config {
  //User Preferences
  static final Color COLOR_HIGHLIGHT = Color(0xFF62d9b5);
  static final Color COLOR_PRIMARY = Color(0xFF242728);
  static final Color COLOR_TEXT = Color(0xFF242728);
  static final Color COLOR_HYPERLINK = Colors.blue;
  static final Color COLOR_LIGHTGRAY = Color(0xFF898989);
  static final Color COLOR_DARKGRAY = Color(0xFF888888);

  //Padding
  static final double PADDING_DEFAULT = 10;

  //Toast Narrations
  static final String TOAST_NARRATION_EDITMODE = "Edit Mode";
  static final String TOAST_NARRATION_NOTESAVED = "Saved!";

  // Screen View Mode
  static final int VIEW_HOMEDASHBOARD = 0;
  static final int VIEW_SHOWNOTE = 1;

  //Cities
  static final String MAINCITY = "Lusaka";
  static final String ALTCITY1 = "Mumbai";
  static final String ALTCITY2 = "Kyoto";

  //Ovi API
  static final String OVI_API_URL = "https://notes.ovidware.com/core/api.php";
  static final String OVI_USER_ID = "1";
  static final String OVI_NOTE_ID = "590";
  static final String OVI_JOURNAL_ID = "591";
  static final String OVI_SHORTCUTS_ID = "860";

  //Weather API
  static final String WEATHER_KEY = "9bc6faa8afe24d1d992111550222405";

  //SideMenu
  static final int MENU_HOMEINDEX = 0;
  static final int MENU_NOTEINDEX = 1;
  static final int MENU_JOURNALINDEX = 2;
  static final int MENU_SHORTCUTSINDEX = 3;
  static final double MENU_WIDTH = 40;

  //Logs
  static final bool LOG_DEBUG_ENABLED = true;

  //Widgets
  static final double WIDGET_FONTSIZE = 8;
  static final double WIDGET_WIDTH = 80;
  static final double WIDGET_HEIGHT = 40;
  static final double WIDGET_ICONSIZE = 14;
  static final int WIDGET_NUMBER_TO_DISPLAY = 3;
  static final String WIDGET_INTERNATIONAL_CLOCK_DEFAULT_CITY = "Lusaka";
  static final String WIDGET_WHITENOISE_DEFAULT_FILE = "ship";
  static final String WIDGET_WHITENOISE_DEFAULT_NARRATION = "White Noise";

  //Data
  static final String DATA_TEMPLATE_FILE = 'assets/data_template.json';
}
