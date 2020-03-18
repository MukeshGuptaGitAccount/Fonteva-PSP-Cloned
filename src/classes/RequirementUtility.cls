public class RequirementUtility {   
    
    private static List<Schema.FieldSetMember> getFields() {
        return SObjectType.Test_Case__c.FieldSets.FSCustomerRequirementClone.getFields();
    }
    public static List<Test_Case__c>  getAllMasterRequirements() {
        List<Test_Case__c> t= new List<Test_Case__c>();
        String query = 'SELECT ';
        String whereClause=' ';
        for(Schema.FieldSetMember f : getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Test_Case__c where Is_Active__c=true and Implementation_Projects__r.Name='+'\''+System.Label.lbl_Master_Project+'\''+' and account__r.name='+'\''+System.Label.lbl_Master_Account+'\'';
        query +=whereClause;
        return Database.query(query);
        
    }
    
    public static List<Test_Case__c> createCustomerRequirement(String projectId,String accountId){
        
        List<Test_Case__c> masterReq = getAllMasterRequirements();         
        
        // Create buckets per level
        List<Test_Case__c> lstCustomerRequirementLevelOne = new List<Test_Case__c>();
        List<Test_Case__c> lstCustomerRequirementLevelTwo = new List<Test_Case__c>();
        List<Test_Case__c> lstCustomerRequirementLevelThree = new List<Test_Case__c>();
        List<Test_Case__c> lstCustomerRequirementLevelFour = new List<Test_Case__c>();
        List<Test_Case__c> lstCustomerRequirementLevelFive = new List<Test_Case__c>();        
        
        
        for(Test_Case__c c:masterReq)
        {
            Test_Case__c customerReq= new Test_Case__c();
            customerReq=c;
            
            customerReq.Implementation_Projects__c = projectId;
            customerReq.Account__c = accountId;
            customerReq.Master_Requirement__c = c.id;
            
            switch on c.Cloning_Level_Assignment__c {
                when '1st Level Req' {	
                    customerReq.Parent_Requirement__c=null;
                    lstCustomerRequirementLevelOne.add(customerReq);                       
                }	
                when '2nd Level Req' {		
                    lstCustomerRequirementLevelTwo.add(customerReq);
                }
                when '3rd Level Req' {		
                    lstCustomerRequirementLevelThree.add(customerReq);
                }
                when '4th Level Req' {		
                    lstCustomerRequirementLevelFour.add(customerReq);
                }
                when '5th Level Req' {		
                    lstCustomerRequirementLevelFive.add(customerReq);
                }
                when else {		  // default block
                    customerReq.Parent_Requirement__c=null;
                    lstCustomerRequirementLevelOne.add(customerReq);
                }
            }                
            
            
        }
        
        Map<Id,Test_Case__c> clonedSecondLevelChildRecords = new Map<Id,Test_Case__c>();
        Map<Id,Test_Case__c> clonedThirdLevelChildRecords = new Map<Id,Test_Case__c>();
        Map<Id,Test_Case__c> clonedFourthLevelChildRecords = new Map<Id,Test_Case__c>();
        Map<Id,Test_Case__c> clonedFifthLevelChildRecords = new Map<Id,Test_Case__c>();
        
        //1st
        Map<Id,Test_Case__c> clonedFirstLevelRecords = cloneParentRecords(lstCustomerRequirementLevelOne);
        insert clonedFirstLevelRecords.values();
        
        //2nd
        if(lstCustomerRequirementLevelTwo.size()>0)
        {
            clonedSecondLevelChildRecords = cloneChildRecords(lstCustomerRequirementLevelTwo,clonedFirstLevelRecords);
            insert clonedSecondLevelChildRecords.values();
        }
        // 3rd
        if(lstCustomerRequirementLevelThree.size()>0)
        {
            clonedThirdLevelChildRecords = cloneChildRecords(lstCustomerRequirementLevelThree,clonedSecondLevelChildRecords);
            insert clonedThirdLevelChildRecords.values();
        }
        //4th
        if(lstCustomerRequirementLevelFour.size()>0)
        {
            clonedFourthLevelChildRecords = cloneChildRecords(lstCustomerRequirementLevelFour,clonedThirdLevelChildRecords);
            insert clonedFourthLevelChildRecords.values();
        }
        // 5th
        if(lstCustomerRequirementLevelFive.size()>0)
        {
            clonedFifthLevelChildRecords = cloneChildRecords(lstCustomerRequirementLevelFive,clonedFourthLevelChildRecords);
            insert clonedFifthLevelChildRecords.values();
        }          
        
        return lstCustomerRequirementLevelOne;
        
    }
    
    private static Map<Id,Test_Case__c> cloneParentRecords(List<Test_Case__c> baseRecords) {
        Map<Id,Test_Case__c> clonedRecords = new Map<Id,Test_Case__c>();
        for (Test_Case__c sObj : baseRecords) {
            Test_Case__c newSObj = new Test_Case__c();
            newSObj = (Test_Case__c)Framework.SObjectUtils.mapObject(sObj,newSObj,false,true);
            clonedRecords.put(sObj.Master_Requirement__c,newSObj);
        }
        
        return clonedRecords;
    }
    
    private static Map<Id,Test_Case__c> cloneChildRecords(List<Test_Case__c> records, Map<Id,Test_Case__c> parents) {
        Map<Id,Test_Case__c> clonedRecords = new Map<Id,Test_Case__c>();
        for (Test_Case__c sObj : records) {
            Test_Case__c newSObj = new Test_Case__c();
            newSObj = (Test_Case__c)Framework.SObjectUtils.mapObject(sObj,newSObj,false,true);
                newSObj.Parent_Requirement__c = parents.get(sObj.Parent_Requirement__c).Id;
                clonedRecords.put(sObj.Master_Requirement__c,newSObj); 
        }
        
        return clonedRecords;
    }      
    
}