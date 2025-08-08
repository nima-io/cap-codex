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
  entity Departments as projection on db.Departments;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Employees as projection on db.Employees;
  entity Reviews as projection on db.Reviews;
  entity Promotions as projection on db.Promotions;
}

annotate AdminService.Authors with @UI: {
  Identification: [
    { Value: name }
  ],
  LineItem: [
    { Value: ID },
    { Value: name },
    { Value: royaltyRate },
    { Value: totalSales },
    { Value: totalRoyalty }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: name },
      { $Type: 'UI.DataField', Value: royaltyRate },
      { $Type: 'UI.DataField', Value: totalSales },
      { $Type: 'UI.DataField', Value: totalRoyalty }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>AuthorDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.Books with {
  author @title: '{i18n>Author}';
  author @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Authors', element: 'ID', labelElement: 'name' }];
  publisher @title: '{i18n>Publisher}';
  publisher @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Publishers', element: 'ID', labelElement: 'name' }];
  category @title: '{i18n>Category}';
  category @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Categories', element: 'ID', labelElement: 'name' }];
  format @title: '{i18n>Format}';
  format @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Formats', element: 'ID', labelElement: 'name' }];
};

annotate AdminService.Books with @UI: {
  Identification: [
    { Value: title }
  ],
  LineItem: [
    { Value: ID },
    { Value: title },
    { Value: author, Label: '{i18n>Author}' },
    { Value: price },
    { Value: stock }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: title },
      { $Type: 'UI.DataField', Value: stock },
      { $Type: 'UI.DataField', Value: price },
      { $Type: 'UI.DataField', Value: isFeatured },
      { $Type: 'UI.DataField', Value: bestsellerRank }
    ]
  },
  FieldGroup #Classification: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: author },
      { $Type: 'UI.DataField', Value: publisher },
      { $Type: 'UI.DataField', Value: category },
      { $Type: 'UI.DataField', Value: format }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>General}', Target: '@UI.FieldGroup#General' },
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>Classification}', Target: '@UI.FieldGroup#Classification' }
  ],
  SelectionFields: [ title, author, category ]
};

annotate AdminService.Customers with @UI: {
  Identification: [
    { Value: name }
  ],
  LineItem: [
    { Value: ID },
    { Value: name },
    { Value: email },
    { Value: loyaltyTier }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: name },
      { $Type: 'UI.DataField', Value: email },
      { $Type: 'UI.DataField', Value: phone },
      { $Type: 'UI.DataField', Value: loyaltyTier }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>CustomerDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name, email, loyaltyTier ]
};

annotate AdminService.Orders with {
  customer @title: '{i18n>Customer}';
  customer @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Customers', element: 'ID', labelElement: 'name' }];
};

annotate AdminService.Orders with @UI: {
  Identification: [
    { Value: ID }
  ],
  LineItem: [
    { Value: ID },
    { Value: customer, Label: '{i18n>Customer}' },
    { Value: status }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: ID },
      { $Type: 'UI.DataField', Value: customer },
      { $Type: 'UI.DataField', Value: status }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>OrderDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ ID, customer, status ]
};

annotate AdminService.OrderItems with {
  parent @title: '{i18n>Order}';
  parent @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Orders', element: 'ID', labelElement: 'ID' }];
  book @title: '{i18n>Book}';
  book @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Books', element: 'ID', labelElement: 'title' }];
};

annotate AdminService.OrderItems with @UI: {
  Identification: [
    { Value: parent },
    { Value: lineNo }
  ],
  LineItem: [
    { Value: parent, Label: '{i18n>Order}' },
    { Value: lineNo },
    { Value: book, Label: '{i18n>Book}' },
    { Value: quantity },
    { Value: netAmount }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: parent },
      { $Type: 'UI.DataField', Value: lineNo },
      { $Type: 'UI.DataField', Value: book },
      { $Type: 'UI.DataField', Value: quantity },
      { $Type: 'UI.DataField', Value: netAmount }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>OrderItem}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ parent, book ]
};

