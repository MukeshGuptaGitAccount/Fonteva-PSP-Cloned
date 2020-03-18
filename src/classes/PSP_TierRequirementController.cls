public without sharing class PSP_TierRequirementController {
    @AuraEnabled
    public static  List<WrapperReqController> searchRequirements(List<String> projectId, String tierType, String functionalArea){
        Profile pro = [SELECT id , Name FROM profile WHERE id =:UserInfo.getProfileId()];
        List<WrapperReqController> wrapperReqList = new List<WrapperReqController>();
        Id impProjectAccount = [SELECT id , name , Account__c FROM Implementation_Projects__c WHERE Id =:projectId].Account__c;
        String requirementStatus = System.Label.Requirement_Status;
        List<String> requirementStatusList = requirementStatus.split(',');
        List<Test_Case__c> reqObjList = new List<Test_Case__c>();
        List<Test_Case__c> reqList = [SELECT Id,Name,Highest_Requirement__c,Position_Sequence__c,User_Requirement_Description__c,Status__c,User_Requirement_Summary__c,
                                      Implementation_Projects__c,Sales_LOE__c,Type__c,Module__c,Area_Req__c,Functional_Area_In_Scope__c,Account__c
                                      FROM Test_Case__c 
                                      WHERE Implementation_Projects__c IN : projectId 
                                      AND  Status__c IN : requirementStatusList  
                                      AND Type__c=:tierType 
                                      AND Module__c =: functionalArea 
                                      AND Area_Req__c = true
                                      AND Account__c =: impProjectAccount
                                      AND Functional_Area_In_Scope__c = true ORDER BY Position_Sequence__c ASC];
        for(Test_Case__c reqObj : reqList ){
            WrapperReqController wrapObject  = new WrapperReqController();
            wrapObject.loggedInUser = pro;
            reqObj.User_Requirement_Description__c= reqObj.User_Requirement_Description__c.stripHtmlTags();
            wrapObject.req = reqObj;
            wrapperReqList.add(wrapObject);
        }
        if(wrapperReqList.Size() >0){
            return wrapperReqList;
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static  List<WrapperReqController> updateStatus(List<String> reqIds, List<String> projectIds, String tierType,String functionalArea){
        List<Test_Case__c> reqListUpdate = new  List<Test_Case__c>();
        for(Test_Case__c reqObj : [SELECT Id,Status__c,User_Requirement_Description__c,User_Requirement_Summary__c,
                                   Implementation_Projects__c,Sales_LOE__c ,Type__c,Functional_Area_In_Scope__c
                                   FROM Test_Case__c WHERE Id IN : reqIds]){
                                       
                                       reqObj.Status__c = System.Label.Filter_New;
                                       reqListUpdate.add(reqObj);
                                       
                                   }
        if(reqListUpdate.size() > 0){
            update reqListUpdate;
        }
        List<WrapperReqController> reqObjList = PSP_TierRequirementController.searchRequirements(projectIds,tierType,functionalArea); 
        if(reqObjList != null){
            return  reqObjList;                                
        }else{
            return null; 
        } 
    }
    @AuraEnabled
    public static  List<WrapperReqController> updateStatusInscopeNew(List<String> reqIds, List<String> projectIds, String tierType,String functionalArea ,  Map<String,String> stMap){
        System.debug(stMap);
        List<Test_Case__c> reqListUpdate = new  List<Test_Case__c>();
        for(Test_Case__c reqObj : [SELECT Id,Status__c,User_Requirement_Description__c,User_Requirement_Summary__c,
                                   Implementation_Projects__c,Sales_LOE__c ,Type__c,Functional_Area_In_Scope__c
                                   FROM Test_Case__c WHERE Id IN : reqIds]){
                                       if(stMap.ContainsKey(reqObj.Id)){
                                           reqObj.Status__c = stMap.get(reqObj.Id);
                                       }              
                                       reqListUpdate.add(reqObj);
                                       
                                   }
        if(reqListUpdate.size() > 0){
            update reqListUpdate;
        }
        List<WrapperReqController> reqObjList = PSP_TierRequirementController.searchRequirements(projectIds,tierType,functionalArea); 
        if(reqObjList != null){
            return  reqObjList;                                
        }else{
            return null; 
        } 
    }
    
    @AuraEnabled
    public static List<WrapperReqController> searchRequirementsInScope(String projectId , String functionalArea , string tierFilter){
        Profile pro = [SELECT id , Name FROM profile WHERE id =:UserInfo.getProfileId()];
        List<WrapperReqController> wrapperReqList = new List<WrapperReqController>();
        String inScope = System.Label.In_Scope_Filter;
        List<String> inScopeList = inScope.split(':');
        Implementation_Projects__c impProject = [SELECT id , Name , Account__c FROM Implementation_Projects__c WHERE Id =:projectId Limit 1];
        List<Test_Case__c> reqList = [SELECT Id,Counter__c,Name,Highest_Requirement__c,Core_Req__c,Position_Sequence__c,User_Requirement_Description__c,User_Requirement_Summary__c,Implementation_Projects__c,Sales_LOE__c,Status__c,
                                      Type__c,Feedback__c,(SELECT Id ,Name ,Status__c from Requirements1__r
                                                           WHERE Type__c = 'Setup' AND Functional_Area_In_Scope__c = True )
                                      FROM Test_Case__c 
                                      WHERE Implementation_Projects__c =: projectId AND Module__c =: functionalArea
                                      AND Status__c IN : inScopeList
                                      AND Functional_Area_In_Scope__c = True 
                                      AND Account__c =: impProject.Account__c
                                      AND Area_Req__c = True
                                      AND Type__c =: tierFilter ORDER BY Position_Sequence__c ASC];
        integer totalYReq ;
        integer totalXReq = 0;
        Map<Id,Test_Case__c> mapOfIdTest = new Map<Id,Test_Case__c>();
        for(Test_Case__c req : reqList){
            WrapperReqController wrapObject  = new WrapperReqController();
            wrapObject.loggedInUser = pro;
            if(String.isNotBlank(req.User_Requirement_Description__c)){
                req.User_Requirement_Description__c= req.User_Requirement_Description__c.stripHtmlTags(); 
            }
            wrapObject.req = req;
            wrapperReqList.add(wrapObject);
            totalYReq = req.Requirements1__r.size();
            wrapObject.totalYReq = totalYReq;
            wrapObject.totalXReq =  totalXReq;
        }
        return wrapperReqList;
    }
    
    @AuraEnabled
    public static List<WrapperReqController> searchChildRequirementsInScope(String reqId , String functionalArea , string tierFilter){
        String inScope = System.Label.In_Scope_Filter;
        List<String> inScopeList = inScope.split(':');
        Profile pro = [SELECT id , Name FROM profile WHERE id =:UserInfo.getProfileId()];
        List<WrapperReqController> wrapperReqList = new List<WrapperReqController>();
        List<Test_Case__c> reqList = [SELECT Id,Counter__c,Name,Highest_Requirement__c,Core_Req__c,Position_Sequence__c,User_Requirement_Description__c,
                                      User_Requirement_Summary__c,Implementation_Projects__c,Sales_LOE__c,Status__c,Type__c,Feedback__c,
                                      (SELECT Id ,Status__c,Name from Requirements1__r WHERE Type__c = 'Setup' AND Functional_Area_In_Scope__c = True )
                                      FROM Test_Case__c WHERE Parent_Requirement__c =: reqId 
                                      AND Module__c =: functionalArea 
                                      AND Functional_Area_In_Scope__c = True
                                      AND Type__c =: tierFilter ORDER BY Position_Sequence__c ASC];
        integer totalYReq ;
        integer totalXReq ;
        for(Test_Case__c req : reqList){
            WrapperReqController wrapObject  = new WrapperReqController();
            if(String.isNotBlank(req.User_Requirement_Description__c)){
                req.User_Requirement_Description__c= req.User_Requirement_Description__c.stripHtmlTags();
            }
            wrapObject.req = req;
            wrapObject.loggedInUser = pro;
            wrapperReqList.add(wrapObject);
            totalYReq = req.Requirements1__r.size();
            wrapObject.totalYReq = totalYReq;
            
            wrapObject.totalXReq =  totalXReq;
        }
        return wrapperReqList;
    }
    public static List<Test_Case__c> cascadingUpdate(List<Test_Case__c> reqCascadingList){
        Set<Id> finalIds = new Set<Id>();
        Set<Id> childIds = new Set<Id>();
        Set<Id> setIds = new Set<Id>();
        Set<Id> setIdsInscope = new Set<Id>();
        for(Test_Case__c req : reqCascadingList){
            if(req.Status__c == System.Label.Out_Of_Scope && req.Highest_Requirement__c == true){
                setIds.add(req.Id);
            }
        }
        if(!setIds.isEmpty()){
            do{
                List<Test_Case__c> reqList = new List<Test_Case__c>();
                if(childIds.isEmpty()){
                    reqList = [Select id , Name ,Parent_Requirement__c ,Status__c FROM Test_Case__c Where Parent_Requirement__c IN : setIds ];
                }
                else{
                    reqList = [Select id , Name ,Parent_Requirement__c ,Status__c FROM Test_Case__c Where Parent_Requirement__c IN : childIds ];
                }
                childIds.clear();
                for(Test_Case__c req : reqList){
                    childIds.add(req.Id);
                    finalIds.add(req.Id);
                }
            }
            while(childIds.size()>0);
        }
        List<Test_case__c> reqNewList = new List<Test_case__c>();
        if(!finalIds.isEmpty()){
            for(Id reqId : finalIds){
                Test_case__c req = new Test_case__c();
                req.Id = reqId;
                req.Status__c = System.Label.Out_Of_Scope;
                reqNewList.add(req);
            }
        }
        if(reqNewList.size() > 0){
            update reqNewList;
        }
        return null;
    }
    @AuraEnabled
    public static  List<Test_Case__c> updateStatusInscope(List<String> reqIds , Map<String,String> stMap){
        List<Test_Case__c> reqList = new  List<Test_Case__c>();
        for(Test_Case__c reqObj : [SELECT Id,Status__c,Highest_Requirement__c,User_Requirement_Description__c,User_Requirement_Summary__c,Implementation_Projects__c,Parent_Requirement__c,Sales_LOE__c,Feedback__c
                                   FROM Test_Case__c WHERE Id IN : reqIds]){
                                       if(stMap.ContainsKey(reqObj.Id)){
                                           reqObj.Status__c = stMap.get(reqObj.Id);
                                       }              
                                       reqList.add(reqObj);
                                   }
        if(reqList.size() > 0){
            update reqList;
            PSP_TierRequirementController.cascadingUpdate(reqList);
            return reqList;
        }
        return null;
    }
    
    @AuraEnabled
    public static  List<Test_Case__c> updateInscopeRecords(List<Test_Case__c> reqRecords , Map<String,String> stMap){
        
        if(stMap != null){
            for(Test_Case__c reqObj : reqRecords){
                if(stMap.ContainsKey(reqObj.Id)){
                    reqObj.Status__c = stMap.get(reqObj.Id);
                }              
            }
        }
        if(reqRecords.Size() >0){
            update reqRecords; 
            PSP_TierRequirementController.cascadingUpdate(reqRecords);
        }
        return reqRecords;
    }
    
    @AuraEnabled
    public static Test_Case__c coreRequirementRecord(String reqId){
        List<Schema.FieldSetMember> coreReqFields = SObjectType.Test_Case__c.FieldSets.Core_Requirement_Details_Fields.getFields();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : coreReqFields) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Test_Case__c WHERE Id = \'' + reqId + '\''+' LIMIT 1';
        return Database.query(query);
    }
    
    @AuraEnabled
    public static List<Test_Case__c> createCustomerRequirement(String projectId){
        Implementation_Projects__c impProject = [SELECT id , name , Account__c FROM Implementation_Projects__c WHERE Id =:projectId Limit 1];
        List<Test_Case__c> reqList = RequirementUtility.createCustomerRequirement(impProject.Id, impProject.Account__c);
        return reqList;
    }
    
    @AuraEnabled
    public static Test_Case__c updateCoreRequirement(Test_Case__c reqRecord){
        if(reqRecord != null){
            update reqRecord;
        }
        return reqRecord;
    }
    
    public class WrapperReqController {
        @AuraEnabled
        public Test_Case__c req ;
        @AuraEnabled
        public boolean enable = false;
        @AuraEnabled
        public boolean enableFeedback = false;
        @AuraEnabled
        public boolean enableNeeded = false;
        @AuraEnabled
        public boolean enableNotNeeded = false;
        @AuraEnabled
        public boolean enableChildComponent = false;
        @AuraEnabled
        public boolean enableInScope = false;
        @AuraEnabled
        public boolean enableCoreRequirement = false;
        @AuraEnabled
        public boolean enableTentativeAndUndetermined = false;
        @AuraEnabled
        public profile loggedInUser ;
        @AuraEnabled
        public integer totalYReq ;
        @AuraEnabled
        public integer totalXReq ;
        @AuraEnabled
        public boolean hideTooltip = true ;
        @AuraEnabled
        public boolean showCheck = false ;
        public WrapperReqController(){} 
    }
}