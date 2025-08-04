namespace bookshop;

using { cuid, managed } from '@sap/cds/common';

entity Authors : managed {
  key ID : UUID = cuid();
  name   : String(100);
  books  : Composition of many Books on books.author = $self;
}

entity Books : managed {
  key ID : UUID = cuid();
  title  : String(255);
  stock  : Integer;
  price  : Decimal(9,2);
  author : Association to Authors;
}

entity Customers : managed {
  key ID : UUID = cuid();
  name   : String(100);
  email  : String(255);
  orders : Composition of many Orders on orders.customer = $self;
}

entity Orders : managed {
  key ID : UUID = cuid();
  customer : Association to Customers;
  items  : Composition of many OrderItems on items.parent = $self;
}

entity OrderItems : managed {
  key parent : Association to Orders;
  key lineNo : Integer;
  book : Association to Books;
  quantity : Integer;
  netAmount : Decimal(9,2);
}