annotate AdminService.Returns with {
  orderItem @title: '{i18n>OrderItem}';
  orderItem @Consumption.valueHelpDefinition: [{ entity: 'AdminService.OrderItems', element: 'parent' }];
};

annotate AdminService.Returns with @UI: {
  Identification: [
    { Value: ID }
  ],
  LineItem: [
    { Value: ID },
    { Value: orderItem, Label: '{i18n>OrderItem}' },
    { Value: status },
    { Value: refundAmount }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: orderItem },
      { $Type: 'UI.DataField', Value: reason },
      { $Type: 'UI.DataField', Value: status },
      { $Type: 'UI.DataField', Value: refundAmount }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>ReturnDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ status ]
};

annotate AdminService.Publishers with @UI: {
  Identification: [
    { Value: name }
  ],
  LineItem: [
    { Value: ID },
    { Value: name }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: name }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>PublisherDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.Categories with @UI: {
  Identification: [
    { Value: name }
  ],
  LineItem: [
    { Value: ID },
    { Value: name }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: name }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>CategoryDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.Formats with @UI: {
  Identification: [
    { Value: name }
  ],
  LineItem: [
    { Value: ID },
    { Value: name }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: name }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>FormatDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.Tags with @UI: {
  Identification: [
    { Value: name }
  ],
  LineItem: [
    { Value: ID },
    { Value: name }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: name }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>TagDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.Reviews with {
  book @title: '{i18n>Book}';
  book @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Books', element: 'ID', labelElement: 'title' }];
  customer @title: '{i18n>Customer}';
  customer @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Customers', element: 'ID', labelElement: 'name' }];
};

annotate AdminService.Reviews with @UI: {
  Identification: [
    { Value: ID }
  ],
  LineItem: [
    { Value: ID },
    { Value: book, Label: '{i18n>Book}' },
    { Value: customer, Label: '{i18n>Customer}' },
    { Value: rating }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: book },
      { $Type: 'UI.DataField', Value: customer },
      { $Type: 'UI.DataField', Value: rating },
      { $Type: 'UI.DataField', Value: comment }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>ReviewDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ book, customer ]
};

annotate AdminService.Promotions with {
  book @title: '{i18n>Book}';
  book @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Books', element: 'ID', labelElement: 'title' }];
};

annotate AdminService.Promotions with @UI: {
  Identification: [
    { Value: description }
  ],
  LineItem: [
    { Value: ID },
    { Value: description },
    { Value: discountCode },
    { Value: discountPercentage },
    { Value: startDate },
    { Value: endDate },
    { Value: book, Label: '{i18n>Book}' }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: description },
      { $Type: 'UI.DataField', Value: discountCode },
      { $Type: 'UI.DataField', Value: discountPercentage },
      { $Type: 'UI.DataField', Value: startDate },
      { $Type: 'UI.DataField', Value: endDate },
      { $Type: 'UI.DataField', Value: book }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>PromotionDetails}', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ description, discountCode, book ]
};

annotate AdminService.Departments with @UI: {
  LineItem: [
    { Value: ID },
    { Value: name }
  ],
  Identification: [
    { Value: name }
  ]
};

annotate AdminService.Employees with {
  department @title: '{i18n>Department}';
  department @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Departments', element: 'ID', labelElement: 'name' }];
};

annotate AdminService.Employees with @UI: {
  Identification: [
    { Value: firstName },
    { Value: lastName }
  ],
  LineItem: [
    { Value: ID },
    { Value: firstName, Label: '{i18n>FirstName}' },
    { Value: lastName, Label: '{i18n>LastName}' },
    { Value: department, Label: '{i18n>Department}' },
    { Value: email, Label: '{i18n>Email}' }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: firstName },
      { $Type: 'UI.DataField', Value: lastName },
      { $Type: 'UI.DataField', Value: department }
    ]
  },
  FieldGroup #Contact: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: email }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>FacetGeneral}', Target: '@UI.FieldGroup#General' },
    { $Type: 'UI.ReferenceFacet', Label: '{i18n>FacetContact}', Target: '@UI.FieldGroup#Contact' }
  ],
  SelectionFields: [ firstName, lastName, department ]
};
