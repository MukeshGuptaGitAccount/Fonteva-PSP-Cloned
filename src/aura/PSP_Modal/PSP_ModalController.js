({
    doInit: function(component, event, helper) {
        component.set("v.isModalOpen", true);
        var re= component.get('v.projectList'); 
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    submitDetails: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    getRecordId : function(component,event, helper) {
        var impProjectId = event.getSource().get('v.value');
        var profileName = component.get('v.profile');
        if(profileName === $A.get("$Label.c.User_Profile")){
            component.set("v.showSearchComponent", true);
            component.set("v.isModalOpen", false);
        }else{
            var action = component.get("c.searchRequirements");
            action.setParams({
                projectId : impProjectId
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state == "SUCCESS"){ 
                    var result = response.getReturnValue();
                    if(result != null && result.length > 0){
                        component.set("v.isModalOpen", false);
                        component.set("v.projectId", impProjectId);
                        component.set("v.showProjectTabComponent", true);  
                    }
                }
            });
            $A.enqueueAction(action) 
        }
    } 
})