({
    OutOfScopeData : function(component, event, helper) {
        component.find("saveDisable").set('v.disabled',true);
        component.find("saveAndCloseDisable").set('v.disabled',true);
        component.set('v.showSpinner',true);
        var projectId = component.get("v.proId");
        var tierTypeValue = component.get("v.tierType");
        var funAreaLabel = component.get("v.functionalAreaLabel");
        var action  = component.get("c.searchRequirements");
        action.setParams({
            projectId : projectId,
            tierType : tierTypeValue,
            functionalArea : funAreaLabel
        });
        action.setCallback(this, function(response) {
            var state = response.getState();  
            if (state === "SUCCESS") {   
                var results = response.getReturnValue();
                if(results != null && results.length > 0){
                    for(var i = 0; i < results.length; i++){
                        if(results[i].loggedInUser.Name == $A.get("$Label.c.Fonteva_Profile")){
                            component.set("v.displayForFontevan" , true);
                        }
                    }
                    component.set('v.showSpinner',false);
                    
                    component.set("v.requirementoutofscopeList", results);
                }else{
                    /* display an error*/
                    component.set('v.showSpinner',false);
                    component.set("v.displayError",true);
                    component.set("v.displayErrorText", $A.get("$Label.c.No_Record_Found"));
                    
                }
            }
        });
        $A.enqueueAction(action); 
    },
    goToPrevious : function(component, event, helper) {
        var cmpEventData = component.getEvent("cancelEvent"); 
        cmpEventData.setParams({ }); 
        cmpEventData.fire(); 
    },
    saveRecords : function(component, event, helper) {
        
        var recordIdsNew = component.get("v.toBeDiscussList");
        var recordIdsTentative = component.get("v.inScopeTentativeList");
        var recordIdsUndetermined = component.get("v.inScopeUndeterminedList");
        if(recordIdsNew.length > 0){
            helper.saveStatusNew(component, event, helper); 
        }
        if(recordIdsTentative.length > 0){
            helper.saveStatusInScopeTentative(component, event, helper);
        }
        if(recordIdsUndetermined.length > 0){
            helper.saveStatusInScopeUndetermined(component, event, helper);
        }
    },
    saveStatusNew : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var tierTypeValue = component.get("v.tierType");
        var recordIds = component.get("v.toBeDiscussList");
        var funAreaLabel = component.get("v.functionalAreaLabel");
        if(recordIds.length >  0){
            var projectId = component.get("v.proId");
            var action = component.get('c.updateStatus');
            action.setParams({
                reqIds : recordIds,
                projectIds : projectId,
                tierType : tierTypeValue,
                functionalArea : funAreaLabel
            });
            action.setCallback(this,function(response){
                var state = response.getState(); 
                if (state === "SUCCESS") { 
                    component.set("v.showSpinner",false);
                    var results = response.getReturnValue();
                    component.set("v.requirementoutofscopeList",results);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: $A.get("$Label.c.Success_Message_Label"),
                        type: 'Success'   
                    });
                    toastEvent.fire();
                    if(results === null){
                        component.set("v.showSpinner",false);
                        var cmpEventData = component.getEvent("cancelEvent"); 
                        cmpEventData.setParams({ }); 
                        cmpEventData.fire(); 
                    }
                }              
            });
            $A.enqueueAction(action);   
        }else{
            component.set("v.showSpinner",false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: $A.get("$Label.c.Select_Any_Requirement"),
                type: 'Error'   
            });
            toastEvent.fire();
        }
        
    },
    saveStatusInScopeTentative : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var tierTypeValue = component.get("v.tierType");
        var recordIds = component.get("v.inScopeTentativeList");
        var funAreaLabel = component.get("v.functionalAreaLabel");
        var statusMap = component.get("v.buttonStatusMap"); 
        if(recordIds.length >  0){
            var projectId = component.get("v.proId");
            var action = component.get('c.updateStatusInscopeNew');
            action.setParams({
                reqIds : recordIds,
                projectIds : projectId,
                tierType : tierTypeValue,
                functionalArea : funAreaLabel,
                stMap : statusMap
            });
            action.setCallback(this,function(response){
                var state = response.getState(); 
                if (state === "SUCCESS") { 
                    component.set("v.showSpinner",false);
                    var results = response.getReturnValue();
                    component.set("v.requirementoutofscopeList",results);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: $A.get("$Label.c.Success_Message_Label"),
                        type: 'Success'   
                    });
                    toastEvent.fire();
                    if(results === null){
                        component.set("v.showSpinner",false);
                        var cmpEventData = component.getEvent("cancelEvent"); 
                        cmpEventData.setParams({ }); 
                        cmpEventData.fire(); 
                    }
                }              
            });
            $A.enqueueAction(action);   
        }else{
            component.set("v.showSpinner",false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: $A.get("$Label.c.Select_Any_Requirement"),
                type: 'Error'   
            });
            toastEvent.fire();
        }
        
    },
    saveStatusInScopeUndetermined : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var tierTypeValue = component.get("v.tierType");
        var recordIds = component.get("v.inScopeUndeterminedList");
        var funAreaLabel = component.get("v.functionalAreaLabel");
        var statusMap = component.get("v.buttonStatusMap"); 
        if(recordIds.length >  0){
            var projectId = component.get("v.proId");
            var action = component.get('c.updateStatusInscopeNew');
            action.setParams({
                reqIds : recordIds,
                projectIds : projectId,
                tierType : tierTypeValue,
                functionalArea : funAreaLabel,
                stMap : statusMap
            });
            action.setCallback(this,function(response){
                var state = response.getState(); 
                if (state === "SUCCESS") { 
                    component.set("v.showSpinner",false);
                    var results = response.getReturnValue();
                    component.set("v.requirementoutofscopeList",results);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: $A.get("$Label.c.Success_Message_Label"),
                        type: 'Success'   
                    });
                    toastEvent.fire();
                    if(results === null){
                        component.set("v.showSpinner",false);
                        var cmpEventData = component.getEvent("cancelEvent"); 
                        cmpEventData.setParams({ }); 
                        cmpEventData.fire(); 
                    }
                }              
            });
            $A.enqueueAction(action);   
        }else{
            component.set("v.showSpinner",false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: $A.get("$Label.c.Select_Any_Requirement"),
                type: 'Error'   
            });
            toastEvent.fire();
        }
        
    }
})