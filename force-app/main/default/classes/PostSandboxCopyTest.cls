@isTest
private class PostSandboxCopyTest {
    
    @isTest
    static void testSandboxPostCopy() {
        // 1. Create fake context IDs required by the interface
        Id orgId = UserInfo.getOrganizationId();
        Id sandboxId = UserInfo.getOrganizationId(); 
        
        // 2. Instantiate your script
        PostSandboxCopy script = new PostSandboxCopy();
        
        Test.startTest();
        // 3. Salesforce's native method to trigger the SandboxPostCopy logic
        Test.testSandboxPostCopyScript(script, orgId, sandboxId, 'DevSandbox');
        Test.stopTest();
        
        // 4. Verify the results
        // Safety Check: Only assert if the Static Resources actually exist in this org
        Integer resourceCount = [SELECT COUNT() FROM StaticResource WHERE Name IN ('Account', 'Opportunity')];
        
        if (resourceCount > 0) {
            List<Account> insertedAccounts = [SELECT Id, Name, ExternalID__c FROM Account];
            System.assert(insertedAccounts.size() > 0, 'Accounts should have been inserted from the CSV.');
            
            List<Opportunity> insertedOpps = [SELECT Id, Name, AccountId FROM Opportunity];
            System.assert(insertedOpps.size() > 0, 'Opportunities should have been inserted from the CSV.');
            
            // Verify that the __r relationship mapping worked
            System.assertNotEquals(null, insertedOpps[0].AccountId, 'Opportunity should be properly linked to the Account.');
        }
    }
}