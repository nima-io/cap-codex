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
  books  : Association to many Books on books.author = $self;
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
  author : Association to Authors not null;
  publisher : Association to Publishers not null;
  category : Association to Categories not null;
  format : Association to Formats not null;
  isFeatured : Boolean default false;
  bestsellerRank : Integer;
  tags : Association to many BookTags on tags.book = $self;
  reviews : Association to many Reviews on reviews.book = $self;
}

entity BookTags : managed {
  key book : Association to Books not null;
  key tag  : Association to Tags not null;
}

entity Customers : managed {
  key ID : UUID;
  name   : String(100);
  email  : String(255) not null @assert.unique;
  phone  : String(20);
  loyaltyTier : LoyaltyTier default 'BRONZE';
  orders : Association to many Orders on orders.customer = $self;
}

entity Reviews : managed {
  key ID : UUID;
  book : Association to Books not null;
  customer : Association to Customers not null;
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
  book : Association to Books not null;
}

entity Returns : managed {
  key ID : UUID;
  orderItem : Association to OrderItems not null;
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
  customer : Association to Customers not null;
  items  : Association to many OrderItems on items.parent = $self;
  status : OrderStatus default 'NEW';
}

entity OrderItems : managed {
  key parent : Association to Orders;
  key lineNo : Integer;
  book : Association to Books not null;
  quantity : Integer not null;
  netAmount : Decimal(9,2);
}
