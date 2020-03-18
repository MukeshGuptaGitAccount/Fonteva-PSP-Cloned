({
    doInit : function(component, event, helper) {
        component.set("v.selectedSkillsItems" , component.get("v.selectedFunctionalArea")); 
        var impProjectId = component.get("v.projectId");
        var action = component.get("c.getAllFunctionalArea");
        action.setParams({
            recordId : impProjectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();  
            var allValues = response.getReturnValue();
            component.set('v.allFunArea',allValues);
            var opts = [];
            for (var i = 0; i < allValues.length; i++) {
                opts.push({
                    label: allValues[i],
                    value: allValues[i]
                });
            }
            component.set("v.listSkillsOptions", opts);  
        });
        $A.enqueueAction(action);   
    },
    handleChange: function (component, event) {
        var selectedOptionsList = event.getParam("value"); 
        var test = event.getSource().get('v.value');
        component.set("v.selectedSkillsItems" , selectedOptionsList); 
    },
    save : function(component,event,helper){
        component.set('v.showSpinner',true);
        var nonSelectedFunArea = component.get("v.allFunArea"); 
        var selectedFunArea = component.get("v.selectedSkillsItems");
        var index;
        for (var i=0; i<selectedFunArea.length; i++) {
            index = nonSelectedFunArea.indexOf(selectedFunArea[i]);
            if (index > -1) {
                nonSelectedFunArea.splice(index, 1);
            }
        }
        var impProjectId = component.get("v.projectId");
        
        var action=  component.get("c.uponSaving");
        action.setParams({
            funArea: selectedFunArea,
            recordId : impProjectId,
            nonFunctionalArea : nonSelectedFunArea
        });
        action.setCallback(this, function(response) {
            var state = response.getState();  
            if (state === "SUCCESS") { 
                var result = response.getReturnValue();
                if(result != null && result.length > 0){
                    component.set('v.showSpinner',false);
                    /* Firing an Event PSP_ProjectTabComponent component to display toast and displaying button with selected functional area */
                    var cmpEventData = component.getEvent("cmpEvent"); 
                    cmpEventData.setParams({
                        selectedFunctionalityArea :selectedFunArea 
                    }); 
                    cmpEventData.fire(); 
                } else{
                    component.set('v.showSpinner',false);
                    var cmpEventData = component.getEvent("cmpEvent"); 
                    cmpEventData.setParams({
                        selectedFunctionalityArea :selectedFunArea 
                    }); 
                    cmpEventData.fire(); 
                }
            }
        });
        $A.enqueueAction(action); 
    },
    cancelFunction : function(component,event,helper){
        var cmpEventData = component.getEvent("cancelEvent"); 
        cmpEventData.setParams({ }); 
        cmpEventData.fire(); 
        
    }
})