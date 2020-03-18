({
	doInit : function(component, event, helper) {
        helper.doInit(component ,event ,helper);
    },
    editFunction : function(component,event,helper){
        var reqId = component.get("v.reqId");
        component.set("v.editCoreReq" , false);
    },
    saveFunction : function(component,event,helper){
		helper.saveFunction(component ,event ,helper);
        component.set("v.editCoreReq" , true);
    }
})