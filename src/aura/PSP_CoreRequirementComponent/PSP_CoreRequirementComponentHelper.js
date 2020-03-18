({
    doInit : function(component, event, helper) {
       var reqId = component.get("v.reqId");
        var action = component.get("c.coreRequirementRecord");
        action.setParams({
            reqId : reqId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();  
            if (state === "SUCCESS") {
                component.set("v.coreRequirement", response.getReturnValue());
            }
        });
         $A.enqueueAction(action);  
    },
    saveFunction : function(component, event, helper) {
       
        component.set('v.showSpinner',true);
        var reqRecord = component.get("v.coreRequirement");
        var action = component.get("c.updateCoreRequirement");
        action.setParams({
            reqRecord : reqRecord
        });
        action.setCallback(this, function(response) {
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result != null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: $A.get("$Label.c.Success_Message_Label"),
                        type: 'Success'
                    });
                    toastEvent.fire()
                }
                component.set('v.showSpinner',false);
                component.set("v.coreRequirement", result);
            }
        });
        $A.enqueueAction(action);	     
    }
})