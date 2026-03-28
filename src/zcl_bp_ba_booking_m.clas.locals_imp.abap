CLASS lhc_bookings DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE Bookings\_Bookingsupplement.

ENDCLASS.

CLASS lhc_bookings IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.

    DATA l_max_supid TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF zba_i_travel_m
    IN LOCAL MODE
    ENTITY Bookings BY \_BookingSupplement
    ALL FIELDS WITH CORRESPONDING #( entities )
    LINK DATA(lt_link_data)
    FAILED DATA(lt_failed).

    DATA(lt_entities) = entities.
    SORT lt_entities BY TravelId BookingId.
    DELETE ADJACENT DUPLICATES FROM lt_entities COMPARING TravelId BookingId.

    LOOP AT lt_entities INTO DATA(lwa_entities).

      l_max_supid = REDUCE #( INIT l_max = CONV #( '0' )
                              FOR lwa_link_data IN lt_link_data USING KEY entity
                              WHERE ( source-travelid = lwa_entities-TravelId AND source-bookingid = lwa_entities-BookingId )
                              NEXT l_max = COND #( WHEN l_max < lwa_link_data-target-BookingSupplementId THEN lwa_link_data-target-BookingSupplementId
                                                   ELSE l_max
                                                   )
                              ).
      l_max_supid = REDUCE #( INIT l_max = l_max_supid
                              FOR lwa_entity IN entities USING KEY  entity
                              WHERE ( TravelId = lwa_entities-TravelId AND BookingId = lwa_entities-BookingId )
                              FOR lwa_target IN lwa_entity-%target
                              NEXT l_max = COND #( WHEN l_max < lwa_target-BookingSupplementId THEN lwa_target-BookingSupplementId ELSE l_max )

                            ).


      LOOP AT lwa_entities-%target INTO DATA(lwa_tgt).
        IF lwa_tgt-BookingSupplementId IS INITIAL.
          l_max_supid = l_max_supid + 1.

          APPEND VALUE #( %cid = lwa_tgt-%cid
                          travelid = lwa_tgt-TravelId
                          bookingid = lwa_tgt-BookingId
                          bookingsupplementid = l_max_supid
                         ) TO mapped-bookingsuppl.

        ENDIF.
      ENDLOOP.

      CLEAR :l_max_supid.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
