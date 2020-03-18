@isTest
private class ImplementationProjectControllerTest {
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
        Implementation_Projects__c customerProject = [Select id,name,Account__c from Implementation_Projects__c where Name = 'Test PSP Project' Limit 1];
        List<Test_Case__c> reqList = ImplementationProjectController.searchRequirements(customerProject.Id);
        ImplementationProjectController.createCustomerRequirement(customerProject.Id);
        ImplementationProjectController.getProfileAndProject();
        system.assert(reqList.size() >0);
    }
}