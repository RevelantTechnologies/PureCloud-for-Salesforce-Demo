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
** Class Name  : ContactScreenPopController
** Created By  : Revelant Technologies
*                    Revelant Team - info@revelanttech.com
** Created Date: April 2016
** Description : Pop an external call to a Case pre-associated with Bob Braun (Contact)
**               and Revelant Technologies (Account)
**               This is not necessary when screen popping by the ANI.  We did not have access to the ANI
**               for our demo.  Therefore, this controls the process flow.
** Change Log  : 
********************************************************************************************************/



public class ContactScreenPopController {

    public Case oCase {get;Set;}
    public String id {get; set;}

    public ContactScreenPopController() {
        id='';
    }

    public void createNewCase() {
        System.debug('***************************** Case Creation Start');
        oCase = new Case();
        oCase.ContactId = [select Id from Contact where name LIKE 'Bob Braun' LIMIT 1].Id;
        oCase.AccountId = [select Id from Account where name LIKE 'Revelant Technologies' LIMIT 1].Id;
        oCase.Status = 'Working';
        oCase.Origin = 'Phone';
        oCase.subject = 'Inbound Call';
        oCase.Call_Object_Id__c = id.replaceAll('\"','');
        System.debug('***************************** id ' + id );
        insert oCase;
        System.debug('***************************** Case Creation End');
    }
}