namespace bookshop;

using { cuid, managed } from '@sap/cds/common';

type LoyaltyTier : String enum {
  BRONZE;
  SILVER;
  GOLD;
  PLATINUM;
}

type ReturnStatus : String enum {
  REQUESTED;
  APPROVED;
  REJECTED;
  REFUNDED;
}

entity Authors : managed {
  key ID : UUID;
  name   : String(100);
  royaltyRate : Decimal(5,2) default 0;
  totalSales  : Decimal(15,2) default 0;
  totalRoyalty : Decimal(15,2) default 0;
  books  : Composition of many Books on books.author = $self;
}

entity Publishers : managed {
  key ID : UUID;
  name : String(100);
}

entity Categories : managed {
  key ID : UUID;
  name : String(100);
}

entity Tags : managed {
  key ID : UUID;
  name : String(100);
}

entity Formats : managed {
  key ID : UUID;
  name : String(50);
}

entity Books : managed {
  key ID : UUID;
  title  : String(255);
  stock  : Integer;
  price  : Decimal(9,2);
  author : Association to Authors;
  publisher : Association to Publishers;
  category : Association to Categories;
  format : Association to Formats;
  isFeatured : Boolean default false;
  bestsellerRank : Integer;
  tags : Composition of many BookTags on tags.book = $self;
  reviews : Composition of many Reviews on reviews.book = $self;
}

entity BookTags : managed {
  key book : Association to Books;
  key tag  : Association to Tags;
}

entity Customers : managed {
  key ID : UUID;
  name   : String(100);
  email  : String(255);
  phone  : String(20);
  loyaltyTier : LoyaltyTier default 'BRONZE';
  orders : Composition of many Orders on orders.customer = $self;
}

entity Reviews : managed {
  key ID : UUID;
  book : Association to Books;
  customer : Association to Customers;
  rating : Integer;
  comment : String(500);
}

entity Promotions : managed {
  key ID : UUID;
  description : String(255);
  discountCode : String(20);
  discountPercentage : Decimal(5,2);
  startDate : Date;
  endDate : Date;
  book : Association to Books;
}

entity Returns : managed {
  key ID : UUID;
  orderItem : Association to OrderItems;
  reason : String(255);
  status : ReturnStatus default 'REQUESTED';
  refundAmount : Decimal(9,2);
}

type OrderStatus : String enum {
  NEW;
  PROCESSING;
  SHIPPED;
  CANCELLED;
}

entity Orders : managed {
  key ID : UUID;
  customer : Association to Customers;
  items  : Composition of many OrderItems on items.parent = $self;
  status : OrderStatus default 'NEW';
}

entity OrderItems : managed {
  key parent : Association to Orders;
  key lineNo : Integer;
  book : Association to Books;
  quantity : Integer;
  netAmount : Decimal(9,2);
}

entity Departments : managed {
  key ID : UUID;
  name   : String(100);
  employees : Composition of many Employees on employees.department = $self;
}

entity Employees : managed {
  key ID : UUID;
  firstName : String(100);
  lastName  : String(100);
  email     : String(255);
  department: Association to Departments;
}

