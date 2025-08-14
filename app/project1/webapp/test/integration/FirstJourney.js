sap.ui.define([
    "sap/ui/test/opaQunit",
    "sap/ui/test/Opa5",
    "sap/ui/test/matchers/PropertyStrictEquals"
], function (opaTest, Opa5, PropertyStrictEquals) {
    "use strict";

    var Journey = {
        run: function () {
            QUnit.module("First journey");

            opaTest("Start application", function (Given, When, Then) {
                Given.iStartMyApp();
                Then.onTheBooksList.iSeeThisPage();
            });

            opaTest("List shows author name", function (Given, When, Then) {
                When.onTheBooksList.onFilterBar().iExecuteSearch();
                Then.onTheBooksList.onTable().iCheckRows();

                Then.waitFor({
                    controlType: "sap.m.Label",
                    matchers: new PropertyStrictEquals({ name: "text", value: "Author" }),
                    success: function () {
                        Opa5.assert.ok(true, "Author column present");
                    },
                    errorMessage: "Author column not found"
                });

                Then.waitFor({
                    controlType: "sap.m.Text",
                    matchers: new PropertyStrictEquals({ name: "text", value: "Primo Levi" }),
                    success: function () {
                        Opa5.assert.ok(true, "Author name displayed");
                    },
                    errorMessage: "Author name not found in list"
                });
            });

            opaTest("Author value help allows selection", function (Given, When, Then) {
                When.onTheBooksList.onTable().iPressRow(0);
                Then.onTheBooksObjectPage.iSeeThisPage();

                When.onTheBooksObjectPage.onField("author_ID").iOpenValueHelp();

                Then.waitFor({
                    controlType: "sap.m.StandardListItem",
                    searchOpenDialogs: true,
                    matchers: new PropertyStrictEquals({ name: "title", value: "Jane Austen" }),
                    success: function (items) {
                        items[0].firePress();
                    },
                    errorMessage: "Author not offered in value help"
                });

                Then.waitFor({
                    controlType: "sap.m.Input",
                    matchers: new PropertyStrictEquals({ name: "value", value: "Jane Austen" }),
                    success: function () {
                        Opa5.assert.ok(true, "Author chosen");
                    },
                    errorMessage: "Author was not selected"
                });
            });

            opaTest("Teardown", function (Given, When, Then) {
                Given.iTearDownMyApp();
            });
        }
    };

    return Journey;
});

