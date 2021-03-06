({
    showInScopeData : function(component, event, helper) {
        helper.showInScopeData(component ,event);
    },
    showNeeded :function(component, event, helper){
        component.find("saveAndClose").set("v.disabled",false);
        component.find("save").set("v.disabled",false);
        var recordId = event.getSource().get('v.value');
        var source = event.getSource();
        var neededList  = component.get("v.neededList"); 
        var recordList = component.get('v.requirementInscopeList');
        var statusMap = component.get("v.buttonStatusMap");
        var labelVal = event.getSource().get('v.label');
        var SourceMapInscope = component.get("v.SourceMapInscope");
        var SourceMapNotNeeded = component.get("v.SourceMapNotNeeded");

        if(labelVal == $A.get("$Label.c.Not_Needed_Label")){
            source.set('v.label',$A.get("$Label.c.Needed_Label"));
            source.set('v.variant',"destructive"); 
            SourceMapNotNeeded[recordId] = source;
           
             for( let i in recordList){
                 if(recordList[i].req.Id == recordId){
					statusMap[recordId] = $A.get("$Label.c.Out_Of_Scope");
                     if( neededList.length > 0 && neededList.indexOf(recordList[i].req.Id) == -1){
                         neededList.push(recordList[i].req);
                     }else{
                        neededList.push(recordList[i].req);
                    }
                 }
            }
        }else{
            source.set('v.label',$A.get("$Label.c.Not_Needed_Label"));
            source.set('v.variant',"neutral");
            for(var i = 0; i < recordList.length; i++){
                if(recordList[i].req.Id == recordId){
                    neededList.splice(recordList[i].req,1);
                }
            }
        }
        SourceMapInscope[recordId].set('v.variant','neutral');
        SourceMapInscope[recordId].set('v.label',$A.get("$Label.c.In_Scope_Label"));
        component.set("v.requirementInscopeList" , recordList);
    },
    showValidated :function(component, event, helper){
        component.find("saveAndClose").set("v.disabled",false);
        component.find("save").set("v.disabled",false);
        var recordId = event.getSource().get('v.value');
        var source = event.getSource();
        var labelVal = event.getSource().get('v.label');
        var neededList  = component.get("v.neededList");
        var recordList = component.get('v.requirementInscopeList');
        var statusMap = component.get("v.buttonStatusMap");
        var SourceMapInscope = component.get("v.SourceMapInscope");
        var SourceMapNotNeeded = component.get("v.SourceMapNotNeeded");
        if(labelVal == $A.get("$Label.c.In_Scope_Label")){
            
            source.set('v.label',$A.get("$Label.c.In_Scope_Validated_Label"));
            source.set('v.variant',"brand");
            for(var i = 0; i < recordList.length; i++){
                if(recordList[i].req.Id == recordId){
                    statusMap[recordId] = $A.get("$Label.c.In_Scope_Approved");
                    SourceMapInscope[recordId] = source;
                   if( neededList.length > 0 && neededList.indexOf(recordList[i].req.Id) == -1){
                        neededList.push(recordList[i].req);
                     
                    }else{
                        neededList.push(recordList[i].req);
                    }
                }
            }
        }else{
            source.set('v.label',$A.get("$Label.c.In_Scope_Label"));
            source.set('v.variant',"neutral");
            for(var i = 0; i < recordList.length; i++){
                if(recordList[i].req.Id == recordId){
                    neededList.splice(recordList[i].req,1);
                }
            } 
        }
        SourceMapNotNeeded[recordId].set('v.variant','neutral');
        SourceMapNotNeeded[recordId].set('v.label',$A.get("$Label.c.Not_Needed_Label"));
        component.set("v.requirementInscopeList" , recordList);
    },
    saveReq :function(component, event, helper){
        helper.saveReq(component ,event ,helper);
    },
    editSection : function(component, event, helper){ 
        component.find("saveAndClose").set("v.disabled",false);
        component.find("save").set("v.disabled",false);
        var recordId = event.getSource().get('v.value');
        var recordList = component.get('v.requirementInscopeList');
        var neededList  = component.get("v.requirementInscopeListUpdate");
        for(var i = 0; i < recordList.length; i++){
            if(recordList[i].req.Id == recordId){
                recordList[i].enable = true;
                neededList.push(recordList[i].req);
            }
        }
        component.set("v.requirementInscopeList" , recordList);
    },
    feedbackSection : function(component, event, helper){ 
        component.find("saveAndClose").set("v.disabled",false);
        component.find("save").set("v.disabled",false);
        var recordId = event.getSource().get('v.value');
        var recordList = component.get('v.requirementInscopeList');
        var neededList  = component.get("v.requirementInscopeListFeedbackUpdate");
        for(var i = 0; i < recordList.length; i++){
            if(recordList[i].req.Id == recordId){
                recordList[i].enableFeedback = true;
                neededList.push(recordList[i].req);
            }
        }
        component.set("v.requirementInscopeList" , recordList);
    },
    backFunction : function(component, event, helper) {
        var cmpEventData = component.getEvent("backFunctionEvent");
        cmpEventData.setParams({ }); 
        cmpEventData.fire(); 
    },
    saveAndCloseFuction : function(component, event, helper) {
        setTimeout(
            $A.getCallback(function() {
                var cmpEventData = component.getEvent("backFunctionEvent");
                cmpEventData.setParams({ }); 
                cmpEventData.fire(); 
            }), 1000
        );
        helper.saveReq(component ,event ,helper);
    },
    
    drillDownSection : function(component, event, helper) {
        var recordId = event.getSource().get('v.value');
        var recordList = component.get('v.requirementInscopeList');
        var source = event.getSource();
        var labelVal = event.getSource().get('v.label');
        component.set("v.reqId" , recordId);
        if(labelVal == $A.get("$Label.c.Drill_Down_Button")){
            source.set('v.label',$A.get("$Label.c.Close_Drill"));
            source.set('v.variant',"success");
            for(var i = 0; i < recordList.length; i++){
                if(recordList[i].req.Id == recordId){
                    recordList[i].enableChildComponent = true;
                }
            }
        }else{
            source.set('v.label',$A.get("$Label.c.Drill_Down_Button"));
            source.set('v.variant',"neutral");
            for(var i = 0; i < recordList.length; i++){
                if(recordList[i].req.Id == recordId){
                    recordList[i].enableChildComponent = false;
                }
            }
        }
        component.set("v.requirementInscopeList" , recordList);
    },
    hideChildsData :function(component, event, helper) {
        var recordId = event.getSource().get("v.reqId");
        var recordList = component.get('v.requirementInscopeList');
        for(var i = 0; i < recordList.length; i++){
            if(recordList[i].req.Id == recordId){
                recordList[i].enableChildComponent = false;
            }
        }
        component.set("v.requirementInscopeList" , recordList);
    },
    calltoCopy : function(component, event, helper) {
        var text =event.currentTarget.name;
        var recordId =event.currentTarget.getAttribute("data-conId");;
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
        
        var reqList =  component.get("v.requirementInscopeList");
        for(var i = 0; i < reqList.length; i++){
            if(reqList[i].req.Id == recordId){
                reqList[i].showCheck = true;
                reqList[i].hideTooltip = false;
            }
        }
        component.set("v.requirementInscopeList" ,reqList);  
        setTimeout(function(){
            for(var i = 0; i < reqList.length; i++){
                reqList[i].showCheck = false;
                reqList[i].hideTooltip = true;
            }
        }, 700);
        component.set("v.requirementInscopeList" ,reqList); 
    } 
})