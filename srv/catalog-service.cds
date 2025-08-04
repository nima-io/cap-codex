using { bookshop as db } from '../db/schema';

@protocol: 'odata-v4'
service CatalogService {
  entity Authors   as projection on db.Authors;
  entity Books     as projection on db.Books;
  entity Customers as projection on db.Customers;
  entity Orders    as projection on db.Orders;
  entity OrderItems as projection on db.OrderItems;
}
