/*
     Copyright 2016 Revelant Technologies LLC

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.


*********************************************************************************************************
** Class Name  : CTDAssociationController
** Created By  : Revelant Technologies
*                    Revelant Team - info@revelanttech.com
** Created Date: April 2016
** Description : Example of how auto logging can be used to track quality and adherence within a call
** Change Log  : 
********************************************************************************************************/

public class CTDAssociationController {
    
    private String AccountId;
    
    /********************************************************************************************************
    ** Constructor Name:  CTDAssociationController
    ** Description     :  Standard constructor for the class
    ** Return type     :  none
    ** Annotation      :  none
    ** Constructor Type:  Default
    ** Parameters
    *       @param stdController -ApexPages.StandardController- extension for a standard controller.
    ** Change Log      : 
    ********************************************************************************************************/
    public CTDAssociationController(ApexPages.StandardController stdController) {
        //AccountId = stdController.getId();            //standard functionality commented out for demo
        AccountId = '0013600000Gn4ss';                  //Demo purposes only
    }

    /********************************************************************************************************
    ** Method Name : getacc
    ** Created By  : Revelant Technologies
    *                   Revelant Team - info@revelanttech.com
    ** Created Date: April 2016
    ** Description : getter method for acc
    ** Return type : Account
    ** Annotation  : none
    ** Method Type : Instance
    ** Parameters  : none
    ** Change Log  : 
    ********************************************************************************************************/
    public Account getacc() {
        Account oAccount = [select Id, Name, Type, ParentId, Industry from Account where Id =: AccountId];
        return oAccount;
    }

    /********************************************************************************************************
    ** Method Name : getJsonSales
    ** Created By  : Revelant Technologies
    *                   Revelant Team - info@revelanttech.com
    ** Created Date: April 2016
    ** Description : Returns all opportunities, contacts, and leads related to the account Id
    ** Return type : String
    ** Annotation  : none
    ** Method Type : Instance
    ** Parameters  : none
    ** Change Log  : 
    ********************************************************************************************************/
    public String getJsonSales() {
        List<SObject> objects = new List<SObject>();  

        List<Opportunity> oppty = [SELECT id, name, Type FROM Opportunity where AccountId =: AccountId];
        System.debug(LoggingLevel.INFO,'*****OPPORTUNITIES: '+ oppty);
        List<Contact> oContacts = [SELECT id, name FROM Contact where AccountId =: AccountId AND Sales_Contact__c = true];
        System.debug(LoggingLevel.INFO,'*****CONTACTS: '+ oContacts);
        List<Lead> oLead = [Select Id, Name From Lead where Company LIKE '%Revelant%' ];
        System.debug(LoggingLevel.INFO,'*****LEADS: '+ oLead);
        
        for (Opportunity opp: oppty) {
            objects.add(opp);
        }
        for (Lead ld: oLead) {
            objects.add(ld);
        }
        for (Contact con: oContacts) {
            objects.add(con);
        }
            
        return JSON.serialize(objects);
    }

    /********************************************************************************************************
    ** Method Name : getJsonService
    ** Created By  : Revelant Technologies
    *                   Revelant Team - info@revelanttech.com
    ** Created Date: April 2016
    ** Description : Returns all cases, and contacts related to the account Id
    ** Return type : String
    ** Annotation  : none
    ** Method Type : Instance
    ** Parameters  : none
    ** Change Log  : 
    ********************************************************************************************************/
    public String getJsonService() {
        List<SObject> objects = new List<SObject>();
        
        List<Case> cases = [SELECT id, Subject, Type FROM case where AccountId =: AccountId order by LastModifiedDate DESC LIMIT 3];
        System.debug(LoggingLevel.INFO,'*****CASES: '+ cases);
        List<Contact> oContacts = [SELECT id, name FROM Contact where AccountId =: AccountId AND Service_Contact__c = true];
        System.debug(LoggingLevel.INFO,'*****CONTACTS: '+ oContacts); 

        for (Case c: cases) {
            objects.add(c);
        }
        for (Contact con: oContacts) {
            objects.add(con);
        }
        
        String myJSON = JSON.serialize(objects);
        System.debug(LoggingLevel.INFO,'*****myJSON: '+ myJSON); 
        String paramJSON = myJSON.replace('Subject','Name');        
        System.debug(LoggingLevel.INFO,'*****paramJSON: '+ paramJSON);
         
        return paramJSON;
    }

    /********************************************************************************************************
    ** Method Name : getJsonCombined
    ** Created By  : Revelant Technologies
    *                   Revelant Team - info@revelanttech.com
    ** Created Date: May 2016
    ** Description : Returns all cases, opportunities, leads, and contacts related to the account Id
    ** Return type : String
    ** Annotation  : none
    ** Method Type : Instance
    ** Parameters  : none
    ** Change Log  : 
    ********************************************************************************************************/
    public String getJsonCombined() {
        List<SObject> objects = new List<SObject>();
        
        List<Case> cases = [SELECT id, Subject, Type, LastModifiedDate FROM case where AccountId =: AccountId order by LastModifiedDate DESC LIMIT 3];
        System.debug(LoggingLevel.INFO,'*****CASES: '+ cases);
        List<Contact> oContacts = [SELECT id, name FROM Contact where AccountId =: AccountId];
        System.debug(LoggingLevel.INFO,'*****CONTACTS: '+ oContacts);
        List<Opportunity> oppty = [SELECT id, name, Type FROM Opportunity where AccountId =: AccountId];
        System.debug(LoggingLevel.INFO,'*****OPPORTUNITIES: '+ oppty);
        List<Lead> oLead = [Select Id, Name From Lead where Company LIKE '%Revelant%' ];
        System.debug(LoggingLevel.INFO,'*****LEADS: '+ oLead);

        for (Case c: cases) {
            objects.add(c);
        }
        for (Contact con: oContacts) {
            objects.add(con);
        }
        for (Opportunity opp: oppty) {
            objects.add(opp);
        }
        for (Lead ld: oLead) {
            objects.add(ld);
        }
        
        String myJSON = JSON.serialize(objects);
        System.debug(LoggingLevel.INFO,'*****myJSON: '+ myJSON); 
        String paramJSON = myJSON.replace('Subject','Name');        
        System.debug(LoggingLevel.INFO,'*****paramJSON: '+ paramJSON);
         
        return paramJSON;
    }
}