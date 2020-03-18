({
    updaterecordMethod : function(component, event) {
        component.find("saveAndClose").set("v.disabled",true);
        component.find("save").set("v.disabled",true);
        var action = component.get('c.updateInscopeRecords');
        var reqList = component.get("v.requirementInscopeListUpdate");
        action.setParams({
            reqRecords : reqList
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                var results = response.getReturnValue();
                if(results != null && results.length > 0){
                    for(var j = 0 ;j < results.length; j++){
                        component.set("v.parentreqId" ,results[j].Parent_Requirement__c);
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: $A.get("$Label.c.Success_Message_Label"),
                        type: 'Success'
                    });
                    toastEvent.fire()
                }
                var recordList = component.get('v.requirementInscopeList');
                for(var i = 0; i < recordList.length; i++){
                    recordList[i].enable = false;
                }
                component.set("v.requirementInscopeList" , recordList);
                component.set("v.requirementInscopeListUpdate" , []);
                component.set('v.showSpinner',false);
            }     
        });
        $A.enqueueAction(action); 
    },
    updaterecordStatusMethod : function(component, event) {
        component.find("saveAndClose").set("v.disabled",true);
        component.find("save").set("v.disabled",true);
        var recordIds = component.get("v.neededList");
        var statusMap = component.get("v.buttonStatusMap");
        var action = component.get('c.updateInscopeRecords');
        action.setParams({
            reqRecords : recordIds,
            stMap : statusMap
        });
        action.setCallback(this,function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") { 
                var results = response.getReturnValue();
                if(results != null && results.length > 0){
                    for(var j = 0 ;j < results.length; j++){
                        var recordList = component.get('v.requirementInscopeList');
                        for(var i = 0; i < recordList.length; i++){
                            if(recordList[i].req.Id == results[j].Id){
                                recordList[i].req.Status__c = statusMap[results[j].Id];
                            }
                        }
                    }
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: $A.get("$Label.c.Success_Message_Label"),
                        type: 'Success'
                    });
                    toastEvent.fire()
                }
                component.set("v.requirementInscopeList" , recordList);
                component.set('v.showSpinner',false);
            }
            component.set("v.neededList" , []);
        });
        $A.enqueueAction(action); 
    },
    updaterecordFeedbackMethod : function(component, event) {
        component.find("saveAndClose").set("v.disabled",true);
        component.find("save").set("v.disabled",true);
        var action = component.get('c.updateInscopeRecords');
        var reqList = component.get("v.requirementInscopeListFeedbackUpdate");
        action.setParams({
            reqRecords : reqList
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") { 
                var results = response.getReturnValue();
                if(results != null && results.length > 0){
                    for(var j = 0 ;j < results.length; j++){
                        component.set("v.parentreqId" ,results[j].Parent_Requirement__c);
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: $A.get("$Label.c.Success_Message_Label"),
                        type: 'Success' 
                    });
                    toastEvent.fire()
                }
                var recordList = component.get('v.requirementInscopeList');
                for(var i = 0; i < recordList.length; i++){
                    recordList[i].enableFeedback = false;
                }
                component.set("v.requirementInscopeList" , recordList);
                component.set('v.showSpinner',false);
            } 
            component.set("v.requirementInscopeListFeedbackUpdate" , []);
        });
        $A.enqueueAction(action);
    },
    showInScopeData : function(component, event) {
        component.find("saveAndClose").set("v.disabled",true);
        component.find("save").set("v.disabled",true);
        var action  = component.get("c.searchChildRequirementsInScope");
        var reqId = component.get("v.reqId");
        var fnlArea = component.get("v.functionalAreaLabel");
        var tierValue = component.get("v.tierFilter");
        var accessProfiles = $A.get("$Label.c.Fonteva_Profile");
        var listofaccessProfiles = accessProfiles.split(",");
        action.setParams({
            reqId : reqId,
            functionalArea : fnlArea,
            tierFilter : tierValue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                if(results != null && results.length > 0){
                    for(var i = 0; i < results.length; i++){
                        for(var j=0;i<listofaccessProfiles.length;j++){
                            if(results[i].loggedInUser.Name == listofaccessProfiles[j]){
                                component.set("v.displayEditButton" , true);
                            }
                            break;
                        }
                        if(results[i].req.Core_Req__c == true && results[i].req.Status__c == $A.get("$Label.c.In_Scope_Approved")){
                            results[i].enableCoreRequirement = true;
                        }
                    }
                    component.set('v.showSpinner',false);
                    component.set("v.requirementInscopeList", results);
                }else{
                    /* display an error*/
                    component.set("v.displayError",true);
                    component.set("v.displayErrorText", $A.get("$Label.c.No_Record_Found"));
                }
            }
            
        });
        $A.enqueueAction(action); 
    },
    saveReq :function(component, event ,helper){  
        
        component.set('v.showSpinner',true);
        var recordIds = component.get("v.neededList");
        var reqList = component.get("v.requirementInscopeListUpdate");
        var reqListFeedback = component.get("v.requirementInscopeListFeedbackUpdate");
        var statusMap = component.get("v.buttonStatusMap");
        if(reqList.length > 0){
            helper.updaterecordMethod(component ,event);
        }
        if(reqListFeedback.length > 0){
            helper.updaterecordFeedbackMethod(component ,event);
        }
        if(statusMap != null){
            helper.updaterecordStatusMethod(component ,event);
        }
        //TO-DO----Need to merge all above helper methods ane remove setTimeout
          setTimeout(function(){ helper.showInScopeData(component, event); }, 2000);
     
    }
})