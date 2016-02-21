({
	displayOpportunities: function(component, event, helper) {
		console.log($A.get("e.c:displayopp"));
		var userkey = component.get('v.salesUser.userId');
		console.log(userkey);
		var userevent = $A.get("e.c:displayopp");
        userevent.setParams({ "userId":  userkey});
        userevent.fire();
	}
})