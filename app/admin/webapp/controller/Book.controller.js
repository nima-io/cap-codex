sap.ui.define([
  "sap/ui/core/mvc/Controller",
  "sap/base/strings/uuid/v4"
], function(Controller, uuidv4) {
  "use strict";

  return Controller.extend("admin.controller.Book", {
    onInit: function() {
      const oRouter = this.getOwnerComponent().getRouter();
      oRouter.getRoute("bookDetail").attachPatternMatched(this._onObjectMatched, this);
      oRouter.getRoute("bookCreate").attachPatternMatched(this._onCreateMatched, this);
    },

    _onObjectMatched: function(oEvent) {
      const id = oEvent.getParameter("arguments").ID;
      this.getView().bindElement({ path: `/Books(${id})` });
    },

    _onCreateMatched: function() {
      const oModel = this.getView().getModel();
      const oListBinding = oModel.bindList("/Books");
      const oContext = oListBinding.create({
        ID: uuidv4(),
        IsActiveEntity: true
      });
      this.getView().setBindingContext(oContext);
    },

    onSave: function() {
      this.getView().getModel().submitBatch("$auto").then(() => {
        this.onNavBack();
      });
    },

    onDelete: function() {
      const oContext = this.getView().getBindingContext();
      if (oContext) {
        oContext.delete("$auto").then(() => {
          this.getView().getModel().submitBatch("$auto").then(() => {
            this.onNavBack();
          });
        });
      }
    },

    onNavBack: function() {
      this.getOwnerComponent().getRouter().navTo("main");
    }
  });
});

