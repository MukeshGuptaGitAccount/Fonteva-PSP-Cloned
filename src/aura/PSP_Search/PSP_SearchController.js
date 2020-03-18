({
    searchRequirement : function(component, event, helper) {
      var impProjectId = component.find('ids').get('v.value');
      component.set('v.showSpinner',true);
      if(impProjectId === null || impProjectId === '' ){
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              title : 'Error',
              message: $A.get("$Label.c.Error_select_a_project"),
              type: 'error'
          });
          toastEvent.fire();
          component.set('v.showSpinner',false);
        //  $A.get('e.force:refreshView').fire();
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
                      component.set('v.showSpinner',false);
                      component.set("v.hideParentComp", false);
                      component.set("v.projectId", impProjectId);
                      component.set("v.showProjectTabComponent", true);
                  }
                  else{
                      component.set('v.showSpinner',false);
                      component.set("v.noRecordFound", true);
                      component.set('v.isHide', false);  
                  }
              }
          });
          
          $A.enqueueAction(action)
      }
  },
  cancel: function(component, event, helper) {
      component.set("v.showButton", false);
      component.set("v.hideText", true);
      component.set("v.hideNewbutton", true);
      component.set("v.recordExist", false);
      component.set("v.noRecordFound", false);
      component.find('ids').set('v.value',null);  
      component.set('v.isHide', true); 
  },
  createRequirement : function(component, event, helper) {
      component.set("v.noRecordFound", false);
      component.set('v.showSpinner',true);
      var impProjectId = component.find('ids').get('v.value');
      component.set("v.projectId", impProjectId);
      if(impProjectId === null || impProjectId === '' ){
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              title : 'Error',
              message: $A.get("$Label.c.Error_select_a_project"),
              type: 'error'
              
          });
          toastEvent.fire();
      }else{                    
          var action = component.get("c.createCustomerRequirement");
          action.setParams({
              projectId : impProjectId
          });
          action.setCallback(this,function(response){
              var state = response.getState();
              if(state == "SUCCESS"){ 
                  //var result = response.getReturnValue();
                  component.set('v.showSpinner',false);
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      title : 'Success',
                      message: $A.get("$Label.c.Requirement_Created"),
                      type: 'Success'
                  });
                  toastEvent.fire();
                  component.set('v.hideParentComp',true);
                  component.set('v.isHide',true);
                  //component.set('v.showProjectTabComponent',true);  
              }else{
                  component.set('v.showSpinner',false);
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      title : 'Error',
                      message: $A.get("$Label.c.Error"),
                      type: 'error'
                  });
                  toastEvent.fire();
              }
          });
          $A.enqueueAction(action)
      }
  }

})