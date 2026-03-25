@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZBA_I_BOOKING_M
  as select from zba_booking_m
  composition [0..*] of zba_i_booksuppl_m as _BookingSupplement
  association to parent ZBA_I_TRAVEL_M as _Travel on $projection.TravelId = _Travel.TravelId
  association [0..1] to /dmo/customer            as _Customer      on  $projection.CustomerId = _Customer.customer_id
  association [0..1] to /DMO/I_Carrier           as _Airline       on  $projection.CarrierId = _Airline.AirlineID
  association [1..1] to I_Currency               as _Currency      on  $projection.CurrencyCode = _Currency.Currency
  association [1..1] to /DMO/I_Connection        as _Connection    on  $projection.CarrierId    = _Connection.AirlineID
                                                                   and $projection.ConnectionId = _Connection.ConnectionID
  association [0..1] to /DMO/I_Booking_Status_VH as _BookingStatus on  $projection.BookingStatus = _BookingStatus.BookingStatus
{
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      _Customer,
      _Airline,
      _Currency,
      _Connection,
      _BookingStatus,
      _Travel,
      _BookingSupplement
}
