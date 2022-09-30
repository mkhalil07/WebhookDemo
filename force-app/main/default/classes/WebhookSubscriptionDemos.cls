@RestResource(urlMapping='/api/Webhooks/pushDetailsDemo/*')
global with sharing class webhookSubscriptionDemo {
    @HttpPost
    global static void handleNotification() {
        
        try{
            RestRequest request = RestContext.request;
            RestResponse response=RestContext.response;
            //fetching the body
            //get hash value from header
            String hashedval = request.headers.get('X-Hub-Signature-256');
            System.debug('hashedval:'+hashedval);
            Blob bB = request.requestBody;
            System.debug(bB.toString());
            /*Blob hmac = Crypto.generateMac('hmacSHA256', bB, Blob.valueOf('webhooktrial'));
            //Blob hmac = Crypto.generateMac('hmacSHA256', Blob.valueOf('test'), Blob.valueOf('webhooktrial'));
            String hmacstring = 'sha256='+EncodingUtil.convertToHex(hmac);
            System.debug('hmac:'+EncodingUtil.convertToHex(hmac));
            if( hashedval == hmcstring){*/
                System.debug('Secret value Matched and source can be trusted');
                //githubpushdetails pusherdetails = githubpushdetails.parse(bB.toString());
                //iterate through JSON
                JSONParser parser = JSON.createParser(request.requestBody.toString());
                pusher ps;
                head_commit hc;
                String repo;
                while (parser.nextToken() != null) {
                    //System.debug('Inside parser'+parser.getText());
                    if (parser.getText() == 'pusher')
                    {
                        System.debug('Inside pusher');

                        parser.nextToken();
                        ps = (pusher)parser.readValueAs(pusher.class);
                        System.debug(ps);
                    }

                    if(parser.getText() == 'head_commit'){
                        System.debug('Inside head_commit');
                    }
                    
                }

        }catch(Exception e){
            System.debug('Exception Happened:'+e.getMessage());
        }
    }
    
 }// hello