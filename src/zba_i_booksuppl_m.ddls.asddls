@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suppliments Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity zba_i_booksuppl_m
  as select from zba_booksuppl_m
  association        to parent ZBA_I_BOOKING_M as _Bookings       on  $projection.BookingId = _Bookings.BookingId
                                                                  and $projection.TravelId  = _Bookings.TravelId
  association [1..1] to ZBA_I_TRAVEL_M as _Travel on $projection.TravelId = _Travel.TravelId                                                                
  association [0..1] to /DMO/I_Supplement      as _Supplement     on  $projection.SupplementId = _Supplement.SupplementID
  association [1..*] to /DMO/I_SupplementText  as _SupplementText on  $projection.SupplementId = _SupplementText.SupplementID
  association [1..1] to I_Currency             as _Currency       on  $projection.CurrencyCode = _Currency.Currency
{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      _Supplement,
      _SupplementText,
      _Currency,
      _Bookings,
      _Travel
}
