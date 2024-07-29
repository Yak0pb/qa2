@IsTest
private with sharing class ConnectedOrgFailureEmailParserTest {
    private static final String CUSTOM_ERROR_PARSER = 'ConnectedOrgFailureEmailParser';
    private static final String SUBJECT = 'Pharos connection no longer active from org: Acme, Inc';
    private static final String PLAIN_TEXT_BODY = 'Org Id: 00D0000000000A11  ' +
        'Please login to Acme, Inc, delete the connected org and re-create.\n' +
        '\n' +
        'Details:\n' +
        'HttpUtilsException:[]: 400: {"error":"invalid_grant","error_description":"expired access/refresh token"}\n\n' +
        '(pharos)';
  
    @TestSetup
    private static void testSetup() {
      pharos__Pharos_Settings__c pharosSettings = pharos__Pharos_Settings__c.getOrgDefaults();
      pharosSettings.pharos__Custom_Error_Parser__c = CUSTOM_ERROR_PARSER;
      insert pharosSettings;
    }
  
    @IsTest
    static void test_error_parser () {
      Test.startTest();
      pharos.IErrorParser processor = (pharos.IErrorParser)Type.forName('', CUSTOM_ERROR_PARSER).newInstance();
      // Error processing
      processor.init(PLAIN_TEXT_BODY, SUBJECT, 'test@test.com');
      System.assert(processor.canProcess());
      System.assert(processor.getError() != null);
      processor.process();
      System.assertEquals(UserInfo.getUserId(), processor.getUserId());
      System.assertEquals('00D0000000000A11', processor.getOrganizationId());
      System.assertEquals(ConnectedOrgFailureEmailParser.LOG_AREA, processor.getArea());
      System.assertEquals(ConnectedOrgFailureEmailParser.ERROR_TYPE, processor.getErrorType());
      System.assertEquals(SUBJECT, processor.getErrorSummary());
      System.assert(String.isNotBlank(processor.getErrorDetails()));
      System.assert(String.isNotBlank(processor.getHash1()));
      System.assert(String.isNotBlank(processor.getHash2()));
      System.assert(String.isNotBlank(processor.getHash3()));
      System.assertEquals(processor.getHash2(), processor.getHash3());

      System.assert(processor.getCustomInfo() != null);
      System.assert(String.isBlank(processor.getVisualforcePage()));
      System.assert(String.isBlank(processor.getRelatedId()));
      System.assert(String.isBlank(processor.getRelatedObjectType()));
      System.assert(String.isBlank(processor.getAsyncJobName()));
      System.assert(String.isBlank(processor.getAsyncJobId()));
      System.assert(String.isBlank(processor.getStackTrace()));
      System.assert(String.isBlank(processor.parseStackTrace()));
      System.assert(String.isBlank(processor.getMethodName()));
      System.assert(String.isBlank(processor.getPendingJobsInfo()));
      System.assert(String.isBlank(processor.getAuditTrail()));
      System.assert(String.isBlank(processor.getInstalledPackagesInfo()));
      System.assert(String.isBlank(processor.getNamespace()));
      System.assert(String.isBlank(processor.getDeploymentsInfo()));
      System.assert(String.isBlank(processor.getSalesforceErrorId()));
      Test.stopTest();
    }
}