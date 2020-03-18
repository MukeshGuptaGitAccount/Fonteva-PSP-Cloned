@isTest
private class ProjectScopeFunctionalityControllerTest {
	@testSetup
    static void setup(){
        Account ac = new Account(Name = 'Test PSP Account'); 
        insert ac;
        
        Implementation_Projects__c masterReq = new Implementation_Projects__c(Name = 'Test PSP Project', Account__c=ac.Id);
        insert masterReq; 
        
        Test_Case__c rqFirst = new Test_Case__c();
        rqFirst.Implementation_Projects__c = masterReq.Id;
        rqFirst.Functional_Area_In_Scope__c = True;
        rqFirst.Area__c = 'Accounting';
        rqFirst.Module__c = 'Accounting';
        rqFirst.Type__c = 'Setup';
        rqFirst.Is_Active__c =  True;
        rqFirst.Account__c = ac.Id;
        rqFirst.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        rqFirst.Cloning_Level_Assignment__c = '1st Level Req';
        insert rqFirst;
        
    }
	@isTest
    static void UnitTest(){
        Implementation_Projects__c customerProject = [Select id,name,Account__c,Account__r.Name from Implementation_Projects__c where Name = 'Test PSP Project' Limit 1];
        
        Test_Case__c CustomerRequirement = [Select id,Module__c,Functional_Area_In_Scope__c,Implementation_Projects__c from Test_Case__c
                                            where Implementation_Projects__c =: customerProject.Id AND Functional_Area_In_Scope__c = True Limit 1];
        
        ProjectScopeFunctionalityController.getProject(customerProject.Id);
       
        List<String> selectedOptionList = new List<String>();
        selectedOptionList.add(CustomerRequirement.Module__c);
        ProjectScopeFunctionalityController.selectedList(selectedOptionList);
        
        ProjectScopeFunctionalityController.getselectOptions(CustomerRequirement ,'Module__c' );
        
        List<String> recordId = new List<String>();
        recordId.add(CustomerRequirement.Id);
        ProjectScopeFunctionalityController.getFunctionalArea(recordId);
        
        ProjectScopeFunctionalityController.getAllFunctionalArea(recordId);
        
        ProjectScopeFunctionalityController.uponSaving(selectedOptionList,recordId,selectedOptionList);
        ProjectScopeFunctionalityController.getProfile();
        
        
        System.assertEquals(customerProject.Account__r.Name, 'Test PSP Account');
    }
}