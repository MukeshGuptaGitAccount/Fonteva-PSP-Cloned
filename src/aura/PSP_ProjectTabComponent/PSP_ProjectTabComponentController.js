({
    doInit : function(component, event, helper) {
        
        var projectId = component.get("v.parentProjectId");
        var action = component.get("c.getProject");
        action.setParams({
            recordId : projectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();  
            if (state === "SUCCESS") {
                helper.getProfile(component,event,helper);
                component.set("v.impProject", response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        var action = component.get("c.getFunctionalArea");
        action.setParams({
            recordId : projectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();  
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result != null){
                    component.set("v.selectedSkillsItems", result);
                }
            }
        });
        
        $A.enqueueAction(action); 
    },
    showFunctionalityArea : function(component,event) {
        component.set('v.showSpinner',true);
        component.set("v.displayFunctionalityArea",true);
        component.set("v.showTierAssignmentComponent",false);
        component.set("v.showComp",true);
        component.set('v.showSpinner',false);
        
    },
    handleCmpEvent: function(component ,event ) {
        var functionalityAreaList = event.getParam("selectedFunctionalityArea"); 
        component.set("v.showComp",false);
        component.set("v.selectedSkillsItems",functionalityAreaList);
        component.set("v.displayFunctionalityArea",false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success:",
            "message":  $A.get("$Label.c.Success_Message_Label"),
            "type": "success"
        });
        toastEvent.fire();
        
    },
    handleCancelEvent: function(component ,event ) {
        
        component.set("v.displayFunctionalityArea",false);
        component.set("v.showComp",false);
    },
    getTierAssignment : function(component ,event,helper ) {
        var targetFunctionalArea = event.getSource().get("v.name");
        component.set("v.funAreaLabel",targetFunctionalArea);
        component.set("v.showTierAssignmentComponent",true);
        component.set("v.showComp",true);   
    },
    
    backTofunctionalArea : function(component ,event,helper ) {
        component.set("v.showTierAssignmentComponent",false);
        component.set("v.showComp",false);  
        
    }
})