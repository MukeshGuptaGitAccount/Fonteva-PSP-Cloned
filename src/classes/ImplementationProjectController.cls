public without sharing class ImplementationProjectController {
    
    /* Method to search Requirements, When fontevans search Requirements based on Project Name */
    @AuraEnabled
    public static  List<Test_Case__c> searchRequirements(String projectId){
        List<Test_Case__c> requiementRecordList = new List<Test_Case__c>();
        Implementation_Projects__c impProbjectList = [SELECT Id,(SELECT Id,Status__c,Implementation_Projects__c FROM Test_Cases__r) 
                                                      FROM Implementation_Projects__c WHERE Id =: projectId];
        if(impProbjectList.Test_Cases__r.size() > 0){
            for(Test_Case__c reqObj : impProbjectList.Test_Cases__r){
                requiementRecordList.add(reqObj); 
            }
        }
        if(requiementRecordList.size() > 0){
            return requiementRecordList;
        }else{
            return null;
        }
    }
    
    /* Method to get Profile and Project Details */
    
    @AuraEnabled
    public static ProfileAndImpProjectWrapper getProfileAndProject(){
        User userDetail = [SELECT Id,ProfileId,AccountId,Profile.Name,Customer_Success_User__c FROM User WHERE id =: userInfo.getUserId() AND ProfileId=:UserInfo.getProfileId()];
        // Id userAccountId = '001m0000018U1yd';
        List<Implementation_Projects__c> impProjects = [SELECT Id,Account__c,Name FROM Implementation_Projects__c 
                                                       WHERE Account__c =:userDetail.AccountId];
                                                      // WHERE Account__c =:userAccountId];
        ProfileAndImpProjectWrapper wrapperObj = new ProfileAndImpProjectWrapper();
        wrapperObj.userProfile =userDetail.Profile.Name;
        wrapperObj.impProjectList = impProjects;
        wrapperObj.customerSuccessUser = userDetail.Customer_Success_User__c;
        return wrapperObj;
    }
    
    /*Method to clone requirements when fontevans not find Any requirements */
    
    @AuraEnabled
    public static List<Test_Case__c> createCustomerRequirement(String projectId){
        Implementation_Projects__c impProject = [Select id , name , Account__c From Implementation_Projects__c Where Id =:projectId Limit 1];
        List<Test_Case__c> reqList ;//= RequirementUtility.createCustomerRequirement(impProject.Id, impProject.Account__c);
        Id JobId = System.enqueueJob(new QueueableRequirementUtility(impProject.Id, impProject.Account__c));
        
        return reqList;
    }
    
 
    
    
    public class ProfileAndImpProjectWrapper{
        @AuraEnabled
        public String userProfile ;
        @AuraEnabled
        public Boolean customerSuccessUser;
        @AuraEnabled
        public List<Implementation_Projects__c> impProjectList ;
        /*constructor*/
        public ProfileAndImpProjectWrapper(){
            
        }
    }
    /*=================================================================================*/
    
}