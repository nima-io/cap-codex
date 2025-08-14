using { bookshop as db } from '../db/schema';

@protocol: 'odata-v4'
service AdminService {
  @odata.draft.enabled
  @odata.draft.bypass
  entity Authors   as projection on db.Authors;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Books     as projection on db.Books;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Customers as projection on db.Customers actions {
    action contact(subject : String, message : String) returns String;
  };
  @odata.draft.enabled
  @odata.draft.bypass
  entity Orders    as projection on db.Orders;
  @odata.draft.enabled
  @odata.draft.bypass
  entity OrderItems as projection on db.OrderItems actions {
    action requestReturn(reason : String) returns Returns;
  };
  @odata.draft.enabled
  @odata.draft.bypass
  entity Returns as projection on db.Returns;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Publishers as projection on db.Publishers;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Categories as projection on db.Categories;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Formats as projection on db.Formats;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Tags as projection on db.Tags;
  @odata.draft.enabled
  @odata.draft.bypass
  entity BookTags as projection on db.BookTags;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Reviews as projection on db.Reviews;
  @odata.draft.enabled
  @odata.draft.bypass
  entity Promotions as projection on db.Promotions;
}
