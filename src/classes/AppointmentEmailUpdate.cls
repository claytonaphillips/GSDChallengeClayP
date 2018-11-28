global class AppointmentEmailUpdate implements Messaging.InboundEmailHandler{

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        if(email.plainTextBody.containsIgnoreCase('ok') || email.plainTextBody.containsIgnoreCase('yes') || email.plainTextBody.containsIgnoreCase('confirmed')){
            String appointmentNumber = email.subject.right(email.subject.length()-email.subject.indexOf('Appointment Number: ') - 20);
            System.debug('appointment number: ' + appointmentNumber);
            List<Appointment__c> appointmentList = [SELECT Id FROM Appointment__c WHERE Name =: appointmentNumber];
            Appointment__c appointment = appointmentList[0];	
            appointment.Confirmed__c = true;
            update appointment;
            System.debug('appointment: ' + appointment);
        }
        result.success = true;
    	return result; 
	}
}