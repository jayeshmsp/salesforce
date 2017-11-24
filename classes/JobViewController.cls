public with sharing class JobViewController {
    public List<ShiftWrapper> jobShifts {get;set;}
    public Id selectedShiftId {get;set;}
    public Boolean isShifSignedUp {get;set;}
    public Boolean isShifSignedUpAndConfirm {get;set;}
    public Id selectedHourId {get;set;}
    public Boolean canceledByOrganization {get;set;}
    public String conId {get; set;}
    
    private Id recId;
    private String shiftId;
    private String contactId;
    
    public JobViewController(Apexpages.StandardController stdCtrl) {
        canceledByOrganization = false;
        conId = '';
        recId = stdCtrl.getRecord().Id;
        shiftId = ApexPages.currentPage().getParameters().get('shiftId');  
        contactId = Apexpages.currentPage().getParameters().get('conId');
        doInIt();
    }
    
    public void doInIt() {
        if(recId != null) {
            jobShifts = new List<ShiftWrapper>();
            isShifSignedUp = false;
            isShifSignedUpAndConfirm = false;
            conId = contactId;
            String hourId;     
            isShifSignedUp = null;     
            for(GW_Volunteers__Volunteer_Shift__c  shift : [ SELECT Id,GW_Volunteers__Number_of_Volunteers_Still_Needed__c ,Shift_Start_Date__c,GW_Volunteers__Start_Date_Time__c,GW_Volunteers__Duration__c,
                            GW_Volunteers__System_Note__c,GW_Volunteers__Description__c,GW_Volunteers__Total_Volunteers__c,
                                (SELECT Id,GW_Volunteers__Status__c FROM GW_Volunteers__Volunteer_Hours__r WHERE GW_Volunteers__Contact__c =: contactId )
                          FROM GW_Volunteers__Volunteer_Shift__c WHERE Id =: shiftId ]) {
               
               if(shift.GW_Volunteers__Volunteer_Hours__r.size() > 0 ) {
                   hourId = shift.GW_Volunteers__Volunteer_Hours__r[0].Id;
                   isShifSignedUp = true;
                   if(shift.GW_Volunteers__Volunteer_Hours__r[0].GW_Volunteers__Status__c != 'Canceled')
                       isShifSignedUpAndConfirm = true;
                   else
                       isShifSignedUpAndConfirm = false;
                }
               jobShifts.add(new ShiftWrapper(shift,hourId )); 
            }
            
        }
    }
    public Pagereference isValidToken(){
        Pagereference pgStubLogin=new pagereference('https://taoe.ddslis.com/2VaYeJ1U/index.php');
        boolean flag=AuthenticateUser.compareSecurityToken();
         if(!flag){
            return pgStubLogin;
        }
        return null;    
    }
    public void cancelHour() {
        GW_Volunteers__Volunteer_Hours__c hour = [SELECT GW_Volunteers__Status__c FROM GW_Volunteers__Volunteer_Hours__c WHERE Id =: selectedHourId];
        hour.GW_Volunteers__Status__c = 'Canceled';
        update hour;
        doInIt();
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
        doInIt();
    }
    
    public void createVolunteerHour() {
        GW_Volunteers__Volunteer_Shift__c  shift = [SELECT Id,GW_Volunteers__Number_of_Volunteers_Still_Needed__c ,Shift_Start_Date__c,GW_Volunteers__Start_Date_Time__c,GW_Volunteers__Duration__c,
                            GW_Volunteers__System_Note__c,GW_Volunteers__Description__c,GW_Volunteers__Total_Volunteers__c,Shift_End_Date__c
                          FROM GW_Volunteers__Volunteer_Shift__c WHERE Id =: selectedShiftId ];
    
        GW_Volunteers__Volunteer_Hours__c volunteerHour = new GW_Volunteers__Volunteer_Hours__c();
        volunteerHour.GW_Volunteers__Contact__c = Apexpages.currentPage().getParameters().get('conId');
        volunteerHour.GW_Volunteers__Volunteer_Shift__c = shift.Id;
        volunteerHour.GW_Volunteers__Volunteer_Job__c = Apexpages.currentPage().getParameters().get('Id');
        volunteerHour.GW_Volunteers__Start_Date__c = shift.Shift_Start_Date__c;
        volunteerHour.GW_Volunteers__End_Date__c = shift.Shift_End_Date__c;
        volunteerHour.GW_Volunteers__Planned_Start_Date_Time__c = shift.GW_Volunteers__Start_Date_Time__c;
        volunteerHour.GW_Volunteers__Hours_Worked__c = shift.GW_Volunteers__Duration__c;
        volunteerHour.GW_Volunteers__Number_of_Volunteers__c = 1;
        volunteerHour.GW_Volunteers__Status__c = 'Web Sign Up';
        
        insert volunteerHour;
        doInIt();
    }
    
    public class ShiftWrapper {
        public String startDay {get;set;}
        public String startDate {get;set;}
        public String shiftTime {get;set;}
        public String confirmed {get;set;}
        public String available {get;set;}
        public GW_Volunteers__Volunteer_Shift__c shift {get;set;}
        public String hourId {get;set;}
        
        public ShiftWrapper(GW_Volunteers__Volunteer_Shift__c shift,String hourId) {
            this.shift = shift;
            this.hourId = hourId;
            this.startDay = shift.GW_Volunteers__Start_Date_Time__c.format('EEEE');
            this.startDate = shift.GW_Volunteers__Start_Date_Time__c.format('M/dd/yyyy');
            this.shiftTime = Shift.GW_Volunteers__Start_Date_Time__c.format('h:mm a',UserInfo.getTimeZone().toString()) +
                            ' - ' + Shift.GW_Volunteers__Start_Date_Time__c.addHours(Integer.valueOf(Shift.GW_Volunteers__Duration__c)).format('h:mm a',UserInfo.getTimeZone().toString());
            this.confirmed = (shift.GW_Volunteers__Total_Volunteers__c != null ? shift.GW_Volunteers__Total_Volunteers__c: 0) + '';
            this.available = (shift.GW_Volunteers__Number_of_Volunteers_Still_Needed__c != null ? shift.GW_Volunteers__Number_of_Volunteers_Still_Needed__c: 0) + '';
        }
    }
}