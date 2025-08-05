sap.ui.define([
  "sap/ui/core/mvc/Controller"
], function(Controller) {
  "use strict";

  return Controller.extend("admin.controller.Main", {
    onSave: function() {
      this.getView().getModel().submitBatch("$auto");
    }
  });
});
