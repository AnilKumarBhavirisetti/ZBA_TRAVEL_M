@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Travel View'
@Metadata.ignorePropagatedAnnotations: false
define root view entity ZBA_C_TRAVEL_M
  provider contract transactional_query
  as projection on ZBA_I_TRAVEL_M
{
  key TravelId,
      AgencyId,
      CustomerId,
      BeginDate,
      EndDate,
//      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
//      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      Description,
      OverallStatus,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _Agency,
      _Bookings : redirected to composition child ZBA_C_BOOKING_M,
      _Currency,
      _Customer,
      _Status
}
