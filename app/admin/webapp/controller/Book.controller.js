sap.ui.define([
  "sap/ui/core/mvc/Controller"
], function(Controller) {
  "use strict";

  function generateUUID() {
    return (typeof crypto !== "undefined" && crypto.randomUUID)
      ? crypto.randomUUID()
      : "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
          const r = Math.random() * 16 | 0;
          const v = c === "x" ? r : (r & 0x3 | 0x8);
          return v.toString(16);
        });
  }

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
        ID: generateUUID(),
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

