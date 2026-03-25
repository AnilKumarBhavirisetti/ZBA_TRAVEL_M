@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZBA_C_BOOKING_M
  as projection on ZBA_I_BOOKING_M
{
  key TravelId,
  key BookingId,
      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      BookingStatus,
      LastChangedAt,
      /* Associations */
      _Airline,
      _BookingStatus,
      _BookingSupplement : redirected to composition child zba_c_booksuppl_m,
      _Connection,
      _Currency,
      _Customer,
      _Travel : redirected to parent zba_c_travel_m
}
