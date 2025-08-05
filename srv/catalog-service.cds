using { bookshop as db } from '../db/schema';

@protocol: 'odata-v4'
service CatalogService {
  entity Authors   as projection on db.Authors;
  entity Books     as projection on db.Books;
  entity Customers as projection on db.Customers;
  entity Orders    as projection on db.Orders;
  entity OrderItems as projection on db.OrderItems;
  entity Publishers as projection on db.Publishers;
  entity Categories as projection on db.Categories;
  entity Formats as projection on db.Formats;
  entity Tags as projection on db.Tags;
  entity Reviews as projection on db.Reviews;
  entity Promotions as projection on db.Promotions;
}
