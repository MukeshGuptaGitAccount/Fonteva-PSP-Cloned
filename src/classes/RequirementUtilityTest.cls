@isTest 
private class RequirementUtilityTest {
    
    @testSetup static void Setup() {
        // Create common test accounts
        Account ac = new Account(Name = Label.lbl_Master_Account); 
        insert ac;
        Implementation_Projects__c masterReq = new Implementation_Projects__c(Name = Label.lbl_Master_Project, Account__c=ac.Id);
        insert masterReq;     
        
        Account customerAccount = new Account(Name = 'Test Customer Account'); 
        insert customerAccount;
        Implementation_Projects__c customerProject = new Implementation_Projects__c(Name = 'Test PSP Project', Account__c=customerAccount.Id);
        insert customerProject;
        
        List<Test_Case__c> lstParent = new List<Test_Case__c>();
        Test_Case__c rqFirst = new Test_Case__c();
        rqFirst.Implementation_Projects__c = masterReq.Id;
        rqFirst.Functional_Area_In_Scope__c = True;
        rqFirst.Area_Req__c = true;
        rqFirst.Area__c = 'Accounting';
        rqFirst.Module__c = 'Accounting';
        rqFirst.Type__c = 'Setup';
        rqFirst.Is_Active__c =  True;
        rqFirst.Account__c = ac.Id;
        rqFirst.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        rqFirst.Cloning_Level_Assignment__c = '1st Level Req';
        insert rqFirst;
        
        
        Test_Case__c rqSecond = new Test_Case__c();
        rqSecond.Implementation_Projects__c = masterReq.Id;
        rqSecond.Functional_Area_In_Scope__c = True;
        rqSecond.Area_Req__c = true;
        rqSecond.Area__c = 'Accounting';
        rqSecond.Module__c = 'Accounting';
        rqSecond.Parent_Requirement__c = rqFirst.Id;
        rqSecond.Type__c = 'Setup';
        rqSecond.Is_Active__c =  True;
        rqSecond.Account__c = ac.Id;
        rqSecond.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        rqSecond.Cloning_Level_Assignment__c = '2nd Level Req';
        insert rqSecond;   
        
        
        Test_Case__c rqThird = new Test_Case__c();
        rqThird.Implementation_Projects__c = masterReq.Id;
        rqThird.Functional_Area_In_Scope__c = True;
        rqThird.Area__c = 'Accounting';
        rqThird.Area_Req__c = true;
        rqThird.Module__c = 'Accounting';
        rqThird.Parent_Requirement__c = rqSecond.Id;
        rqThird.Type__c = 'Setup';
        rqThird.Is_Active__c =  True;
        rqThird.Account__c = ac.Id;
        rqThird.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        rqThird.Cloning_Level_Assignment__c = '3rd Level Req';
        insert rqThird;
        
        
        Test_Case__c rqFourth = new Test_Case__c();
        rqFourth.Implementation_Projects__c = masterReq.Id;
        rqFourth.Functional_Area_In_Scope__c = True;
        rqFourth.Area_Req__c = true;
        rqFourth.Area__c = 'Accounting';
        rqFourth.Module__c = 'Accounting';
        rqFourth.Parent_Requirement__c = rqThird.Id;
        rqFourth.Type__c = 'Setup';
        rqFourth.Is_Active__c =  True;
        rqFourth.Account__c = ac.Id;
        rqFourth.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        rqFourth.Cloning_Level_Assignment__c = '4th Level Req';
        insert rqFourth;
        
        
        Test_Case__c rqFifth = new Test_Case__c();
        rqFifth.Implementation_Projects__c = masterReq.Id;
        rqFifth.Functional_Area_In_Scope__c = True;
        rqFifth.Area_Req__c = true;
        rqFifth.Area__c = 'Accounting';
        rqFifth.Module__c = 'Accounting';
        rqFifth.Parent_Requirement__c = rqFourth.Id;
        rqFifth.Type__c = 'Setup';
        rqFifth.Is_Active__c =  True;
        rqFifth.Account__c = ac.Id;
        rqFifth.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        rqFifth.Cloning_Level_Assignment__c = '5th Level Req';
        insert rqFifth;
        
        
        Test_Case__c rqSixthWithoutLevel = new Test_Case__c();
        rqSixthWithoutLevel.Implementation_Projects__c = masterReq.Id;
        rqSixthWithoutLevel.Functional_Area_In_Scope__c = True;
        rqSixthWithoutLevel.Area__c = 'Accounting';
        rqSixthWithoutLevel.Area_Req__c = true;
        rqSixthWithoutLevel.Module__c = 'Accounting';
        rqSixthWithoutLevel.Type__c = 'Setup';
        rqSixthWithoutLevel.Is_Active__c =  True;
        rqSixthWithoutLevel.Account__c = ac.Id;
        rqSixthWithoutLevel.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        insert rqSixthWithoutLevel;
        
        
        Test_Case__c rqFirstAdv = new Test_Case__c();
        rqFirstAdv.Implementation_Projects__c = masterReq.Id;
        rqFirstAdv.Functional_Area_In_Scope__c = True;
        rqFirstAdv.Area_Req__c = true;
        rqFirstAdv.Area__c = 'Advertisements';
        rqFirstAdv.Module__c = 'Advertisements';
        rqFirstAdv.Type__c = 'Setup';
        rqFirstAdv.Is_Active__c =  True;
        rqFirstAdv.Account__c = ac.Id;
        rqFirstAdv.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        rqFirstAdv.Cloning_Level_Assignment__c = '1st Level Req';
        insert rqFirstAdv;
        
        
        Test_Case__c rqSecondAdv = new Test_Case__c();
        rqSecondAdv.Implementation_Projects__c = masterReq.Id;
        rqSecondAdv.Functional_Area_In_Scope__c = True;
        rqSecondAdv.Area__c = 'Advertisements';
        rqSecondAdv.Area_Req__c = true;
        rqSecondAdv.Module__c = 'Advertisements';
        rqSecondAdv.Parent_Requirement__c = rqFirstAdv.Id;
        rqSecondAdv.Type__c = 'Setup';
        rqSecondAdv.Is_Active__c =  True;
        rqSecondAdv.Account__c = ac.Id;
        rqSecondAdv.RecordTypeId = Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId();
        rqSecondAdv.Cloning_Level_Assignment__c = '2nd Level Req';
        insert rqSecondAdv;
        
    }
    
