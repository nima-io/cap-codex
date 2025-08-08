sap.ui.define([
  "sap/ui/core/mvc/Controller",
], function (Controller) {
  "use strict";

  /**
   * Controller for the book detail and creation views.
   */
  return Controller.extend("admin.controller.Book", {
    /**
     * Attach route handlers for detail and creation flows on initialization.
     */
    onInit: function () {
      const oRouter = this.getOwnerComponent().getRouter();
      oRouter.getRoute("bookDetail").attachPatternMatched(this._onObjectMatched, this);
      oRouter.getRoute("bookCreate").attachPatternMatched(this._onCreateMatched, this);
    },

    /**
     * Bind the view to an existing book when its route is matched.
     *
     * @param {sap.ui.base.Event} oEvent the route match event
     */
    _onObjectMatched: function (oEvent) {
      const id = oEvent.getParameter("arguments").ID;
      this.getView().bindElement({ path: `/Books(${id})` });
    },

    /**
     * Prepare a new book context when navigating to the creation route.
     */
    _onCreateMatched: function () {
      const oModel = this.getView().getModel();
      const oListBinding = oModel.bindList("/Books");
      const oContext = oListBinding.create({
        IsActiveEntity: true,
      });
      this.getView().setBindingContext(oContext);
    },

    /**
     * Submit the changes and navigate back to the list view.
     */
    onSave: function () {
      this.getView()
        .getModel()
        .submitBatch("$auto")
        .then(() => {
          this.onNavBack();
        });
    },

    /**
     * Delete the current book and return to the list.
     */
    onDelete: function () {
      const oContext = this.getView().getBindingContext();
      if (oContext) {
        oContext
          .delete("$auto")
          .then(() => {
            this.getView()
              .getModel()
              .submitBatch("$auto")
              .then(() => {
                this.onNavBack();
              });
          });
      }
    },

    /**
     * Navigate back to the main list of books.
     */
    onNavBack: function () {
      this.getOwnerComponent().getRouter().navTo("main");
    },
  });
});

