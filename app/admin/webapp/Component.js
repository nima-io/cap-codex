sap.ui.define([
  "sap/ui/core/UIComponent",
], function (UIComponent) {
  "use strict";

  /**
   * Root component of the admin UI application.
   */
  return UIComponent.extend("admin.Component", {
    metadata: {
      manifest: "json",
    },

    /**
     * Initializes the component and starts the router.
     */
    init: function () {
      UIComponent.prototype.init.apply(this, arguments);
      this.getRouter().initialize();
    },
  });
});

