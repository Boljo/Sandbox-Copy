@isTest
private class PostSandboxCopyTest {
    
    @isTest
    static void testSandboxPostCopy() {
        Test.startTest();
        new PostSandboxCopy().runApexClass(null);
    }
    
    @isTest
    static void testDataLoaderQueueableExitsEarly() {
        Test.startTest();
        PostSandboxCopy.DataLoaderQueueable job = new PostSandboxCopy.DataLoaderQueueable(999);
        job.execute(null);
        Test.stopTest();
    }
    
    @isTest
    static void testDataLoaderQueueableLastIndex() {
        Test.startTest();
        PostSandboxCopy.DataLoaderQueueable job = new PostSandboxCopy.DataLoaderQueueable(2);
        job.execute(null);
        Test.stopTest();
    }
}