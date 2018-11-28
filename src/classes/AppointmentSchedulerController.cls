public class AppointmentSchedulerController{
    
    @AuraEnabled
    Public Static String createAppointment(String appointmentDate, String appointmentTime, String contactId){
    	String resultMessage = '';
        Appointment__c appointment = new Appointment__c();
        appointment.Appointment_Date__c = Date.valueOf(appointmentDate);
        appointment.Appointment_Time__c	= appointmentTime;
        appointment.Season_Ticket_Holder__c = contactId;
        appointment.Appointment_With__c = UserInfo.getUserId();
        //insert appointment;
        List<Appointment__c> appointmentList = getUserAppointments();
        boolean scheduleConflict = false;
        
        for(Appointment__c appointmentOne: appointmentList){
            if(appointmentOne.Appointment_Date__c == Date.valueOf(appointmentDate) && appointmentOne.Appointment_Time__c == appointmentTime){
                scheduleConflict = true;
            }    
        }
        if(scheduleConflict == false){
        	try{
    			insert appointment;
                sendEmail(contactId, appointment.Id);
                resultMessage = appointment.Id;
			}
        
        	catch(DmlException e){
    			System.debug('The following exception has occurred: ' + e.getMessage());
                resultMessage = 'The following exception has occurred: ' + e.getMessage();
			}
        }
        else{
            resultMessage = 'That date and time conflicts with another one of your appointments.';
        }
		
        return resultMessage;
		
    }
    
    @AuraEnabled
    Public Static List<Appointment__c> getUserAppointments(){
        String userId = UserInfo.getUserId();
        List<Appointment__c> appointmentList = [SELECT Id,
                          		  					   Appointment_Date__c,
                          		                       Appointment_Time__c,
                          		                       Season_Ticket_Holder__r.Name
                          		                       FROM Appointment__c WHERE Appointment_With__c =: userId];
        return appointmentList;        
    }
    
    Public Static void sendEmail(String contactId, String appointmentId){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
		mail.setTargetObjectId(contactId); 
        mail.setWhatId(appointmentId);
		mail.setSenderDisplayName('New York Jedi Masters'); 
		mail.setUseSignature(false); 
		mail.setBccSender(false); 
		mail.setSaveAsActivity(false); 
		EmailTemplate emailTemplate = [Select Id FROM EmailTemplate where DeveloperName =: 'Appointment_Confirmation' LIMIT 1]; 
		mail.setTemplateId(emailTemplate.Id); 
		Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        System.debug('result: ' + r);
    }
}