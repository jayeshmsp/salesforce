public without sharing class CalendarDashboardControllerV2 {
    
    // Global Variables Added by Ravi - OutstripInfotech
    private final Contact con;
    public Boolean isActiveVolunteer {get;set;}
    
    public Boolean stage1 {get;set;}
    public Boolean stage2 {get;set;}
    public Boolean stage3 {get;set;}
    public Boolean stage4 {get;set;}
    public Boolean stage5 {get;set;}
    public Boolean stage6 {get;set;}
    public Integer stageForEvents {get;set;}
    public Contact selectedContact {get;set;}
    public List < OptionWrapper > skillOptions {get;set;}
    public List < SelectOption > skillOptions2 {get;set;}
    public Id selectedHourId {get;set;}
    public Boolean canceledByOrganization {get;set;}
    public String defaultDropdownValue {get; set;}
    
    public CalendarDashboardControllerV2(ApexPages.StandardController std) {
        con = (Contact)std.getRecord();
        defaultDropdownValue  = 'Available Shifts';
        skillOptions2 = new List < selectoption > ();
        stage1 = false;
        stage2 = false;
        stage3 = false;
        stage4 = false;
        stage5 = false;
        stage6 = false;
        canceledByOrganization = false;
        if (con.Id != null) {
            selectedContact = [SELECT Id, GW_Volunteers__Volunteer_Status__c, GW_Volunteers__Volunteer_Skills__c, Name,npe01__HomeEmail__c,npe01__PreferredPhone__c,Phone, FirstName, LastName, Email, Primary_Phone__c, Primary_Phone_Type__c, GW_Volunteers__Volunteer_Availability__c, Mailing_Street__c, Mailing_City__c, Mailing_State__c, Mailing_Postal_Code__c, Volunteer_Orientation_Status__c, Volunteer_Skills_List__c, Volunteer_Application_Status__c, Program_of_Interest__c, Programs_Approved_For__c, Drivers_License_Status__c, Insurance_Card_Status__c, Workshop_Observation_Status__c,DAIS_Tag__c FROM Contact WHERE Id =: con.Id];
            if (selectedContact.GW_Volunteers__Volunteer_Status__c == 'Inactive') {
                //return redirectErrorPage();
                selectedContact.Id = null;
                retrieveSkillOptions2();
            } else {
                skillOptions = new List < OptionWrapper > ();
                retrieveSkillOptions();
                //stage = 0;
                stageForEvents = 0;
                if (selectedContact.Volunteer_Application_Status__c == 'Completed' && selectedContact.Volunteer_Orientation_Status__c != 'Completed') {
                    stageForEvents = 1;
                } else if (selectedContact.Volunteer_Application_Status__c == 'Completed' && selectedContact.Volunteer_Orientation_Status__c == 'Completed') {
                    stageForEvents = 2;
                }
                if (selectedContact.Volunteer_Application_Status__c == 'Completed' )
                    stage1 = true;
                if (selectedContact.Volunteer_Orientation_Status__c == 'Completed' )
                    stage2 = true;
                if (selectedContact.Drivers_License_Status__c == 'Submitted' )
                    stage3 = true;
                if (selectedContact.Insurance_Card_Status__c == 'Submitted' )
                    stage4 = true;
                if (selectedContact.Workshop_Observation_Status__c != null) 
                    stage5 = true;
                if (selectedContact.Workshop_Observation_Status__c == 'Completed')
                    stage6 = true;
                selectedContact.Primary_Phone__c= selectedContact.Phone ;
                selectedContact.npe01__HomeEmail__c = selectedContact.Email;
                selectedContact.Primary_Phone_Type__c = selectedContact.npe01__PreferredPhone__c;
            }
        } else {
            retrieveSkillOptions2();
        }
    }
    
    /* isValidContact verify valid URL params
     * Added by Ravi - OutstripInfotech
     */
    public PageReference isValidContact(){
        Boolean isValidUrl = true;
        String conId = apexpages.currentpage().getparameters().get('Id');
        String profile = apexpages.currentpage().getparameters().get('profile');
        //code Added by Keyur Shah to validate security token
        Pagereference pgStubLogin=new pagereference('https://taoe.ddslis.com/2VaYeJ1U/index.php');
        String urlToken=ApexPages.currentpage().getParameters().get('DAIS_tag');
        boolean flag=AuthenticateUser.compareSecurityToken();
        System.debug('conId ---'+conId);
        System.debug('profile--'+profile);
        if(conId == null || profile == null){
            isValidURL = false;
        } else if(!conId.startsWith('003')) {
            isValidURL = false;
        } else if(profile!='true' && profile!='false' ) {
            isValidURL = false;
        }
        if(!flag){
           return pgStubLogin;
        }
        if (!isValidUrl){
            return redirectErrorPage();
        }
        if(flag && isValidUrl){
           boolean tokenChanged=false;
           if(selectedContact!=null && selectedContact.DAIS_Tag__c!=null && selectedContact.DAIS_Tag__c!=''){
               if(!selectedContact.DAIS_Tag__c.equals(urlToken)){
                   selectedContact.DAIS_Tag__c=urlToken;
                   tokenChanged=true;       
               }
           }
           if(selectedContact!=null && (selectedContact.DAIS_Tag__c==null || selectedContact.DAIS_Tag__c=='')){
                   selectedContact.DAIS_Tag__c=urlToken;
                   tokenChanged=true;        
           }
           if(selectedContact!=null && tokenChanged){
               update selectedContact;
           } 
           return null;
        } 
        return null;
    }
    
    
    
    /* redirectErrorPage redirect to Disabled_page if any Error occurs
     * Added by Ravi - OutstripInfotech
     */
    public PageReference redirectErrorPage(){
        System.debug('T4esting null check');
        PageReference retURL = new PageReference('/apex/Disabled_page');
        retURL.setRedirect(true);
        return retURL;
    }
    
    public void retrieveSkillOptions() {
        system.debug('test' + 50);
        Set < String > selectedOptions = new Set < String > ();
        if (selectedContact.Volunteer_Skills_List__c != null) selectedOptions = new Set < String > (selectedContact.Volunteer_Skills_List__c.split(';'));
        Schema.DescribeFieldResult fieldResult = Contact.Volunteer_Skills_List__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            if (selectedOptions.contains(f.getValue()))
                skillOptions.add(new OptionWrapper(f.getLabel(), f.getValue(),true));
            else
                skillOptions.add(new OptionWrapper(f.getLabel(), f.getValue(),false));
        }
    }
    public void retrieveSkillOptions2() {
        Schema.DescribeFieldResult fieldResult = Contact.Volunteer_Skills_List__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
        system.debug(ple + '51');
        for (Schema.PicklistEntry f: ple) {
            //  if(selectedOptions.contains(f.getValue()))
            //     skillOptions2.add(new OptionWrapper(f.getLabel(), f.getValue(),true));
            //   else
            skillOptions2.add(new selectoption(f.getLabel(), f.getValue()));
        }
    }
    
    public void cancelHour() {
        GW_Volunteers__Volunteer_Hours__c hour = [SELECT GW_Volunteers__Status__c FROM GW_Volunteers__Volunteer_Hours__c WHERE Id =: selectedHourId];
        hour.GW_Volunteers__Status__c = 'Canceled';
        update hour;
    }
    
    public void uncancelHour() {
        canceledByOrganization = false;
        GW_Volunteers__Volunteer_Hours__c hour = [SELECT GW_Volunteers__Status__c,Canceled_by_Organization__c FROM GW_Volunteers__Volunteer_Hours__c WHERE Id =: selectedHourId];
        if(hour.Canceled_by_Organization__c) {
            canceledByOrganization = true;
        }
        else {
            hour.GW_Volunteers__Status__c = 'Web Sign Up';
            update hour;
        }
    }
    
    public List<GW_Volunteers__Volunteer_Hours__c> getMyWaitingList() {
        DateTime timeNow = DateTime.now();
        System.debug('## calling..');
        if(selectedContact != null)
           
            return [SELECT Id,Volunteer_Job_ID__c,GW_Volunteers__Volunteer_Shift__c,Volunteer_Job_Name__c,GW_Volunteers__Planned_Start_Date_Time__c,GW_Volunteers__Shift_Start_Date_Time__c FROM GW_Volunteers__Volunteer_Hours__c 
                WHERE GW_Volunteers__Contact__c =: selectedContact.Id AND GW_Volunteers__Planned_Start_Date_Time__c >= : timeNow AND (GW_Volunteers__Status__c = 'Web Sign Up' or GW_Volunteers__Status__c = 'Prospect')  ORDER BY GW_Volunteers__Shift_Start_Date_Time__c ];
        else
            return new List<GW_Volunteers__Volunteer_Hours__c>();
    }
    
    public List<GW_Volunteers__Volunteer_Hours__c> getMyConfirmList() {
        DateTime timeNow = DateTime.now();
        if(selectedContact != null)
            return [SELECT Id,Volunteer_Job_ID__c,GW_Volunteers__Volunteer_Shift__c,Volunteer_Job_Name__c,GW_Volunteers__Planned_Start_Date_Time__c,GW_Volunteers__Shift_Start_Date_Time__c FROM GW_Volunteers__Volunteer_Hours__c 
                WHERE GW_Volunteers__Contact__c =: selectedContact.Id AND GW_Volunteers__Planned_Start_Date_Time__c >= : timeNow AND GW_Volunteers__Status__c = 'Confirmed' ORDER BY GW_Volunteers__Shift_Start_Date_Time__c ];
        else
            return new List<GW_Volunteers__Volunteer_Hours__c>();
    }
    
    public List<GW_Volunteers__Volunteer_Hours__c> getMyCancelList() {
        DateTime timeNow = DateTime.now();
        if(selectedContact != null)
            return [SELECT Id,Volunteer_Job_ID__c,GW_Volunteers__Volunteer_Shift__c,Volunteer_Job_Name__c,GW_Volunteers__Planned_Start_Date_Time__c,GW_Volunteers__Shift_Start_Date_Time__c FROM GW_Volunteers__Volunteer_Hours__c 
                WHERE GW_Volunteers__Contact__c =: selectedContact.Id AND GW_Volunteers__Planned_Start_Date_Time__c >= : timeNow AND GW_Volunteers__Status__c = 'Canceled'  ORDER BY GW_Volunteers__Shift_Start_Date_Time__c ];
        else
            return new List<GW_Volunteers__Volunteer_Hours__c>();
    }
    
    
    @remoteAction
    public static String retrieveWaitingShifts(String contactId, String dateString, Integer stage,String dais_tag) {
        DateTime timeNow = DateTime.now();
        Set<Id> shifIds = new Set<Id>();
        for(GW_Volunteers__Volunteer_Hours__c volHours : [SELECT Id,Volunteer_Job_ID__c,GW_Volunteers__Volunteer_Shift__c,Volunteer_Job_Name__c,GW_Volunteers__Planned_Start_Date_Time__c,GW_Volunteers__Shift_Start_Date_Time__c FROM GW_Volunteers__Volunteer_Hours__c 
                WHERE GW_Volunteers__Contact__c =: contactId AND GW_Volunteers__Planned_Start_Date_Time__c >= : timeNow AND (GW_Volunteers__Status__c = 'Web Sign Up' or GW_Volunteers__Status__c = 'Prospect') And GW_Volunteers__Volunteer_Shift__c != null ORDER BY GW_Volunteers__Shift_Start_Date_Time__c ]){
            shifIds.add(volHours.GW_Volunteers__Volunteer_Shift__c);
        }
        if(shifIds.size() > 0){
            List < String > dateStringList = dateString.split('#'); //2017-05-29#2017-07-03
            Date startDate = Date.parse(dateStringList[0]);
            Date endDate = Date.parse(dateStringList[1]);
            
            List < ShiftWrapper > volunteerShiftList = new List < ShiftWrapper > ();
            for (GW_Volunteers__Volunteer_Shift__c volunteerShift: [SELECT Id, Name, GW_Volunteers__Start_Date_Time__c, GW_Volunteers__Duration__c, GW_Volunteers__Volunteer_Job__c, Volunteer_Job_Name__c, GW_Volunteers__Number_of_Volunteers_Still_Needed__c, GW_Volunteers__Total_Volunteers__c
                    FROM GW_Volunteers__Volunteer_Shift__c
                    WHERE Id in :shifIds
                    AND Start_Date_Formula__c >=: startDate
                    AND Start_Date_Formula__c <=: endDate
                    AND Show_on_Volunteer_Portal_Calendar__c = true
                ]) {
                volunteerShiftList.add(new ShiftWrapper(volunteerShift, contactId,dais_tag));
            }
            String shiftJson = JSON.serialize(volunteerShiftList);
            shiftJson = shiftJson.replace('endDate', 'end');
            return shiftJson;
            
        }
        return null;
    }
    
    @remoteAction
    public static String retrieveConfirmationShifts(String contactId, String dateString, Integer stage,String dais_tag) {
        DateTime timeNow = DateTime.now();
        Set<Id> shifIds = new Set<Id>();
        for(GW_Volunteers__Volunteer_Hours__c volHours : [SELECT Id,Volunteer_Job_ID__c,GW_Volunteers__Volunteer_Shift__c,Volunteer_Job_Name__c,GW_Volunteers__Planned_Start_Date_Time__c,GW_Volunteers__Shift_Start_Date_Time__c FROM GW_Volunteers__Volunteer_Hours__c 
                WHERE GW_Volunteers__Contact__c =: contactId AND GW_Volunteers__Planned_Start_Date_Time__c >= : timeNow AND GW_Volunteers__Status__c = 'Confirmed' And GW_Volunteers__Volunteer_Shift__c != null ORDER BY GW_Volunteers__Shift_Start_Date_Time__c ]){
            shifIds.add(volHours.GW_Volunteers__Volunteer_Shift__c);
        }
        if(shifIds.size() > 0){
            List < String > dateStringList = dateString.split('#'); //2017-05-29#2017-07-03
            Date startDate = Date.parse(dateStringList[0]);
            Date endDate = Date.parse(dateStringList[1]);
            
            List < ShiftWrapper > volunteerShiftList = new List < ShiftWrapper > ();
            for (GW_Volunteers__Volunteer_Shift__c volunteerShift: [SELECT Id, Name, GW_Volunteers__Start_Date_Time__c, GW_Volunteers__Duration__c, GW_Volunteers__Volunteer_Job__c, Volunteer_Job_Name__c, GW_Volunteers__Number_of_Volunteers_Still_Needed__c, GW_Volunteers__Total_Volunteers__c
                    FROM GW_Volunteers__Volunteer_Shift__c
                    WHERE Id in :shifIds
                    AND Start_Date_Formula__c >=: startDate
                    AND Start_Date_Formula__c <=: endDate
                    AND Show_on_Volunteer_Portal_Calendar__c = true
                ]) {
                volunteerShiftList.add(new ShiftWrapper(volunteerShift, contactId,dais_tag));
            }
            String shiftJson = JSON.serialize(volunteerShiftList);
            shiftJson = shiftJson.replace('endDate', 'end');
            return shiftJson;
            
        }
        return null;
    }
    
    public class OptionWrapper {
        public String label {get;set;}
        public String val {get;set;}
        public Boolean selected {get;set;}
        public OptionWrapper(String label, String val, Boolean selected) {
            this.label = label;
            this.val = val;
            this.selected = selected;
        }
    }
    public void updateContact() {
        String skills = '';
        for (OptionWrapper option: skillOptions) {
            if (option.selected) skills += skills == '' ? option.val : ';' + option.val;
        }
        selectedContact.Volunteer_Skills_List__c = skills;
        selectedContact.npe01__Preferred_Email__c = 'Personal';
        update selectedContact;
    }
    
    @remoteAction
    public static String retrieveShifts(String contactId, String dateString, Integer stage,String dais_tag) {
        Boolean flag = true;
        Integer phase = 1;
        Contact selectedContact = [SELECT Id, Name, Volunteer_Orientation_Status__c, Volunteer_Application_Status__c, Workshop_Observation_Status__c, Program_of_Interest__c, Programs_Approved_For__c, GW_Volunteers__Volunteer_Status__c FROM Contact WHERE Id =: contactId];
        
        if (stage >= 2 && selectedContact.Workshop_Observation_Status__c == null) {
            flag = false;
        } else if (stage >= 2 && (selectedContact.Workshop_Observation_Status__c == 'Approved' || selectedContact.Workshop_Observation_Status__c == 'Scheduled')) {
            phase = 2;
        } else if (stage >= 2 && (selectedContact.Workshop_Observation_Status__c == 'Completed')) {
            phase = 3;
        }
        /*if (selectedContact.GW_Volunteers__Volunteer_Status__c == 'Inactive') {
            flag = false;
        }*/
        if (flag) {
            List < String > dateStringList = dateString.split('#'); //2017-05-29#2017-07-03
            Date startDate = Date.parse(dateStringList[0]);
            Date endDate = Date.parse(dateStringList[1]);
            Set < Id > volunteersJobIdSet = new Set < Id > ();
            if (stage == 1) {
                for (GW_Volunteers__Volunteer_Job__c volunteerJob: [SELECT Id, Program_Discipline_2__c FROM GW_Volunteers__Volunteer_Job__c WHERE Name = 'Volunteer Artist Orientation']) {
                    volunteersJobIdSet.add(volunteerJob.Id);
                }
            } else if (stage >= 2 && phase == 2) {
                for (GW_Volunteers__Volunteer_Job__c volunteerJob: [SELECT Id, Program_Discipline_2__c FROM GW_Volunteers__Volunteer_Job__c WHERE Name != 'Volunteer Artist Orientation'
                        AND Job_Type__c = 'Programs - Workshops' AND Program_Discipline_2__c =: selectedContact.Program_of_Interest__c
                    ]) {
                    volunteersJobIdSet.add(volunteerJob.Id);
                }
            } else if (stage >= 2 && phase == 3) {
                List < String > deciplineOptions = new List < String > ();
                if (selectedContact.Programs_Approved_For__c != null) {
                    deciplineOptions = selectedContact.Programs_Approved_For__c.split(';');
                }
                for (GW_Volunteers__Volunteer_Job__c volunteerJob: [SELECT Id, Program_Discipline_2__c FROM GW_Volunteers__Volunteer_Job__c WHERE Name != 'Volunteer Artist Orientation'
                        AND(Program_Discipline_2__c IN: deciplineOptions OR Program_Discipline_2__c = null)
                    ]) {
                    volunteersJobIdSet.add(volunteerJob.Id);
                }
            }
            List < ShiftWrapper > volunteerShiftList = new List < ShiftWrapper > ();
            for (GW_Volunteers__Volunteer_Shift__c volunteerShift: [SELECT Id, Name, GW_Volunteers__Start_Date_Time__c, GW_Volunteers__Duration__c, GW_Volunteers__Volunteer_Job__c, Volunteer_Job_Name__c, GW_Volunteers__Number_of_Volunteers_Still_Needed__c, GW_Volunteers__Total_Volunteers__c
                    FROM GW_Volunteers__Volunteer_Shift__c
                    WHERE GW_Volunteers__Volunteer_Job__c IN: volunteersJobIdSet
                    AND Start_Date_Formula__c >=: startDate
                    AND Start_Date_Formula__c <=: endDate
                    AND Show_on_Volunteer_Portal_Calendar__c = true
                ]) {
                volunteerShiftList.add(new ShiftWrapper(volunteerShift, contactId,dais_tag));
            }
            String shiftJson = JSON.serialize(volunteerShiftList);
            shiftJson = shiftJson.replace('endDate', 'end');
            return shiftJson;
        }
        return null;
    }
    public class ShiftWrapper {
        public String id {get;set;}
        public String title {get;set;}
        public String start {get;set;}
        public String endDate {get;set;}
        public Boolean allDay {get;set;}
        public String url {get;set;}
        public String conf {get;set;}
        public String avail {get;set;}
        public String jobId {get;set;}
        public ShiftWrapper(GW_Volunteers__Volunteer_Shift__c volunteerShift, String conID,String dais_tag) {
            PageReference jobViewPage = Page.JobView;
            jobViewPage.getParameters().put('Id', jobId);
            this.id = (String) volunteerShift.Id;
            this.title = volunteerShift.Volunteer_Job_Name__c;// + ' ' + volunteerShift.GW_Volunteers__Start_Date_Time__c.format('h:mm a', UserInfo.getTimeZone().toString()) + ' to ' + volunteerShift.GW_Volunteers__Start_Date_Time__c.addHours(Integer.valueOf(volunteerShift.GW_Volunteers__Duration__c)).format('h:mm a', UserInfo.getTimeZone().toString());
            this.start = volunteerShift.GW_Volunteers__Start_Date_Time__c.format('MM/dd/yyyy HH:mm:ss', UserInfo.getTimeZone().toString());
            this.endDate = volunteerShift.GW_Volunteers__Start_Date_Time__c.addHours(Integer.valueOf(volunteerShift.GW_Volunteers__Duration__c)).format('MM/dd/yyyy HH:mm:ss', UserInfo.getTimeZone().toString());
            this.allDay = false;
            this.avail = '' + volunteerShift.GW_Volunteers__Number_of_Volunteers_Still_Needed__c;
            this.conf = '' + volunteerShift.GW_Volunteers__Total_Volunteers__c;
            this.jobid = (String) volunteerShift.GW_Volunteers__Volunteer_Job__c;
            this.url = '/apex/JobView?id=' + jobId + '&conId=' + conId + '&shiftId=' + volunteerShift.Id+'&DAIS_tag='+dais_tag;
        }
    }
}