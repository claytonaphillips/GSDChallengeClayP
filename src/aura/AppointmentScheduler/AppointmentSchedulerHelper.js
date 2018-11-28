({
	newAppointment : function(component, event, helper){
        var action = component.get("c.createAppointment");
        var appointmentDate = component.find("appointmentDate").get("v.value");
        var dateString = appointmentDate.toString()
        console.log('JSON Date: ' + dateString);
        var appointmentTime = component.find("appointmentTime").get("v.value");
        var contactId = component.get("v.recordId");
        console.log('appointment date: ' + appointmentDate + ' appointment time: ' + appointmentTime + ' contact Id: ' + contactId);
        
        action.setParams({ 
            appointmentDate : dateString, 
            appointmentTime : appointmentTime,
            contactId: contactId
        });
        
        action.setStorable();
       
        console.log('Contact Id: ' + component.get("v.recordId"));

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                alert(returnValue);
            }
         
            else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                    }
                } 
                else{
                    console.log("Unknown error");
                }
            }
        });   
        
         $A.enqueueAction(action);
    },
    
    getAppointments : function(component, event, helper){
    	var action = component.get("c.getUserAppointments");
              
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returnValue = response.getReturnValue();
                console.log('return value: ' + returnValue);
                component.set("v.appointmentList", returnValue);
                
            }
         
            else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                    }
                } 
                else{
                    console.log("Unknown error");
                }
            }
        });   
        
         $A.enqueueAction(action);    
    }
})