class Tables {
  static String CREATE_TABLE_CATEGORIES =
      "CREATE TABLE IF NOT EXISTS table_categories (" +
          "id				        INTEGER PRIMARY KEY AUTOINCREMENT," +
          "name				      TEXT," +
          "color				    TEXT," +
          "icon				      TEXT" +
          ")";

  static String CREATE_TABLE_EXPENDS =
      "CREATE TABLE IF NOT EXISTS table_expends (" +
          "id				        INTEGER PRIMARY KEY," +
          "id_category			INTEGER," +
          "date			        TEXT," +
          "month			      TEXT," +
          "timestamp			  TEXT," +
          "description			TEXT," +
          "expends			    REAL," +
          "place			      TEXT" +
          ")";
}
