@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Travel View'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity ZBA_C_TRAVEL_M
  provider contract transactional_query
  as projection on ZBA_I_TRAVEL_M
{
  key TravelId,
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyId,
      _Agency.name        as AgencyName,
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.last_name as CustomerName,
      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,
      CurrencyCode,
      Description,
      @ObjectModel.text.element: [ 'OverallStatusText' ]
      OverallStatus,
      _Status._Text.Text  as OverallStatusText : localized,
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
