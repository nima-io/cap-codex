using { AdminService } from './admin-service';

annotate AdminService.Authors with @UI: {
  HeaderInfo: {
    TypeName: 'Author',
    TypeNamePlural: 'Authors',
    Title: { Value: name }
  },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Author Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.Books with {
  author_ID @title: 'Author';
  author_ID @Common.Text: author.name;
  author_ID @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Authors', element: 'ID', labelElement: 'name' }];
  publisher_ID @title: 'Publisher';
  publisher_ID @Common.Text: publisher.name;
  publisher_ID @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Publishers', element: 'ID', labelElement: 'name' }];
  category_ID @title: 'Category';
  category_ID @Common.Text: category.name;
  category_ID @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Categories', element: 'ID', labelElement: 'name' }];
  format_ID @title: 'Format';
  format_ID @Common.Text: format.name;
  format_ID @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Formats', element: 'ID', labelElement: 'name' }];
};

annotate AdminService.Books with @UI: {
  HeaderInfo: {
    TypeName: 'Book',
    TypeNamePlural: 'Books',
    Title: { Value: title }
  },
  Identification: [
    { Value: title }
  ],
  LineItem: [
    { Value: title },
    { Value: author_ID, Label: 'Author' },
    { Value: price },
    { Value: stock },
    { Value: category_ID, Label: 'Category' }
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
      { $Type: 'UI.DataField', Value: author_ID },
      { $Type: 'UI.DataField', Value: publisher_ID },
      { $Type: 'UI.DataField', Value: category_ID },
      { $Type: 'UI.DataField', Value: format_ID }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: 'General', Target: '@UI.FieldGroup#General' },
    { $Type: 'UI.ReferenceFacet', Label: 'Classification', Target: '@UI.FieldGroup#Classification' },
    { $Type: 'UI.ReferenceFacet', Label: 'Tags', Target: 'tags/@UI.LineItem' }
  ],
  SelectionFields: [ title, author_ID, category_ID ]
};

annotate AdminService.Customers with @UI: {
  HeaderInfo: {
    TypeName: 'Customer',
    TypeNamePlural: 'Customers',
    Title: { Value: name }
  },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Customer Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name, email, loyaltyTier ]
};

annotate AdminService.Orders with {
  customer @title: 'Customer';
  customer @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Customers', element: 'ID', labelElement: 'name' }];
};

annotate AdminService.Orders with @UI: {
  HeaderInfo: {
    TypeName: 'Order',
    TypeNamePlural: 'Orders',
    Title: { Value: ID }
  },
  Identification: [
    { Value: ID }
  ],
  LineItem: [
    { Value: ID },
    { Value: customer, Label: 'Customer' },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Order Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ ID, customer, status ]
};

annotate AdminService.OrderItems with {
  parent @title: 'Order';
  parent @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Orders', element: 'ID', labelElement: 'ID' }];
  book @title: 'Book';
  book @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Books', element: 'ID', labelElement: 'title' }];
};

annotate AdminService.OrderItems with @UI: {
  HeaderInfo: {
    TypeName: 'Order Item',
    TypeNamePlural: 'Order Items',
    Title: { Value: parent }
  },
  Identification: [
    { Value: parent },
    { Value: lineNo }
  ],
  LineItem: [
    { Value: parent, Label: 'Order' },
    { Value: lineNo },
    { Value: book, Label: 'Book' },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Order Item', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ parent, book ]
};

annotate AdminService.Returns with {
  orderItem @title: 'Order Item';
  orderItem @Consumption.valueHelpDefinition: [{ entity: 'AdminService.OrderItems', element: 'parent' }];
};

annotate AdminService.Returns with @UI: {
  HeaderInfo: {
    TypeName: 'Return',
    TypeNamePlural: 'Returns',
    Title: { Value: ID }
  },
  Identification: [
    { Value: ID }
  ],
  LineItem: [
    { Value: ID },
    { Value: orderItem, Label: 'Order Item' },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Return Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ status ]
};

annotate AdminService.Publishers with @UI: {
  HeaderInfo: {
    TypeName: 'Publisher',
    TypeNamePlural: 'Publishers',
    Title: { Value: name }
  },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Publisher Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.Categories with @UI: {
  HeaderInfo: {
    TypeName: 'Category',
    TypeNamePlural: 'Categories',
    Title: { Value: name }
  },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Category Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.Formats with @UI: {
  HeaderInfo: {
    TypeName: 'Format',
    TypeNamePlural: 'Formats',
    Title: { Value: name }
  },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Format Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.Tags with @UI: {
  HeaderInfo: {
    TypeName: 'Tag',
    TypeNamePlural: 'Tags',
    Title: { Value: name }
  },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Tag Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ name ]
};

annotate AdminService.BookTags with {
  book @title: 'Book';
  book @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Books', element: 'ID', labelElement: 'title' }];
  tag @title: 'Tag';
  tag @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Tags', element: 'ID', labelElement: 'name' }];
};

annotate AdminService.BookTags with @UI: {
  HeaderInfo: {
    TypeName: 'Book Tag',
    TypeNamePlural: 'Book Tags',
    Title: { Value: book }
  },
  Identification: [
    { Value: book },
    { Value: tag }
  ],
  LineItem: [
    { Value: book, Label: 'Book' },
    { Value: tag, Label: 'Tag' }
  ],
  FieldGroup #General: {
    $Type: 'UI.FieldGroupType',
    Data: [
      { $Type: 'UI.DataField', Value: book },
      { $Type: 'UI.DataField', Value: tag }
    ]
  },
  Facets: [
    { $Type: 'UI.ReferenceFacet', Label: 'Book Tag', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ book, tag ]
};

annotate AdminService.Reviews with {
  book @title: 'Book';
  book @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Books', element: 'ID', labelElement: 'title' }];
  customer @title: 'Customer';
  customer @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Customers', element: 'ID', labelElement: 'name' }];
};

annotate AdminService.Reviews with @UI: {
  HeaderInfo: {
    TypeName: 'Review',
    TypeNamePlural: 'Reviews',
    Title: { Value: ID }
  },
  Identification: [
    { Value: ID }
  ],
  LineItem: [
    { Value: ID },
    { Value: book, Label: 'Book' },
    { Value: customer, Label: 'Customer' },
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
    { $Type: 'UI.ReferenceFacet', Label: 'Review Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ book, customer ]
};

annotate AdminService.Promotions with {
  book @title: 'Book';
  book @Consumption.valueHelpDefinition: [{ entity: 'AdminService.Books', element: 'ID', labelElement: 'title' }];
};

annotate AdminService.Promotions with @UI: {
  HeaderInfo: {
    TypeName: 'Promotion',
    TypeNamePlural: 'Promotions',
    Title: { Value: description }
  },
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
    { Value: book, Label: 'Book' }
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
    { $Type: 'UI.ReferenceFacet', Label: 'Promotion Details', Target: '@UI.FieldGroup#General' }
  ],
  SelectionFields: [ description, discountCode, book ]
};

