global without sharing class PostSandboxCopy implements SandboxPostCopy {
    
    // Cache the Global Describe ONCE to save CPU limits
    private static Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

    global void runApexClass(SandboxContext context) {
        loadUniversalData('Account', 'ExternalID__c');
        loadUniversalData('Opportunity', 'ExternalID__c');
    }

    private void loadUniversalData(String objectName, String extIdField) {
        if (!Schema.sObjectType.StaticResource.isAccessible()) return;

        List<StaticResource> sr = [SELECT Body FROM StaticResource WHERE Name = :objectName LIMIT 1];
        if (sr.isEmpty()) return;

        String[] lines = sr[0].Body.toString().split('\n');
        String[] headers = lines[0].split(','); 
        
        SObjectType sObjType = globalDescribe.get(objectName);
        SObjectField extIdToken = sObjType.getDescribe().fields.getMap().get(extIdField);
        
        Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
        List<SObject> records = new List<SObject>();

        for (Integer i = 1; i < lines.size(); i++) {
            if (String.isBlank(lines[i])) continue; 
            
            String[] cols = lines[i].split(',(?=([^\"]*\"[^\"]*\")*[^\"]*$)');
            SObject record = sObjType.newSObject(); 
            
            for (Integer j = 0; j < headers.size(); j++) {
                if (j >= cols.size()) continue; 
                
                String header = headers[j].trim();
                String val = cols[j].trim().removeStart('"').removeEnd('"');
                
                if (String.isBlank(val)) continue; 

                if (header.contains('.')) {
                    String[] parts = header.split('\\.'); 
                    String parentObjName = parts[0];
                    
                    if (parentObjName.endsWith('__r')) {
                        parentObjName = parentObjName.substring(0, parentObjName.length() - 1) + 'c';
                    }

                    SObjectType parentType = globalDescribe.get(parentObjName);
                    if (parentType != null) {
                        SObject parent = parentType.newSObject();
                        parent.put(parts[1], val);
                        record.putSObject(parts[0], parent);
                    }
                } else {
                    Schema.DisplayType fType = fieldMap.get(header)?.getDescribe().getType();
                    
                    if (fType == Schema.DisplayType.DATE) {
                        record.put(header, Date.valueOf(val));
                    } else if (fType == Schema.DisplayType.DATETIME) {
                        record.put(header, Datetime.valueOf(val));
                    } else if (fType == Schema.DisplayType.BOOLEAN) {
                        record.put(header, Boolean.valueOf(val));
                    } else if (fType == Schema.DisplayType.CURRENCY || fType == Schema.DisplayType.DOUBLE || fType == Schema.DisplayType.PERCENT) {
                        record.put(header, Decimal.valueOf(val));
                    } else if (fType == Schema.DisplayType.INTEGER) {
                        record.put(header, Integer.valueOf(val));
                    } else {
                        record.put(header, val); 
                    }
                }
            }
            records.add(record);
        }
        
        if (!records.isEmpty() && sObjType.getDescribe().isCreateable() && sObjType.getDescribe().isUpdateable()) {
            Database.upsert(records, extIdToken, false);
        }
    }
}