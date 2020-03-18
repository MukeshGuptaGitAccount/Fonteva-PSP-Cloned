({
    doInit : function(component, event, helper) {
        var action = component.get("c.getProfileAndProject");
        action.setParams({ });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){ 
                var result = response.getReturnValue();
                var fontevaSystemAdminProfile = $A.get("$Label.c.Fonteva_Profile");
                var listOfFontevaSystemAdminProfile = fontevaSystemAdminProfile.split(",");
                var fontevaCustomerCommunityProfile = $A.get("$Label.c.Customer_Profile");
                var listOfFontevaCustomerCommunityProfile = fontevaCustomerCommunityProfile.split(",");
                var count=0;
                for(var i=0;i<listOfFontevaSystemAdminProfile.length;i++){
                    if(listOfFontevaSystemAdminProfile[i] == result.userProfile){
                        component.set('v.showSearchComponent',true);
                        component.set('v.showProjectTabComponent',false);
                        count++
                        break;
                    }else if(result.customerSuccessUser == true){
                        for(var i=0;i<listOfFontevaCustomerCommunityProfile.length;i++){
                            if(listOfFontevaCustomerCommunityProfile[i] == result.userProfile ){
                                component.set('v.projectId',result.impProjectList[0].Id);
                                component.set('v.showProjectTabComponent',true);
                                component.set('v.showSearchComponent',false);
                                 break;
                            }
                        }
                    }else{
                        component.set('v.showMessage',true);
                    }
                }
            }
        });
        $A.enqueueAction(action)
    }
})