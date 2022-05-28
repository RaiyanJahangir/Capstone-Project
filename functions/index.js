// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.


// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');

const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);


exports.highPulseRate = functions.database.ref('Sensor Data/Pulse Rate')
    .onUpdate(evt => {
        const payload = {
            notification:{
                title : 'HEALTH ALERT',
                body : 'Your baby\'s pulse rate is very high',
                badge : '1',
                sound : 'default'
            }
        };
    
        return admin.database().ref('fcm-token').once('value').then(allToken => {
           // if(allToken.val() && evt.after.val() == 'yes'){
            if(allToken.val() && evt.after.val() >100){
                console.log('token available');
                const token = Object.keys(allToken.val());
                return admin.messaging().sendToDevice(token,payload);
            }else{
                console.log('No token available');
            }
        });
    });

exports.lowPulseRate = functions.database.ref('Sensor Data/Pulse Rate')
    .onUpdate(evt => {
        const payload = {
            notification:{
                title : 'HEALTH ALERT',
                body : 'Your baby\'s pulse rate is very low',
                badge : '1',
                sound : 'default'
            }
        };
    
        return admin.database().ref('fcm-token').once('value').then(allToken => {
           // if(allToken.val() && evt.after.val() == 'yes'){
            if(allToken.val() && evt.after.val() <70){
                console.log('token available');
                const token = Object.keys(allToken.val());
                return admin.messaging().sendToDevice(token,payload);
            }else{
                console.log('No token available');
            }
        });
    });

exports.highTempRate = functions.database.ref('Sensor Data/Temperature')
    .onUpdate(evt => {
        const payload = {
            notification:{
                title : 'HEALTH ALERT',
                body : 'Your baby\'s body temperature is very high',
                badge : '1',
                sound : 'default'
            }
        };
    
        return admin.database().ref('fcm-token').once('value').then(allToken => {
           // if(allToken.val() && evt.after.val() == 'yes'){
            if(allToken.val() && evt.after.val() >36.8){
                console.log('token available');
                const token = Object.keys(allToken.val());
                return admin.messaging().sendToDevice(token,payload);
            }else{
                console.log('No token available');
            }
        });
    });

exports.lowTempRate = functions.database.ref('Sensor Data/Temperature')
    .onUpdate(evt => {
        const payload = {
            notification:{
                title : 'HEALTH ALERT',
                body : 'Your baby\'s body temperature is very low',
                badge : '1',
                sound : 'default'
            }
        };

    //     var today = new Date();
    //     var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
    //     var time = ((parseInt(today.getHours())+6)%24)+ ":" + today.getMinutes() + ":" + today.getSeconds();
    //     var Timestamp = date+' '+time;

    // var notifRef=admin.database().ref(notification);
    // notifRef.set({
    //     title: "Health Alert",
    //     body: 'Your baby\'s body temperature is very low',
    //     timestamp: Timestamp
    // });
    
    
        return admin.database().ref('fcm-token').once('value').then(allToken => {
           // if(allToken.val() && evt.after.val() == 'yes'){
            if(allToken.val() && evt.after.val() <28.0){
                console.log('token available');
                const token = Object.keys(allToken.val());
                return admin.messaging().sendToDevice(token,payload);
            }else{
                console.log('No token available');
            }
        });
    });

exports.onMessageUpdate=functions.database.ref('Sensor Data').onUpdate((change,context)=>{
        const before=change.before.val();
        const after=change.after.val();
        if(before['Pulse Rate']===after['Pulse Rate']){
            console.log(before.text+' '+after.text);
            return null;
        }

        //calculating timestamp
        // var timeStamp = Date.now();
        // var date = new Date(timeStamp);
        // let Timestamp = date.toString();        
        // Timestamp=Timestamp.slice(0,24);

        var today = new Date();
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate();
        var time = ((parseInt(today.getHours())+6)%24)+ ":" + today.getMinutes() + ":" + today.getSeconds();
        var Timestamp = date+' '+time;

        return change.after.ref.update({Timestamp});
    });

exports.onCryDetection = functions.database.ref('Sensor Data/Cry')
    .onUpdate(evt => {
        const payload = {
            notification:{
                title : 'Cry ALERT',
                body : 'Your baby is crying. Give a check',
                badge : '1',
                sound : 'default'
            }
        };
    
        return admin.database().ref('fcm-token').once('value').then(allToken => {
           // if(allToken.val() && evt.after.val() == 'yes'){
            if(allToken.val() && evt.after.val()=== 'YES'){
                console.log('token available');
                const token = Object.keys(allToken.val());
                return admin.messaging().sendToDevice(token,payload);
            }else{
                console.log('No token available');
            }
        });
    });