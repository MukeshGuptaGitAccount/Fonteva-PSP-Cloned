({
    getProfile : function(component,event,helper) {
        var accessProfiles = $A.get("$Label.c.Fonteva_Profile");
        var listofaccessProfiles = accessProfiles.split(",");
        var action = component.get("c.getProfile");
        action.setParams({});
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                for(var i=0;i<listofaccessProfiles.length;i++){
                    if(results.Name == listofaccessProfiles[i]){
                        console.log(listofaccessProfiles[i]);
                        component.set('v.displayAddFunctionlityLink' , true);
                    }
                    break;
                }
            }
        });
        $A.enqueueAction(action);
    }
})