@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supplements Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZBA_C_BOOKSUPPL_M
  as projection on zba_i_booksuppl_m
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'SupplementText' ]
      SupplementId,
      _SupplementText.Description  as SupplementText : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      @ObjectModel.text.element: [ 'CurrencyName' ]
      CurrencyCode,
      _Currency._Text.CurrencyName as CurrencyName   : localized,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _Bookings : redirected to parent ZBA_C_BOOKING_M,
      _Currency,
      _Supplement,
      _SupplementText,
      _Travel   : redirected to ZBA_C_TRAVEL_M
}
