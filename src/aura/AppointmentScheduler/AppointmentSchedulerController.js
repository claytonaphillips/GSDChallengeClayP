({
	onInit : function(component, event, helper) {
        var today = new Date();
        component.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        helper.getAppointments(component, event, helper);
    },
    
    newAppointment : function(component, event, helper){
    	helper.newAppointment(component, event, helper); 
        console.log('Email: ' + component.get("v.simpleRecord.Email"));
    }
})