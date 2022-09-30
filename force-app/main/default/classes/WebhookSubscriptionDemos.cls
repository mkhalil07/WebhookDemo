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

                        parser.nextToken();
                        hc = (head_commit)parser.readValueAs(head_commit.class);
                        System.debug(hc);
                    }
                    if(parser.getText() == 'full_name'){
                        System.debug('Inside full_name');

                        parser.nextToken();
                        repo = parser.getText();
                        System.debug(repo);
                    }
                    
                }
                //Create GitHub_Push_Details__c based on received details
                GitHub_Push_Details__c detail = new GitHub_Push_Details__c();
                detail.Committer_Name__c = ps!=null?ps.name:'';
                detail.Committer_Email__c = ps!=null?ps.email:'';
                detail.Commit_Message__c = hc!=null?hc.message:'';
                detail.Commit_Timestamp__c = hc!=null?hc.timestamp:'';
                detail.Committed_URL__c = hc!=null?hc.url:'';
                detail.Repository_Name__c = repo;
                detal.Added_Components__c = hc!=null&&hc.added!=null?String.join(hc.added,','):'';
                detal.Removed_Components__c = hc!=null&&hc.removed!=null?String.join(hc.removed,','):'';
                detal.Modified_Components__c = hc!=null&&hc.modified!=null?String.join(hc.modified,','):'';
                insert detail;
                response.statusCode = 200;
                response.responseBody = Blob.valueOf(JSON.serialize(new SFDCResponse('Success','Processed Succesfully')));



        }catch(Exception e){
            System.debug('Exception Happened:'+e.getMessage());
        }
    }
    
    public class SFDCResponse{
        String response;
        String message;
        public SFDCResponse(String resp, String msg){
            response = resp;
            message = msg;
        }
    }
    public class pusher{
        public String name;
        public String email;
        public pusher(String name, String email){
            name = name;
            email = email;
        }
    }
 }// hello