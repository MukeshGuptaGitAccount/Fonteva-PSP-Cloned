public without sharing class ProjectScopeFunctionalityController {
    @AuraEnabled
    public static Profile getProfile() {
        Profile pro = [SELECT id , Name FROM profile WHERE id =:UserInfo.getProfileId()];
        return pro;
    }
    @AuraEnabled
    public static Implementation_Projects__c getProject(String recordId) {
        
        return [SELECT Id ,Name, User__r.FirstName ,User__r.LastName ,Account__r.Account_Owner__c, Project_Lead__r.FirstName ,Project_Lead__r.LastName,
                Project_Manager__r.FirstName ,Project_Manager__r.LastName ,Account__r.Name 
                FROM Implementation_Projects__c WHERE Id =: recordId];
    }
    @AuraEnabled
    public static List<string> selectedList(List<String> selectedOptionList){
        List<String> selectedModules = new List<String>();
            For(AggregateResult svList : [SELECT  Count(Name), Module__c FROM Test_Case__c where Module__c In: selectedOptionList group By Module__c ]){
                selectedModules.add((string)svList.get('Module__c'));
            }
        return selectedModules;
    }
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
       
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    
    @AuraEnabled
    public static List<String> getFunctionalArea(List<String> recordId){
        List<String> functionalAreaList = new List<String>();
        List<Test_Case__c> reqList = [SELECT Id,Module__c,Functional_Area_In_Scope__c,Implementation_Projects__c FROM Test_Case__c 
                                      WHERE Implementation_Projects__c IN :recordId AND Functional_Area_In_Scope__c = true ];
        
        Set<String> functionalAreaSet = new Set<String>();
        For(Test_Case__c  funArea : reqList){
            functionalAreaSet.add(funArea.Module__c);
        }
        functionalAreaList.addAll(functionalAreaSet);
        if(functionalAreaList.size() > 0){ 
            return functionalAreaList;
        }else{
           return null; 
        }
    }
    
    @AuraEnabled
    public static List<String> getAllFunctionalArea(List<String> recordId){
        List<String> functionalAreaList = new List<String>();
        List<Test_Case__c> reqList = [SELECT Id,Module__c,Implementation_Projects__c 
                                      FROM Test_Case__c 
                                      WHERE Implementation_Projects__c IN :recordId ];
        
        Set<String> functionalAreaSet = new Set<String>();
        For(Test_Case__c  funArea : reqList){
            functionalAreaSet.add(funArea.Module__c);
        }
        functionalAreaList.addAll(functionalAreaSet);
        if(functionalAreaList.size() > 0){ 
            functionalAreaList.sort();
            return functionalAreaList;
        }else{
           return null; 
        }
       
    }
    @AuraEnabled
    public static List<Test_Case__c> uponSaving(List<String> funArea,List<String> recordId,List<String> nonFunctionalArea){
        
        List<Test_Case__c> listReqObj = new List<Test_Case__c>();
        List<Test_Case__c> reqList = new  List<Test_Case__c> ();
       
        if(funArea.Size() > 0){
              reqList = [SELECT Id,User_Requirement_Summary__c,Module__c,Status__c,Implementation_Projects__c,Functional_Area_In_Scope__c
                         FROM Test_Case__c 
                         WHERE Implementation_Projects__c IN :recordId 
                         AND Module__c IN: funArea 
                         AND Functional_Area_In_Scope__c = false];
        }
       
        if(reqList.size() > 0){
            for(Test_Case__c reqObj : reqList){
                reqObj.Status__c = System.Label.Out_Of_Scope;
                reqObj.Functional_Area_In_Scope__c = true;
                listReqObj.add(reqObj);
            }
        }
        if(nonFunctionalArea.Size() > 0){
             ProjectScopeFunctionalityController.changeInScopeValue(recordId,nonFunctionalArea);
        }
       
        if(listReqObj.size() > 0){
            update listReqObj;
            return listReqObj;
        }else{
            return null;
        }
    } 
    
     @AuraEnabled
    public static void changeInScopeValue(List<String> recordId,List<String> nonFunctionalArea){
         List<Test_Case__c> listReqObjNotInScope = new List<Test_Case__c>();
        List<Test_Case__c> reqList = [SELECT Id,User_Requirement_Summary__c,Module__c,Status__c,Implementation_Projects__c,Functional_Area_In_Scope__c
                                      FROM Test_Case__c 
                                      WHERE Implementation_Projects__c IN :recordId 
                                      AND Module__c IN: nonFunctionalArea ];
        
        
         if(reqList.size() > 0){
            for(Test_Case__c reqObj : reqList){  
                reqObj.Functional_Area_In_Scope__c = false;
                listReqObjNotInScope.add(reqObj);
            }
        }
        if(listReqObjNotInScope.size() > 0){
            update listReqObjNotInScope; 
        }
        
    }
}