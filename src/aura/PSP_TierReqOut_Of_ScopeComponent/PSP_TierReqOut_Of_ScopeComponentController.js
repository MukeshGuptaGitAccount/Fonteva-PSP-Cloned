({
    showOutOfScopeData : function(component, event, helper) { 
        helper.OutOfScopeData(component, event, helper);
    },
    hideOutofScopeData : function(component, event, helper) {
        helper.goToPrevious(component, event, helper);
    },
    ShowToBeDiscussed :function(component, event, helper){
        component.find("saveDisable").set('v.disabled',false);
        component.find("saveAndCloseDisable").set('v.disabled',false);
        var recordId=event.getSource().get('v.value');
        var labelVal = event.getSource().get('v.label');
        if(labelVal == $A.get("$Label.c.Needed_Label")){
            var source=event.getSource();
            source.set('v.label',$A.get("$Label.c.Discussed_Label")); 
            event.getSource().set('v.variant','Destructive');
            var toBeDiscussList  = component.get("v.toBeDiscussList");
            toBeDiscussList.push(recordId);
            
        }else{
            var source=event.getSource();
            source.set('v.label',$A.get("$Label.c.Needed_Label")); 
            source.set('v.variant','Neutral');
            var toBeDiscussList  = component.get("v.toBeDiscussList");
            for(var i=0 ;i<toBeDiscussList.length;i++){
                if(toBeDiscussList[i] == recordId){
                    toBeDiscussList.splice(i,1);
                }
            }
            var toBeDiscussList  = component.get("v.toBeDiscussList");
        }
    },
    callInScopeTentative :function(component, event, helper){
        component.find("saveDisable").set('v.disabled',false);
        component.find("saveAndCloseDisable").set('v.disabled',false);
        var source = event.getSource();
        var recordId = source.get('v.value');
        var varVal = source.get('v.variant');
        var labelVal = source.get('v.label'); 
        var statusMap = component.get("v.buttonStatusMap"); 
        var inScopeTentativeList = component.get("v.inScopeTentativeList");
        
        var buttonSourceMapTentative = component.get("v.buttonSourceMapTentative");
        var buttonSourceMapUndetermined = component.get("v.buttonSourceMapUndetermined");
        
        
        if(varVal == 'Neutral' && labelVal == $A.get("$Label.c.In_Scope_Tentative")){
            source.set('v.variant','Success');
            statusMap[recordId] = $A.get("$Label.c.In_Scope_Tentative");
            buttonSourceMapTentative[recordId] = source;
            inScopeTentativeList.push(recordId);
            
        }else{
            source.set('v.variant','Neutral');
            for(var i=0 ;i<inScopeTentativeList.length;i++){
                if(inScopeTentativeList[i] == recordId){
                    inScopeTentativeList.splice(i,1);
                }
            }
        }
        buttonSourceMapUndetermined[recordId].set('v.variant','Neutral');
    },
    callInScopeUndetermined :function(component, event, helper){
        component.find("saveDisable").set('v.disabled',false);
        component.find("saveAndCloseDisable").set('v.disabled',false);
        var source = event.getSource();
        var recordId = source.get('v.value');
        var varVal = source.get('v.variant');
        var labelVal = source.get('v.label'); 
        var statusMap = component.get("v.buttonStatusMap");
        var buttonSourceMapTentative = component.get("v.buttonSourceMapTentative");
        
        
        var buttonSourceMapUndetermined = component.get("v.buttonSourceMapUndetermined");
        var inScopeUndeterminedList = component.get("v.inScopeUndeterminedList");
        if(varVal == 'Neutral'&& labelVal == $A.get("$Label.c.In_Scope_Undetermined")){
            source.set('v.variant','Success');
            statusMap[recordId] = $A.get("$Label.c.In_Scope_Undetermined");
            inScopeUndeterminedList.push(recordId);
            buttonSourceMapUndetermined[recordId] = source;
        }else{
            source.set('v.variant','Neutral');
            for(var i=0 ;i<inScopeUndeterminedList.length;i++){
                if(inScopeUndeterminedList[i] == recordId){
                    inScopeUndeterminedList.splice(i,1);
                }
            }
        }
        buttonSourceMapTentative[recordId].set('v.variant','Neutral');
    },
    save :function(component, event, helper){   
        helper.saveRecords(component, event, helper);
    },
    saveAndClose : function(component, event, helper){   
        helper.saveRecords(component, event, helper);
        setTimeout(
            $A.getCallback(function() {
                helper.goToPrevious(component, event, helper); 
            }), 1000
        );
    },
    calltoCopy : function(component, event, helper) {
        var text =event.currentTarget.name;
        // Create an hidden input
        var hiddenInput = document.createElement("input");
        // passed text into the input
        hiddenInput.setAttribute("value", text);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
      /*  document.body.removeChild(hiddenInput); 
        // store target button label value
        var orignalLabel = event.getSource().get("v.label");
        // change button icon after copy text
        event.getSource().set("v.iconName" , 'utility:check');
        // change button label with 'copied' after copy text 
        event.getSource().set("v.label" , 'copied');
        
        // set timeout to reset icon and label value after 700 milliseconds 
        setTimeout(function(){ 
            event.getSource().set("v.iconName" , 'utility:copy_to_clipboard'); 
            event.getSource().set("v.label" , orignalLabel);
        }, 700);*/
        
    }
})