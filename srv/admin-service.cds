using { bookshop as db } from '../db/schema';

@protocol: 'odata-v4'
service AdminService {
  entity Authors    as projection on db.Authors;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Books      as projection on db.Books;
  entity Publishers as projection on db.Publishers;
  entity Categories as projection on db.Categories;
  entity Formats    as projection on db.Formats;
}

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
