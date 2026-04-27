@isTest
private class PostSandboxCopyTest {
    
    @isTest
    static void testSandboxPostCopy() {
        Test.startTest();
        new PostSandboxCopy().runApexClass(null);
        Test.stopTest();
    }
}