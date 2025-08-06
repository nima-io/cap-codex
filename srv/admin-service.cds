using { bookshop as db } from '../db/schema';

@protocol: 'odata-v4'
service AdminService {
  entity Authors   as projection on db.Authors;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Books     as projection on db.Books;
  entity Customers as projection on db.Customers actions {
    action contact(subject : String, message : String) returns String;
  };
  entity Orders    as projection on db.Orders;
  entity OrderItems as projection on db.OrderItems actions {
    action requestReturn(reason : String) returns Returns;
  };
  entity Returns as projection on db.Returns;
  entity Publishers as projection on db.Publishers;
  entity Categories as projection on db.Categories;
  entity Formats as projection on db.Formats;
  entity Tags as projection on db.Tags;
  entity Reviews as projection on db.Reviews;
  entity Promotions as projection on db.Promotions;
}

annotate AdminService.Authors with @UI.LineItem: [
  { Value: ID },
  { Value: name }
];

annotate AdminService.Books with @UI: {
  HeaderInfo: {
    TypeName: 'Book',
    TypeNamePlural: 'Books'
  },
  LineItem: [
    { Value: title },
    { Value: author },
    { Value: stock },
    { Value: price }
  ],
  Facets: [
    {
      $Type: 'UI.ReferenceFacet',
      Label: 'General',
      Target: '@UI.FieldGroup#General'
    }
  ],
  FieldGroup#General: {
    Data: [
      { Value: title },
      { Value: author },
      { Value: stock },
      { Value: price },
      { Value: publisher },
      { Value: category },
      { Value: format }
    ]
  }
};
