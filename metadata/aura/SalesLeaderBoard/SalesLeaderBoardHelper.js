({
	setdashboard: function(component) {
		var action = component.get("c.getSLDashboardData");
			var self = this;
			action.setCallback(this, function(response) {
			var state = response.getState();
			console.log('STATE'+response.getReturnValue());
				if (component.isValid() && state === "SUCCESS") {
					component.set("v.lstsalesUser",response.getReturnValue());
				}else if (state === "ERROR") {
	                var errors = response.getError();
	                if (errors) {
	                    $A.logf("Errors", errors);
	                    if (errors[0] && errors[0].message) {
	                        $A.error("Error message: " +
	                                 errors[0].message);
	                    }
	                } else {
	                    $A.error("Unknown error");
	                }
                }
			});
		$A.enqueueAction(action);
	}
})