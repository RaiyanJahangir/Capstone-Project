// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into 
// Firestore under the path /messages/:documentId/original
exports.addMessage = functions.https.onRequest(async (req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  // Push the new message into Firestore using the Firebase Admin SDK.
  const writeResult = await admin.firestore().collection('messages').add({original: original});
  // Send back a message that we've successfully written the message
  res.json({result: `Message with ID: ${writeResult.id} added.`});
});

// Listens for new messages added to /messages/:documentId/original and creates an
// uppercase version of the message to /messages/:documentId/uppercase
exports.makeUppercase = functions.firestore.document('/messages/{documentId}')
    .onCreate((snap, context) => {
      // Grab the current value of what was written to Firestore.
      const original = snap.data().original;

      // Access the parameter `{documentId}` with `context.params`
      functions.logger.log('Uppercasing', context.params.documentId, original);
      
      const uppercase = original.toUpperCase();
      
      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to Firestore.
      // Setting an 'uppercase' field in Firestore document returns a Promise.
      return snap.ref.set({uppercase}, {merge: true});
    });

exports.changeOfSensorData = functions.database.ref('Sensor Data/Pulse Rate')
    .onUpdate(evt => {
        const payload = {
            notification:{
                title : 'HEALTH ALERT',
                body : 'Your baby\'s pulse rate is abnormal',
                badge : '1',
                sound : 'default'
            }
        };
    
        return admin.database().ref('fcm-token').once('value').then(allToken => {
           // if(allToken.val() && evt.after.val() == 'yes'){
                if(evt.after.val() >100){
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
        var timeStamp = Date.now();
        var date = new Date(timeStamp);
        let Timestamp = date.toString();        
        Timestamp=Timestamp.slice(0,24);

        return change.after.ref.update({Timestamp});
    });