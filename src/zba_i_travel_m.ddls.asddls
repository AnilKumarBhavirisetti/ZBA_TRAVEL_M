@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZBA_I_TRAVEL_M
  as select from zba_travel_m
  composition [0..*] of ZBA_I_BOOKING_M          as _Bookings
  association [0..1] to /dmo/agency              as _Agency   on $projection.AgencyId = _Agency.agency_id
  association [0..1] to /dmo/customer            as _Customer on $projection.CustomerId = _Customer.customer_id
  association [0..1] to I_Currency               as _Currency on $projection.CurrencyCode = _Currency.Currency
  association [1..1] to /DMO/I_Overall_Status_VH as _Status   on $projection.OverallStatus = _Status.OverallStatus
{
  key travel_id       as TravelId,
      agency_id       as AgencyId,
      customer_id     as CustomerId,
      begin_date      as BeginDate,
      end_date        as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price     as TotalPrice,
      currency_code   as CurrencyCode,
      description     as Description,
      overall_status  as OverallStatus,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      _Bookings,
      _Agency,
      _Customer,
      _Currency,
      _Status
}
