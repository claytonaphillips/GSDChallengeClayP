@isTest
private class AppointmentSchedulerTest{
	static testMethod void validateCreateAppointment(){
        User userOne = new User(
     		ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     		LastName = 'last',
     		Email = 'testuser@test.com',
     		Username = 'testuser@test.com' + System.currentTimeMillis(),
    		CompanyName = 'TEST',
     		Title = 'title',
     		Alias = 'alias',
     		TimeZoneSidKey = 'America/Los_Angeles',
     		EmailEncodingKey = 'UTF-8',
     		LanguageLocaleKey = 'en_US',
     		LocaleSidKey = 'en_US'
		);
        
		insert userOne;
        System.runAs(userOne){
        	Appointment__c appointmentOne = new Appointment__c();
    		appointmentOne.Appointment_Date__c = System.today();
    		appointmentOne.Appointment_Time__c = '11:00 AM';
    		Contact contactOne = new Contact();
    		contactOne.FirstName = 'test';
    		contactOne.LastName = 'test';
            contactOne.email = 'test@test.com';
    		insert contactOne;
    		appointmentOne.Season_Ticket_Holder__c = contactOne.Id;
    		appointmentOne.Appointment_With__c = userOne.Id;
    		insert appointmentOne;   
            
            String result = AppointmentSchedulerController.createAppointment(String.valueOf(System.today()), '11:00 AM', String.valueOf(contactOne.Id));
            System.assertEquals(result, 'That date and time conflicts with another one of your appointments.');
            String appointmentTwoId = AppointmentSchedulerController.createAppointment(String.valueOf(System.today()), '11:30 AM', String.valueOf(contactOne.Id));
            
            List<Appointment__c> appointmentList = [SELECT Id,
                                                   		   Appointment_Date__c,
                                                   		   Appointment_Time__c,
                                                   		   Season_Ticket_Holder__c,
                                                   		   Appointment_With__c
                                                   		   FROM Appointment__c 
                                                           WHERE Id =: appointmentTwoId 
                                                           LIMIT 1];
            
           Appointment__c appointmentTwo = appointmentList[0];
           System.assertEquals(appointmentTwo.Appointment_Date__c, System.today());
           System.assertEquals(appointmentTwo.Appointment_Time__c, '11:30 AM');
           System.assertEquals(appointmentTwo.Season_Ticket_Holder__c, contactOne.Id);
           System.assertEquals(appointmentTwo.Appointment_With__c, userOne.Id);

        }
	}
}