({
    
    // common reusable function for toggle sections
    toggleSection : function(component, event, helper) {
        
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
            if(sectionAuraId == 'tier1'){
                component.set("v.tierValue", $A.get("$Label.c.Tier1"));
                component.set("v.showCompInScopetier1",true);
                component.set("v.showCompInScopetier2",false);
                component.set("v.showCompInScopetier3",false);
                component.set("v.showCompInScopetier4",false);
                $A.util.toggleClass(component.find("tier2"), "slds-section slds-is-close");
                $A.util.toggleClass(component.find("tier3"), "slds-section slds-is-close");
                $A.util.toggleClass(component.find("tier4"), "slds-section slds-is-close"); 
            }
            if(sectionAuraId == 'tier2'){
                component.set("v.tierValue", $A.get("$Label.c.Tier2"));
                component.set("v.showCompInScopetier2",true);
                component.set("v.showCompInScopetier1",false);
                component.set("v.showCompInScopetier3",false);
                component.set("v.showCompInScopetier4",false);
                $A.util.toggleClass(component.find("tier1"), "slds-section slds-is-close");
                $A.util.toggleClass(component.find("tier3"), "slds-section slds-is-close");
                $A.util.toggleClass(component.find("tier4"), "slds-section slds-is-close"); 
            }
            if(sectionAuraId == 'tier3'){
                component.set("v.tierValue", $A.get("$Label.c.Tier3"));
                component.set("v.showCompInScopetier3",true);
                component.set("v.showCompInScopetier1",false);
                component.set("v.showCompInScopetier2",false);
                component.set("v.showCompInScopetier4",false);
                $A.util.toggleClass(component.find("tier1"), "slds-section slds-is-close");
                $A.util.toggleClass(component.find("tier2"), "slds-section slds-is-close");
                $A.util.toggleClass(component.find("tier4"), "slds-section slds-is-close"); 
            }
            if(sectionAuraId == 'tier4'){
                component.set("v.tierValue", $A.get("$Label.c.Tier4"));
                component.set("v.showCompInScopetier4",true);
                component.set("v.showCompInScopetier1",false);
                component.set("v.showCompInScopetier2",false);
                component.set("v.showCompInScopetier3",false);
                $A.util.toggleClass(component.find("tier1"), "slds-section slds-is-close");
                $A.util.toggleClass(component.find("tier2"), "slds-section slds-is-close");
                $A.util.toggleClass(component.find("tier3"), "slds-section slds-is-close");
                
            }
            component.set("v.showTier1",false);
            component.set("v.showTier2",false); 
            component.set("v.showTier3",false); 
            component.set("v.showTier4",false); 
        }else{
            if(sectionAuraId == 'tier1'){
                component.set("v.showCompInScopetier1",false);
            }
            if(sectionAuraId == 'tier2'){
                component.set("v.showCompInScopetier2",false);
            }
            if(sectionAuraId == 'tier3'){
                component.set("v.showCompInScopetier3",false);
            }
            if(sectionAuraId == 'tier4'){
                component.set("v.showCompInScopetier4",false);
            }
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    },
    showOutofScopeData : function(component, event, helper) {
        var tierValue = event.getSource().get("v.name");
        component.set("v.tierType",tierValue);
        
        $A.util.toggleClass(component.find("tier1"), "slds-section slds-is-close");
        $A.util.toggleClass(component.find("tier2"), "slds-section slds-is-close");
        $A.util.toggleClass(component.find("tier3"), "slds-section slds-is-close");
        $A.util.toggleClass(component.find("tier4"), "slds-section slds-is-close");
        
        component.set("v.showCompInScopetier1",false);
        component.set("v.showCompInScopetier2",false);
        component.set("v.showCompInScopetier3",false);
        component.set("v.showCompInScopetier4",false);
        
        if(tierValue == $A.get("$Label.c.Tier1")){
            component.set("v.showTier1",true); 
            component.set("v.showTier2",false); 
            component.set("v.showTier3",false); 
            component.set("v.showTier4",false); 
            
        }   
        if(tierValue == $A.get("$Label.c.Tier2")){
            component.set("v.showTier2",true); 
            component.set("v.showTier1",false);
            component.set("v.showTier3",false); 
            component.set("v.showTier4",false); 
        }   
        if(tierValue == $A.get("$Label.c.Tier3")){
            component.set("v.showTier3",true); 
            component.set("v.showTier1",false);
            component.set("v.showTier2",false);
            component.set("v.showTier4",false);
        }
        if(tierValue == $A.get("$Label.c.Tier4")){
            component.set("v.showTier4",true); 
            component.set("v.showTier1",false);
            component.set("v.showTier2",false);
            component.set("v.showTier3",false);
        }
        component.set("v.loadingSpinner",false);
    },
    hideInScopeData : function(component, event, helper) {
        component.set("v.showCompInScopetier1",false);
        component.set("v.showCompInScopetier2",false);
        component.set("v.showCompInScopetier3",false);
        component.set("v.showCompInScopetier4",false);
        $A.util.toggleClass(component.find("tier1"), "slds-section slds-is-close");
        $A.util.toggleClass(component.find("tier2"), "slds-section slds-is-close");
        $A.util.toggleClass(component.find("tier3"), "slds-section slds-is-close");
        $A.util.toggleClass(component.find("tier4"), "slds-section slds-is-close");
    },
    hideOutofScopeData : function(component, event, helper) {
        component.set("v.showTier1",false);
        component.set("v.showTier2",false);
        component.set("v.showTier3",false);
        component.set("v.showTier4",false);
    }
})