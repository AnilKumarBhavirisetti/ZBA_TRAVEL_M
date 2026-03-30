CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS AcceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~AcceptTravel RESULT result.

    METHODS CopyTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~CopyTravel.

    METHODS RecalculateTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION Travel~RecalculateTotalPrice.

    METHODS RejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~RejectTravel RESULT result.
    METHODS earlynumbering_cba_Bookings FOR NUMBERING
      IMPORTING entities FOR CREATE Travel\_Bookings.

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

  METHOD earlynumbering_cba_Bookings.

    DATA : l_booking_max TYPE /dmo/booking_id.

    READ ENTITIES OF zba_i_travel_m
    IN LOCAL MODE
    ENTITY Travel BY \_Bookings
    ALL FIELDS WITH CORRESPONDING #( entities )
    LINK DATA(lt_bookings)
    FAILED DATA(lt_failed).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities_group>)
                     GROUP BY <lfs_entities_group>-TravelId.
*-- checking max booking number from Database records
      l_booking_max = REDUCE #( INIT l_max = CONV /dmo/booking_id( '0' )
                               FOR <lfs_link> IN lt_bookings USING KEY entity
                               WHERE ( source-TravelId = <lfs_entities_group>-TravelId )
                               NEXT l_max = COND #( WHEN l_max < <lfs_link>-target-BookingId THEN <lfs_link>-target-BookingId
                                                    ELSE l_max
                                                    )
                               ).
*-- Checking max number from the imported entities
      l_booking_max = REDUCE #( INIT l_max = l_booking_max
                                FOR <lfs_entities> IN entities USING KEY entity
                                WHERE ( TravelId = <lfs_entities_group>-TravelId )
                                FOR <lf_booking> IN <lfs_entities>-%target
                                NEXT l_max = COND #( WHEN l_max < <lf_booking>-BookingId THEN <lf_booking>-BookingId ELSE l_max )
                               ).


      LOOP AT <lfs_entities_group>-%target INTO DATA(lwa_bk).

        IF lwa_bk-BookingId IS INITIAL.
          l_booking_max = l_booking_max + 1.

          APPEND VALUE #( %cid = lwa_bk-%cid
                          travelid = lwa_bk-travelid
                          bookingid = l_booking_max ) TO mapped-bookings.

        ENDIF.

      ENDLOOP.
      CLEAR : l_booking_max.
    ENDLOOP.

  ENDMETHOD.

  METHOD AcceptTravel.
  ENDMETHOD.

  METHOD CopyTravel.

    DATA : lt_travel    TYPE TABLE FOR CREATE zba_i_travel_m,
           lt_booking   TYPE TABLE FOR CREATE zba_i_travel_m\_Bookings,
           lt_booksuppl TYPE TABLE FOR CREATE zba_i_booking_m\_BookingSupplement.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<lfs_key>) WITH KEY %cid = ' '.
*-- Ensure CID field is filled
    IF <lfs_key> IS NOT ASSIGNED.
*-- Read Travel data
      READ ENTITIES OF zba_i_travel_m IN LOCAL MODE
      ENTITY Travel
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel_db)
      FAILED DATA(lt_travel_failed).

*-- Read Booking data from travel using association
      READ ENTITIES OF zba_i_travel_m
      IN LOCAL MODE
      ENTITY Travel BY \_Bookings
      ALL FIELDS WITH CORRESPONDING #( lt_travel_db )
      RESULT DATA(lt_booking_db)
      FAILED DATA(lt_booking_failed).
*-- Read Booking supplements data using Association
      READ ENTITIES OF zba_i_travel_m IN LOCAL MODE
      ENTITY Bookings BY \_BookingSupplement
      ALL FIELDS WITH CORRESPONDING #( lt_booking_db )
      RESULT DATA(lt_booksuppl_db)
      FAILED DATA(lt_booksupl_failed).

      LOOP AT lt_travel_db INTO DATA(lwa_travel_db).
*-- Copy data to new internal table lt_travel
        APPEND VALUE #( %cid = keys[ KEY entity TravelId = lwa_travel_db-TravelId ]-%cid
                        %data = CORRESPONDING #( lwa_travel_db EXCEPT travelid )
                         ) TO lt_travel ASSIGNING FIELD-SYMBOL(<lfs_travel>).

        <lfs_travel>-BeginDate = cl_abap_context_info=>get_system_date(  ).
        <lfs_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.
        <lfs_travel>-OverallStatus = 'O'.

        APPEND VALUE #( %cid_ref = <lfs_travel>-%cid
                         ) TO lt_booking ASSIGNING FIELD-SYMBOL(<lfs_booking>).

        LOOP AT lt_booking_db ASSIGNING FIELD-SYMBOL(<lfs_booking_db>).

          APPEND VALUE #( %cid = <lfs_booking>-%cid_ref && <lfs_booking_db>-BookingId
                          %data = CORRESPONDING #( <lfs_booking_db> EXCEPT travelid )
                         ) TO <lfs_booking>-%target ASSIGNING FIELD-SYMBOL(<lfs_booking_tg>).

          <lfs_booking_tg>-BookingStatus = 'N'.

          APPEND VALUE #( %cid_ref = <lfs_booking_tg>-%cid
                          bookingid = <lfs_booking_tg>-BookingId
                         ) TO lt_booksuppl ASSIGNING FIELD-SYMBOL(<lfs_booksuppl>).

          LOOP AT lt_booksuppl_db ASSIGNING FIELD-SYMBOL(<lfs_booksuppl_db>).

            APPEND VALUE #( %cid = <lfs_booksuppl>-%cid_ref && <lfs_booksuppl_db>-BookingSupplementId
                            %data = CORRESPONDING #( <lfs_booksuppl_db> EXCEPT travelid )
                          ) TO <lfs_booksuppl>-%target.

          ENDLOOP.


        ENDLOOP.


      ENDLOOP.

      MODIFY ENTITIES OF zba_i_travel_m IN LOCAL MODE
      ENTITY Travel
      CREATE FIELDS ( TravelId )
      WITH lt_travel

      ENTITY Travel
      CREATE BY \_Bookings
      FIELDS ( TravelId )
      WITH lt_booking

      ENTITY Bookings
      CREATE BY \_BookingSupplement
      FIELDS ( TravelId )
      WITH lt_booksuppl

      MAPPED mapped
      FAILED failed
      REPORTED reported.


    ENDIF.
  ENDMETHOD.

  METHOD RecalculateTotalPrice.
  ENDMETHOD.

  METHOD RejectTravel.
  ENDMETHOD.

ENDCLASS.
