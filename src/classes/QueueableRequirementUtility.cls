public class QueueableRequirementUtility implements Queueable {
    Public String projectId;
    Public String projectAccountId;
    
	public QueueableRequirementUtility(String prId ,String prAccId) {
       
        projectId = prId;
        projectAccountId = prAccId;
    }
    public void execute(QueueableContext context) {
        List<Test_Case__c> reqList = RequirementUtility.createCustomerRequirement(projectId, projectAccountId);
        if(reqList.size() > 0){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { UserInfo.getUserEmail() };
            message.subject = System.Label.Email_Subject;
            message.htmlbody = System.Label.Email_Body;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }
}