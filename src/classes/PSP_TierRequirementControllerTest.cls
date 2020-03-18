@isTest
private class PSP_TierRequirementControllerTest {
    @testSetup
    static void setup(){
        Account ac = new Account(Name = 'Test PSP Account'); 
        insert ac;
        
        Implementation_Projects__c masterReq = new Implementation_Projects__c(Name = 'Test PSP Project', Account__c=ac.Id);
        insert masterReq; 
        
        Test_Case__c rqFirst = new Test_Case__c();
        rqFirst.Implementation_Projects__c = masterReq.Id;
        rqFirst.Functional_Area_In_Scope__c = True;
        rqFirst.User_Requirement_Description__c = 'Accounting Record';
        rqFirst.Area__c = 'Accounting';
        rqFirst.Area_Req__c = True;
        rqFirst.Module__c = 'Accounting';
        rqFirst.Status__c = 'UnKnown';
        rqFirst.Type__c = 'Setup';
        rqFirst.Is_Active__c =  True;
        rqFirst.Account__c = ac.Id;
        rqFirst.Core_Req__c = true;
        rqFirst.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        rqFirst.Cloning_Level_Assignment__c = '1st Level Req';
        insert rqFirst;
        
        Test_Case__c rqFirst1 = new Test_Case__c();
        rqFirst1.Implementation_Projects__c = masterReq.Id;
        rqFirst1.Functional_Area_In_Scope__c = True;
        rqFirst1.User_Requirement_Description__c = 'Accounting Record';
        rqFirst1.Area__c = 'Accounting';
        rqFirst1.Area_Req__c = True;
        rqFirst1.Module__c = 'Accounting';
        rqFirst1.Status__c = 'UnKnown';
        rqFirst1.Type__c = 'Setup';
        rqFirst1.Is_Active__c =  True;
        rqFirst1.Account__c = ac.Id;
        rqFirst1.Core_Req__c = True;
        rqFirst1.Parent_Requirement__c = rqFirst.Id;
        insert rqFirst1;
        
        Test_Case__c rqFirst2 = new Test_Case__c();
        rqFirst2.Implementation_Projects__c = masterReq.Id;
        rqFirst2.Functional_Area_In_Scope__c = True;
        rqFirst2.User_Requirement_Description__c = 'Accounting Record';
        rqFirst2.Area__c = 'Accounting';
        rqFirst2.Area_Req__c = True;
        rqFirst2.Module__c = 'Accounting';
        rqFirst2.Status__c = 'Out-Of-Scope';
        rqFirst2.Type__c = 'Setup';
        rqFirst2.Is_Active__c =  True;
        rqFirst2.Account__c = ac.Id;
        rqFirst2.Core_Req__c = true;
        rqFirst2.Parent_Requirement__c = rqFirst.Id;
        rqFirst2.Highest_Requirement__c = True;
        insert rqFirst2;
    }
    @isTest
    static void UnitTest(){
        Implementation_Projects__c customerProject = [Select id,name,Account__c from Implementation_Projects__c where Name = 'Test PSP Project' Limit 1];
        
        Test_Case__c CustomerRequirement = [Select id,Module__c,Type__c,Functional_Area_In_Scope__c,Implementation_Projects__c,User_Requirement_Description__c,Status__c from Test_Case__c
                                            where Implementation_Projects__c =: customerProject.Id AND Functional_Area_In_Scope__c = True Limit 1];
        
        
        
		List<Test_Case__c> CascadingRequirement = [Select id,Module__c,Type__c,Functional_Area_In_Scope__c,Implementation_Projects__c,Status__c,Highest_Requirement__c from Test_Case__c
                                            where Implementation_Projects__c =: customerProject.Id AND Highest_Requirement__c = True Limit 1];     
        
        List<String> projectId = new List<String>();
        projectId.add(customerProject.Id);
        
        List<String> recordIds = new List<String>();
        recordIds.add(CustomerRequirement.Id);
        
        List<Test_Case__c> reqRecords = new List<Test_Case__c>();
        reqRecords.add(CustomerRequirement);
        
        Map<String,String> stMap = new Map<String,String>();
        stMap.put(CustomerRequirement.Id, CustomerRequirement.Status__c);
        
        PSP_TierRequirementController.WrapperReqController WrapperReq = new PSP_TierRequirementController.WrapperReqController();
        WrapperReq.req = CustomerRequirement;
        WrapperReq.enable = false;
        WrapperReq.enableChildComponent = false;
        WrapperReq.enableFeedback = false;
        WrapperReq.enableNeeded = false ;
        
        List<PSP_TierRequirementController.WrapperReqController> reqListToSearch = PSP_TierRequirementController.searchRequirements(projectId,CustomerRequirement.Type__c ,CustomerRequirement.Module__c);
        PSP_TierRequirementController.updateStatus(recordIds,projectId,CustomerRequirement.Type__c ,CustomerRequirement.Module__c);
        PSP_TierRequirementController.searchRequirementsInScope(customerProject.Id,CustomerRequirement.Module__c,CustomerRequirement.Type__c );
        PSP_TierRequirementController.updateInscopeRecords(reqRecords ,stMap);
        PSP_TierRequirementController.updateStatusInscope(recordIds,stMap);
        PSP_TierRequirementController.updateStatusInscopeNew(recordIds, projectId, CustomerRequirement.Type__c, CustomerRequirement.Module__c, stMap);
        PSP_TierRequirementController.createCustomerRequirement(customerProject.Id);
        
        CustomerRequirement.User_Requirement_Description__c = 'Updated Record';
        update CustomerRequirement;
        
        PSP_TierRequirementController.coreRequirementRecord(CustomerRequirement.Id);
        Test_case__c reqCore = PSP_TierRequirementController.updateCoreRequirement(CustomerRequirement);
        
        System.assertEquals(reqCore.User_Requirement_Description__c, 'Updated Record');
        PSP_TierRequirementController.searchChildRequirementsInScope(CustomerRequirement.Id,CustomerRequirement.Module__c,CustomerRequirement.Type__c);
        PSP_TierRequirementController.cascadingUpdate(CascadingRequirement);      
        
        system.assert(reqListToSearch.size() > 0);
    }
    
}