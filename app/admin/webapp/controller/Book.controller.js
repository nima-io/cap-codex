sap.ui.define([
  "sap/ui/core/mvc/Controller"
], function(Controller) {
  "use strict";

  return Controller.extend("admin.controller.Book", {
    onInit: function() {
      const oRouter = this.getOwnerComponent().getRouter();
      oRouter.getRoute("bookDetail").attachPatternMatched(this._onObjectMatched, this);
      oRouter.getRoute("bookCreate").attachPatternMatched(this._onCreateMatched, this);
    },

    _onObjectMatched: function(oEvent) {
      const id = oEvent.getParameter("arguments").ID;
      const path = `/Books(ID=guid'${id}',IsActiveEntity=true)`;
      this.getView().bindElement({ path });
    },

    _onCreateMatched: function() {
      const oModel = this.getView().getModel();
      const oListBinding = oModel.bindList("/Books");
      const oContext = oListBinding.create({ IsActiveEntity: true });
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

