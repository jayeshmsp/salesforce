public with sharing  class VolunteerApplicationSave{
    public List <SelectOption> skillOptions{ get;set;}
    public List <SelectOption> skillOptions2 {get;set;}
    public List <SelectOption> Volunteer_Availability {get;set;}
    public contactparking__c objrecord{get;set;}
    public contact therecord{get;set;}
    public Boolean showpage1 {get;set;}
    public Boolean showpage {get;set;}
    public string contactFirstname{get;set;}
    public string orientationstatus{get;set;}
    public string contactMS{get;set;}
    public string contactMCT{get;set;} 
    public string contactMST{get;set;}
    public string contactMPC{get;set;}               
    public string contactlastname{get;set;}
    public string contactEmail{get;set;}
    public string contactPhone{get;set;}
    public string ContactProgramofInterest{get;set;}
    public string ContactTypeyourname{get;set;}
    public string contactphonetype{get;set;}
    public string remail   {get;set;}
    public string rfname{get;set;}
    public string rlname{get;set;}
    public string rphone{get;set;}
    public string recordid{get;set;}
    public string recordUid{get;set;}
    public string rprofile{get;set;}    
   // public string recordemail{get;set;}
    public boolean displayPopup {get;set;}
    public boolean displayPopup1 {get;set;}
    public Contact con {get; set;}
    public ApexPages.StandardController concontroller {get;set;}
    public PageReference redirect {get;set; }
    public PageReference upredirect {get;set; }
    public List < String > skillsets { get;set;}
    public List < String > skillsets_vol {get;set;}
    public  String  Email{get;set;}
    public  String  phone{get;set;}
    public  id  ID{get;set;}
    public PageReference pageRef {get;set;}
    
    public VolunteerApplicationSave(Apexpages.standardcontroller controller)
        {
       
        
        recordid= ApexPages.currentpage().getparameters().get('id');
        recordUid= ApexPages.currentpage().getparameters().get('uid');
        rEmail= ApexPages.currentpage().getparameters().get('Email');
        rphone= ApexPages.currentpage().getparameters().get('phone');
        rfname= ApexPages.currentpage().getparameters().get('fname');
        rlname= ApexPages.currentpage().getparameters().get('lname');
        rprofile= ApexPages.currentpage().getparameters().get('profile');
       
    
        skillOptions2 = new List < selectoption > ();
        Volunteer_Availability = new List < selectoption > ();
        objrecord= new contactparking__c();
        skillsets = new List < String > ();
        skillsets_vol = new List < String > ();
       this.concontroller = controller;
        con = (Contact) controller.getRecord();
        try{ if(recordid==null&&ApexPages.currentPage().getParameters().containsKey('phone')==true&&rphone<>''){con.Primary_Phone__c =rphone;con.Primary_Phone_Type__c='Mobile';}}catch(exception e){}
        try{if(recordid==null&&recorduid<>null){con.Taoe_User_Id__c=recorduid;}}catch(exception e){}
        try{if(recordid==null&&remail<>null){con.npe01__HomeEmail__c =remail;}}catch(exception e){}
        try{if(recordid==null&&rfname<>null){con.FirstName=rfname;}}catch(exception e){}
        try{if(recordid==null&&rlname<>null){con.lastname =rlname;}}catch(exception e){}
     
        if(recordid<>null||id<>null)
        { 
        
        try
        {
        skillOptions = new List < SelectOption> ();
        retrieveSkillOptions2();
        }
        Catch(Exception e){}
        contact therecord=[SELECT Id,Taoe_User_Id__c, GW_Volunteers__Volunteer_Skills__c,npe01__Preferred_Email__c, Name, FirstName,npe01__HomeEmail__c,Type_Your_Name_to_Agree_to_Terms_Below__c, LastName,npe01__WorkEmail__c ,Email, Primary_Phone__c, Primary_Phone_Type__c,npe01__PreferredPhone__c, GW_Volunteers__Volunteer_Availability__c, Mailing_Street__c,MailingStreet,Mailing_City__c, MailingCity, Mailing_State__c,MailingState, Mailing_Postal_Code__c,MailingPostalCode, Volunteer_Orientation_Status__c, Volunteer_Skills_List__c, Volunteer_Application_Status__c, Program_of_Interest__c, Programs_Approved_For__c, Drivers_License_Status__c, Insurance_Card_Status__c, Workshop_Observation_Status__c,Phone FROM Contact WHERE Id =: recordid];
        
        con=therecord;
        contactlastname=therecord.lastname;
        contactFirstname=therecord.FirstName;
        contactEmail=therecord.Email;
        orientationstatus=therecord.Volunteer_Orientation_Status__c;
        system.debug('***'+orientationstatus);
        //ContactTypeyourname=therecord.Type_Your_Name_to_Agree_to_Terms_Below__c;
        contactphonetype=therecord.npe01__PreferredPhone__c;
        contactphone=therecord.Phone;     
        contactMS=therecord.Mailing_Street__c;
        contactMCT=therecord.Mailing_City__c;
        contactMST=therecord.Mailing_State__c;
        contactMPC=therecord.Mailing_Postal_Code__c;
        system.debug('@@@@@@@@@'+therecord.Program_of_Interest__c);
        ContactProgramofInterest=therecord.Program_of_Interest__c;

            try
        {
            if(therecord.Volunteer_Skills_List__c!=null)
            {
                if(!string.valueof(therecord.Volunteer_Skills_List__c).contains(';'))
                    {
                        skillsets.add(therecord.Volunteer_Skills_List__c);
                    }
                    else
                    {
                         skillsets = therecord.Volunteer_Skills_List__c.split(';');
                    }
            }
             if(therecord.GW_Volunteers__Volunteer_Availability__c!=null)
            {
                if(!string.valueof(therecord.GW_Volunteers__Volunteer_Availability__c).contains(';'))
                    {
                        skillsets_vol.add(therecord.GW_Volunteers__Volunteer_Availability__c);
                    }
                    else
                    {
                         skillsets_vol= therecord.GW_Volunteers__Volunteer_Availability__c.split(';');
                    }
            }   
        system.debug('*********'+skillsets);
        system.debug('*******'+skillsets_vol);
        
        }
        Catch(nullPointerException e)//it will catch null pointer exception if fields value will be blank.
        {
                system.debug('error is '+e);
        }
        }
        else
        { 
        retrieveSkillOptions2();
        }
        system.debug('===1==='+objrecord);
    }
   
    public void retrieveSkillOptions2() {
        Schema.DescribeFieldResult fieldResult = Contact.Volunteer_Skills_List__c.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
        system.debug(ple + '51');
        for (Schema.PicklistEntry f: ple) {
            skillOptions2.add(new selectoption(f.getLabel(), f.getValue()));
        }
        Schema.DescribeFieldResult fieldResult_vol = Contact.GW_Volunteers__Volunteer_Availability__c.getDescribe();
        List < Schema.PicklistEntry > ple_vol = fieldResult_vol.getPicklistValues();
        system.debug(ple + '51');
        for (Schema.PicklistEntry f: ple_vol) {
            Volunteer_Availability.add(new selectoption(f.getLabel(), f.getValue()));
        }
    }
    public pagereference fncredirect()
    {
        System.debug('inside fncredirect');
        Pagereference pgStubLogin=new pagereference('https://taoe.ddslis.com/2VaYeJ1U/index.php');
        boolean flag=AuthenticateUser.compareSecurityToken();
        if(!flag){
            return pgStubLogin;
        }
        Pagereference pg=new pagereference('/apex/Disabled_page');
        pg.setRedirect(true);
         if(rprofile<>'true'&&rprofile<>'false'||rprofile==''){return pg;}else{} 
         if(recordid==null&&rprofile=='true'){return pg;} else{}
         if(ApexPages.currentPage().getParameters().containsKey('id')==false&&ApexPages.currentPage().getParameters().containsKey('uid')==True&&rprofile=='False'&&ApexPages.currentPage().getParameters().containsKey('fname')==True&&ApexPages.currentPage().getParameters().containsKey('lname')==True&&ApexPages.currentPage().getParameters().containsKey('email')==True){} else{}        
         if(ApexPages.currentPage().getParameters().containsKey('id')==false&&ApexPages.currentPage().getParameters().containsKey('uid')==false&&rprofile=='False'&&ApexPages.currentPage().getParameters().containsKey('fname')==false&&ApexPages.currentPage().getParameters().containsKey('lname')==false&&ApexPages.currentPage().getParameters().containsKey('email')==false){return pg;} else{}        
         if(ApexPages.currentPage().getParameters().containsKey('id')==false&&ApexPages.currentPage().getParameters().containsKey('uid')==false&&rprofile=='False'||ApexPages.currentPage().getParameters().containsKey('id')==false&&rprofile=='False'&&ApexPages.currentPage().getParameters().containsKey('fname')==false||ApexPages.currentPage().getParameters().containsKey('id')==false&&rprofile=='False'&&ApexPages.currentPage().getParameters().containsKey('lname')==false||ApexPages.currentPage().getParameters().containsKey('id')==false&&rprofile=='False'&&ApexPages.currentPage().getParameters().containsKey('email')==false){return pg;} else{}
         if(recordid==null&&rprofile=='false'&&recorduid==''){return pg;} else{}
         if(recordid==null&&rprofile=='false'&&rfname==''){return pg;} else{}
         if(recordid==null&&rprofile=='false'&&rlname==''){return pg;} else{}
         if(recordid==null&&rprofile=='false'&&remail==''){return pg;} else{}
        return null;
    }
    public VolunteerApplicationSave(){
      if(recordid<>null){
        contact therecord=[SELECT Id, GW_Volunteers__Volunteer_Skills__c,npe01__Preferred_Email__c, Name, FirstName,npe01__HomeEmail__c,Type_Your_Name_to_Agree_to_Terms_Below__c, LastName,npe01__WorkEmail__c ,Email, Primary_Phone__c, Primary_Phone_Type__c,npe01__PreferredPhone__c, GW_Volunteers__Volunteer_Availability__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, Volunteer_Orientation_Status__c, Volunteer_Skills_List__c, Volunteer_Application_Status__c, Program_of_Interest__c, Programs_Approved_For__c, Drivers_License_Status__c, Insurance_Card_Status__c, Workshop_Observation_Status__c,Phone FROM Contact WHERE Id =: recordid];
        contactlastname=therecord.lastname;
        }
        system.debug('===3==='+objrecord);
    }
    
    public pagereference updateData(){
        
        //contact therecord=[SELECT Id, GW_Volunteers__Volunteer_Skills__c,npe01__Preferred_Email__c, Name, FirstName,npe01__HomeEmail__c,Type_Your_Name_to_Agree_to_Terms_Below__c, LastName,npe01__WorkEmail__c ,Email, Primary_Phone__c, Primary_Phone_Type__c,npe01__PreferredPhone__c, GW_Volunteers__Volunteer_Availability__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, Volunteer_Orientation_Status__c, Volunteer_Skills_List__c, Volunteer_Application_Status__c, Program_of_Interest__c, Programs_Approved_For__c, Drivers_License_Status__c, Insurance_Card_Status__c, Workshop_Observation_Status__c,Phone FROM Contact WHERE Id =: recordid];
         // contactlastname=therecord.lastname;
       
         saveRecord1();
         system.debug('===2==='+objrecord);
         objrecord.contact_id__c=recordid;
         objrecord.Contact__c=recordid;
         objrecord.LastName__c=contactlastname;
         objrecord.VolanEmail__c=contactEmail;
         objrecord.FirstName__c=contactFirstname;
         objrecord.volanMailing_city__c =contactMCT;
         objrecord.volanMailing_state__c    =contactMST;
         objrecord.volanMailing_street__c=contactMS;
         objrecord.voalnmailing_zip__c  =contactMPC;
         objrecord.volanPhone_type__c   =contactphonetype;
         objrecord.volanProgram_of_interest__c= ContactProgramofInterest;
        
         objrecord.volanphone__c    =contactphone;
         
         upsert objrecord contact_id__c;
         //showPopup();
         return NULL;
    }
      public ApexPages.PageReference saveRecord1() 
    {
      // I can do custom logic here before I save the record.
       
        
        ApexPages.StandardController controller = new ApexPages.StandardController(con);
           String skills = '';
        Boolean Start = true;
       
       if (!skillsets.isEmpty()) {
        
            for (String Str: skillsets) {
                if (Start) {
                    skills = Str;
                    Start = false;
                }
                else 
                {
                    skills = skills + ';' + Str;
                }
            }
        }     
        String skillsVOL = '';
        Boolean StartVOL = true;
       
        if (!skillsets_vol.isEmpty()) {
       
            for (String Str: skillsets_vol) {
                if (StartVOL) {
                    skillsVOL = Str;
                    StartVOL = false;
                } 
                else 
                {
                    skillsVOL = skillsVOL + ';' + Str;
                }
            }
        }
        
        con.Volunteer_Skills_List__c = String.join(skillsets, ';');
        con.GW_Volunteers__Volunteer_Availability__c = String.join(skillsets_vol, ';');
        system.debug('**********AMIT**'+String.join(skillsets_vol, ';'));
        system.debug('**********AMIT**'+con.Volunteer_Skills_List__c);
        system.debug('**********AMIT**'+skills);
        system.debug('**********AMIT**'+ con.GW_Volunteers__Volunteer_Availability__c);
        try{if(recordid==null){con.Program_of_Interest__c=ContactProgramofInterest;}}catch(exception e){}


     //   con.GW_Volunteers__Volunteer_Availability__c  = skillsVOL;
        if(recordid == null)
        {
       
        try 
    {
        system.debug('prgramofinetreset'+ContactProgramofInterest);
        concontroller.save();
        id = concontroller.getId();
        system.debug('**********con id**'+ id);
         
        try{if(id<>null){
        contact therecord=[SELECT Id,Taoe_User_Id__c, GW_Volunteers__Volunteer_Skills__c,npe01__Preferred_Email__c, Name, FirstName,npe01__HomeEmail__c,Type_Your_Name_to_Agree_to_Terms_Below__c, LastName,npe01__WorkEmail__c ,Email, Primary_Phone__c, Primary_Phone_Type__c,npe01__PreferredPhone__c, GW_Volunteers__Volunteer_Availability__c, Mailing_Street__c,MailingStreet,Mailing_City__c, MailingCity, Mailing_State__c,MailingState, Mailing_Postal_Code__c,MailingPostalCode, Volunteer_Orientation_Status__c, Volunteer_Skills_List__c, Volunteer_Application_Status__c, Program_of_Interest__c, Programs_Approved_For__c, Drivers_License_Status__c, Insurance_Card_Status__c, Workshop_Observation_Status__c,Phone FROM Contact WHERE  Id =:id ];
        contactlastname=therecord.lastname;
        contactFirstname=therecord.FirstName;
        contactEmail=therecord.Email;
        orientationstatus=therecord.Volunteer_Orientation_Status__c;
        system.debug('***'+orientationstatus);
        //ContactTypeyourname=therecord.Type_Your_Name_to_Agree_to_Terms_Below__c;
        contactphonetype=therecord.npe01__PreferredPhone__c;
        contactphone=therecord.Phone;     
        contactMS=therecord.Mailing_Street__c;
        contactMCT=therecord.Mailing_City__c;
        contactMST=therecord.Mailing_State__c;
        contactMPC=therecord.Mailing_Postal_Code__c;
        system.debug('@@@@@@@@@'+therecord.Program_of_Interest__c);
        ContactProgramofInterest=therecord.Program_of_Interest__c;
        }}Catch(Exception e){}
      
       
        showpopup();
       // PageReference pageRef = new PageReference('/apex/CalendarDashboardV2?id='+id);
       // pageRef.setRedirect(true);
        //return pageref; 
        
       // closePopup();       

         
    } 
        catch(Exception e)
    {
        return null;       
    }
    }
    else
    {
        try 
    {
        controller.save();
        concontroller.save();
        if(orientationstatus<>null){showpopup();}else if(orientationstatus==null){showpopup1();}
          }
        catch(Exception e)
    {
        return null;       
    }     
    }
   // return null;
        
        return null;
    }
    public pagereference redirectpage()
    {
        redirect = new PageReference('/');
        redirect.setRedirect(false);
        return redirect;
    }
     public pagereference updateredirectpage()
    {
        upredirect = new PageReference('CalendarDashboardV2?id='+recordid+'&profile=false');
        upredirect.setRedirect(true);
        return upredirect;
    }
    public void closePopup1()
    {
        displayPopup1 = false;
    }
     public void closePopup() 
    {
        displayPopup = false;
        updateredirectpage();
    }
    public void showPopup() 
    {
        displayPopup = true;
    }
    public void showPopup1() 
    {
        displayPopup1 = true;
    }
   
     public List<SelectOption> options { get; set; }
  {
    options = new List<SelectOption>();
    options.add(new SelectOption('','--None--')); 
    options.add(new SelectOption('Home', 'Home' ));
    options.add(new SelectOption('Work', 'Work'));
    options.add(new SelectOption('Mobile', 'Mobile'));
    options.add(new SelectOption('Other', 'Other'));
  }

   
    public List<SelectOption> options1 { get; set; }
  {
    options1 = new List<SelectOption>();
    options1.add(new SelectOption('','--None--')); 
    options1.add(new SelectOption('Fashion and Design', 'Fashion and Design'));
    options1.add(new SelectOption('Music and Movement', 'Music and Movement'));
    options1.add(new SelectOption( 'Theatre and Film',  'Theatre and Film'));
    options1.add(new SelectOption('Visual Arts', 'Visual Arts'));
  }
          
        
}