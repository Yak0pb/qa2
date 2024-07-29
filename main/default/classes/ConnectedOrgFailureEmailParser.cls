global with sharing class ConnectedOrgFailureEmailParser implements pharos.IErrorParser {

    private static final String ERROR_START = 'Pharos connection no longer active from org:';
    @TestVisible
    private static final String ERROR_TYPE = 'Org Connectivity';
    private static final String ERROR_CATEGORY = 'Error';
    @TestVisible
    private static final String LOG_AREA = 'Connected Orgs';
    private static final Pattern ORG_ID_PATTERN = Pattern.compile('Org Id:\\s*(00D\\w+)');

    private String emailSubject;
    private String emailSentFrom;
    private String errorBody;
    private String organizationId;

    global virtual String getOrganizationId() {
        return this.organizationId;
    }

    global virtual String getUserId() {
        return UserInfo.getUserId();
    }

    global virtual Boolean canProcess() {
        return String.isNotBlank(emailSubject) && emailSubject.contains(ERROR_START);
    }

    global virtual void init(String errorBody, String emailSubject, String emailSentFrom) {
        this.errorBody = String.isNotBlank(errorBody) ? errorBody.stripHtmlTags() : '';
        this.emailSubject = emailSubject;
        this.emailSentFrom = emailSentFrom;

        Matcher m = ORG_ID_PATTERN.matcher(this.errorBody);
        this.organizationId = m.find() ? m.group(1) : UserInfo.getOrganizationId();
    }

    global virtual void process() {}

    global virtual String getError() {
        return this.emailSubject;
    }

    global virtual String getErrorSummary() {
        return this.emailSubject;
    }

    global virtual String getErrorDetails() {
        return this.errorBody;
    }

    global virtual String getErrorType() {
        return ERROR_TYPE;
    }

    global virtual String getArea() {
        return LOG_AREA;
    }

    global virtual String getCategory() {
        return ERROR_CATEGORY;
    }

    global virtual String getStackTrace() {
        return null;
    }
    
    global virtual String parseStackTrace() {
        return null;
    }
    
    global virtual String getMethodName() {
        return null;
    }

    global virtual String getVisualforcePage() {
        return null;
    }
    
    global virtual String getRelatedId() {
        return null;
    }
    
    global virtual String getRelatedObjectType() {
        return null;
    }
    
    global virtual String getAsyncJobName() {
        return null;
    }
    
    global virtual String getAsyncJobId() {
        return null;
    }    

    global virtual String getPendingJobsInfo() {
        return null;
    }
    
    global virtual Decimal getTotalActiveSessions() {
        return null;
    }

    global virtual String getAuditTrail() {
        return null;
    }

    global virtual String getInstalledPackagesInfo() {
        return null;
    }

    global virtual String getNamespace() {
        return null;
    }

    global virtual String getDeploymentsInfo() {
        return null;
    }

    global virtual String getFlowVersion() {
        return null;
    }

    global virtual String getSalesforceErrorId() {
        return null;
    }
    
    global virtual List<Queueable> getAsyncMethods(Id logId) {
        List<Queueable> asyncMethods = new List<Queueable>();
        return asyncMethods;
    }
        
    global virtual List<pharos.ICustomErrorInfo> getCustomInfo() {
        List<pharos.ICustomErrorInfo> customFields = new List<pharos.ICustomErrorInfo>{
            new CategoryField(this.getCategory())
        };
        return customFields;
    }

    global class CategoryField implements pharos.ICustomErrorInfo {
        global String category;
        global CategoryField(String value) {
            this.category = value;
        }
        global String getValue() {
            return this.category;
        }
        global String getLogFieldName() {
            return Schema.sObjectType.pharos__Log__c.fields.pharos__Category__c.getName();
        }
    }

    private String generateHash(String value) {
        if(value == null) value = '';
        return EncodingUtil.base64Encode(Crypto.generateDigest('SHA-256', Blob.valueOf(value)));
    }

    global virtual String getHash1() {
        return generateHash(this.emailSubject);
    }

    global virtual String getHash2() {
        return generateHash(ERROR_TYPE);
    }

    global virtual String getHash3() {
        return generateHash(ERROR_TYPE);
    }
}