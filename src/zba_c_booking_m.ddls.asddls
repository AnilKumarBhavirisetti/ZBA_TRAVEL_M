@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZBA_C_BOOKING_M
  as projection on ZBA_I_BOOKING_M
{
  key TravelId,
  key BookingId,
      BookingDate,
      CustomerId,
      @ObjectModel.text.element: [ 'AirlineName' ]
      CarrierId,
      _Airline.Name                as AirlineName,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      @ObjectModel.text.element: [ 'CurrencyName' ]
      CurrencyCode,
      _Currency._Text.CurrencyName as CurrencyName      : localized,
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      _BookingStatus._Text.Text    as BookingStatusText : localized,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      /* Associations */
      _Airline,
      _BookingStatus,
      _BookingSupplement : redirected to composition child ZBA_C_BOOKSUPPL_M,
      _Connection,
      _Currency,
      _Customer,
      _Travel            : redirected to parent ZBA_C_TRAVEL_M
}
