CLASS zcl_ba_load_travel_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ba_load_travel_data IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  DELETE FROM ZBA_TRAVEL_M.
  DELETE FROM ZBA_BOOKING_M.
  DELETE FROM ZBA_BOOKSUPPL_M.

  SELECT * FROM /dmo/travel_m INTO TABLE @DATA(lt_travel_m).
  IF SY-SUBRC IS INITIAL.
   INSERT zba_travel_m FROM TABLE @lt_travel_m.
  ENDIF.

  SELECT * FROM /dmo/booking_m INTO TABLE @DATA(LT_BOOKING_M).
  IF SY-SUBRC IS INITIAL.
   INSERT zba_booking_m FROM TABLE @lt_booking_m.
  ENDIF.

  SELECT * FROM /dmo/booksuppl_m INTO TABLE @DATA(lt_booksuppl_m).
  IF SY-SUBRC IS INITIAL.
   INSERT zba_booksuppl_m FROM TABLE @lt_booksuppl_m.
  ENDIF.


  ENDMETHOD.
ENDCLASS.