    /**********
* Use Case:
*   New customer requirement clone from master 
*
* State:
*   Method under test: Insert
*
* Expected Result:
*   All master record should be cloned and count of created customer requirments should be same.
**********/
    @isTest
    static void Insert_CustomerRequirment_From_Master_Count_Of_Records_Should_Be_Same() 
    {        
        List<Implementation_Projects__c> customerProject =[Select id,name,Account__c from Implementation_Projects__c where Name = 'Test PSP Project'];
        Test.startTest();
        List<Test_Case__c> masterRequirements = [Select id,Is_Active__c,Cloning_Level_Assignment__c,Implementation_Projects__r.Name  from Test_Case__c where Is_Active__c=true and Implementation_Projects__r.Name=:Label.lbl_Master_Project and Account__r.Name=:Label.lbl_Master_Account];
       // RequirementUtility.createCustomerRequirement(customerProject[0].Id,customerProject[0].Account__c);
        System.enqueueJob(new QueueableRequirementUtility(customerProject[0].Id ,customerProject[0].Account__c));
        Test.stopTest();         
        
        List<Test_Case__c> newCustomerRequirement = [Select id from Test_Case__c where Implementation_Projects__c=:customerProject[0].Id];
        System.assertEquals(masterRequirements.size(), newCustomerRequirement.size(), 'Customer Requirement should be equal to master');   
        } 
    
    
    /**********
* Use Case:
*   New customer requirement clone from master with multi levels
*
* State:
*   Method under test: Insert
*
* Expected Result:
*   All fields should be cloned and parent requirment should be set properly in same hierarchy as it is on master records.
**********/
    @isTest
    static void Insert_CustomerRequirment_From_Master_Set_Parent_Requirment_On_Child()
    {        
        List<Implementation_Projects__c> customerProject =[Select id,name,Account__c from Implementation_Projects__c where Name = 'Test PSP Project'];
        Test.startTest();
        List<Test_Case__c> masterRequirements = [Select id,Is_Active__c,Cloning_Level_Assignment__c,Implementation_Projects__r.Name  from Test_Case__c where Is_Active__c=true and Implementation_Projects__r.Name=:Label.lbl_Master_Project and Account__r.Name=:Label.lbl_Master_Account];
        RequirementUtility.createCustomerRequirement(customerProject[0].Id,customerProject[0].Account__c);
        Test.stopTest();  
        
        List<Test_Case__c> newCustomerRequirementFirstLevel = [Select id,recordtypeId,Area__c,Master_Requirement__r.Area_Req__c,Area_Req__c from Test_Case__c where Implementation_Projects__c=:customerProject[0].Id and Cloning_Level_Assignment__c='1st Level Req'];
        System.assert(newCustomerRequirementFirstLevel.size()==2);
        System.assert(newCustomerRequirementFirstLevel[0].recordtypeId == Schema.SObjectType.Test_Case__c.getRecordTypeInfosByName().get('Requirement').getRecordTypeId());
        System.assert(newCustomerRequirementFirstLevel[0].Master_Requirement__r.Area_Req__c == newCustomerRequirementFirstLevel[0].Area_Req__c);
        
        List<Test_Case__c> newCustomerRequirementSecondLevel = [Select id,Parent_Requirement__c,Area__c,Area_Req__c from Test_Case__c where Implementation_Projects__c=:customerProject[0].Id and Cloning_Level_Assignment__c='2nd Level Req'];
        System.assert(newCustomerRequirementSecondLevel.size()==2);
        System.assert(newCustomerRequirementSecondLevel[0].Parent_Requirement__c == newCustomerRequirementFirstLevel[0].Id);
        System.assert(newCustomerRequirementSecondLevel[0].Area__c == newCustomerRequirementFirstLevel[0].Area__c);
        
        
        List<Test_Case__c> newCustomerRequirementThirdLevel = [Select id,Parent_Requirement__c from Test_Case__c where Implementation_Projects__c=:customerProject[0].Id and Cloning_Level_Assignment__c='3rd Level Req'];
        System.assert(newCustomerRequirementThirdLevel[0].Parent_Requirement__c == newCustomerRequirementSecondLevel[0].Id);
        System.assert(newCustomerRequirementThirdLevel.size()==1);
        
        List<Test_Case__c> newCustomerRequirementFourthLevel = [Select id,Parent_Requirement__c from Test_Case__c where Implementation_Projects__c=:customerProject[0].Id and Cloning_Level_Assignment__c='4th Level Req'];
        System.assert(newCustomerRequirementFourthLevel[0].Parent_Requirement__c == newCustomerRequirementThirdLevel[0].Id);
        System.assert(newCustomerRequirementThirdLevel.size()==1);
        
        List<Test_Case__c> newCustomerRequirementFifthLevel = [Select id,Parent_Requirement__c from Test_Case__c where Implementation_Projects__c=:customerProject[0].Id and Cloning_Level_Assignment__c='5th Level Req'];
        System.assert(newCustomerRequirementFifthLevel[0].Parent_Requirement__c == newCustomerRequirementFourthLevel[0].Id);
        System.assert(newCustomerRequirementFifthLevel.size()==1);
        
        List<Test_Case__c> newCustomerRequirementNoLevel = [Select id,Parent_Requirement__c from Test_Case__c where Implementation_Projects__c=:customerProject[0].Id and Cloning_Level_Assignment__c=''];
        System.assert(newCustomerRequirementNoLevel.size()==1);
        System.assert(newCustomerRequirementNoLevel[0].Parent_Requirement__c == null);
        
    }
}