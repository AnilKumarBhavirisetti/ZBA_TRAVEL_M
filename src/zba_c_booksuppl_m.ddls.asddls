@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplements Projection View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZBA_C_BOOKSUPPL_M
  as projection on zba_i_booksuppl_m
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Bookings : redirected to parent ZBA_C_BOOKING_M,
      _Currency,
      _Supplement,
      _SupplementText,
      _Travel   : redirected to ZBA_C_TRAVEL_M
}
