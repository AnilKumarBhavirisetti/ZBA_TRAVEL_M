CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

*--- Delete the travel instance for which ID is already there
    DATA(lt_entity) = entities.
    DELETE lt_entity WHERE TravelId IS NOT INITIAL.

    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entity ) )
          IMPORTING
             number            = DATA(l_number)
            returncode        =  DATA(l_returncode)
            returned_quantity =  DATA(l_quantity)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).
    ENDTRY.

    LOOP AT lt_entity INTO DATA(lwa_entity).
      l_number = l_number + 1.
      APPEND VALUE #( %cid = lwa_entity-%cid travelid = l_number ) TO mapped-travel.

      IF l_quantity NE lines( lt_entity ).
        APPEND VALUE #( %cid = lwa_entity-%cid ) TO failed-travel.
        APPEND VALUE #( %cid = lwa_entity-%cid
                        %msg = lo_error ) TO reported-travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
