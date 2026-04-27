This is an implementation of PostSandboxCopy

Requirements:

- Have the CSV files ready as static resource for each object you want to run this class for.
- Static resource should have the api name of the object
- CSV Headers should contain the field api names of the object

You modify which objects you wanna run this for in this part of the code:

/*
private static List<Map<String, String>> DATA_CONFIG = new List<Map<String, String>>{
        new Map<String, String>{'obj' => 'Account', 'extId' => 'Account_External_ID'},
        new Map<String, String>{'obj' => 'Contact', 'extId' => 'Contact_External_ID'},
        new Map<String, String>{'obj' => 'Opportunity', 'extId' => 'Opportunity_External_ID'}
    };

*/