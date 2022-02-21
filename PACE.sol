// SPDX-License-Identifier: UNLICENSED

pragma solidity  >=0.4.24 <0.9.0;
pragma experimental ABIEncoderV2;

/**
 * Handles all functions related to user consents for given set of services for service providers
 */
contract Privacy {
    
    
    
    uint[] providerList;                //List of providers registered.
 //   mapping(uint => mapping(uint => bool)) customers;    //List of customers who have given a consent true/false for a provider...provider->index->customers
 //   mapping(uint => uint)                                // providerid -> num of customers.
    struct  Service {                   //Each service has a name,list of user data categories needed and operations to be carried out.
        bytes32 name;
        bytes32[] requiredData;          // Data category needed for the operation; eg contact info.
        bytes32[] operations;            // data access, data update, transfer or profiling
        bool vote;
    }
    
    struct  userVotes {                 //a user vote has info on the provider, the service the provider gives and consent of the user.
        mapping(uint => Service) votes; // index-> service+vote
        uint services;                  // number of services in votes mapping
    }
    
    mapping(uint => mapping(uint => Service))  provider;         //provider -> index -> service struct. Map of providers and services they offer
    mapping(uint => uint) serviceCount;                          //providerID -> number of services registered
    mapping(uint => mapping(uint => userVotes)) consents;        //userID -> providerID -> userVotes struct. Map of users and their consents for various services
    event status(string report);
    event numOfServices(uint count);
    //event service(string name);
    event service(string name, string data, string operation);
//    event data(string theData);
//    event ops(string theOperations);

   /*
    *Providers set the list of their Services
    * including information on the data categories needed
    * and operations carried out as part of the service using this function.
    */
    function purpose(uint _provider, string  memory _service, string[] memory _data, string memory _opr) public{
        
        bytes32[] memory dat = new bytes32[](_data.length);
        for(uint i = 0; i < _data.length; i++){
            dat[i] = stringToBytes32(_data[i]);
        }
        
        //If providerID does not exist, create a new entry for it and associate it with the service.
        if (serviceCount[_provider] <= 0) {
            
            providerList.push(_provider);
            
            //Save service details
            
            provider[_provider][0].name = stringToBytes32(_service);
            provider[_provider][0].requiredData = dat;
            provider[_provider][0].operations.push(stringToBytes32(_opr));
            serviceCount[_provider] = 1;
            
            emit status("A new provider ID has been added to network!");

        // If the provider ID already exists, check if this service is already registered for the provider  
        } else {
            bool matched = false;
            
            for(uint i = 0; i< serviceCount[_provider]; i++) {
                
                //if the service already exists, replace it
                if (provider[_provider][i].name == stringToBytes32(_service)) {
                    matched = true;
                    //provider[_provider][i].operations.length = 0;
                    delete provider[_provider][i].operations;
                    
                    provider[_provider][i].requiredData = dat;
                    provider[_provider][i].operations.push(stringToBytes32(_opr));
                    //serviceCount[_provider] = 1;
                    emit status("This details of this service has been updated successfully.");
                   // uint count = serviceCount[_provider];
                    emit numOfServices(serviceCount[_provider]);
                
                    break;
                }
            }
            
            if(!matched){
                //if service does not exist, increase number of available services for the provider by one
                provider[_provider][serviceCount[_provider]].name = stringToBytes32(_service);
                provider[_provider][serviceCount[_provider]].operations.push(stringToBytes32(_opr));
                provider[_provider][serviceCount[_provider]].requiredData = dat;
                serviceCount[_provider] += 1;
                emit status("A new service has been added to existing provider.");
                emit numOfServices(serviceCount[_provider]);
            }
            
        }
        
        
    }
    
    /*
     *Get the complete list of providers in the system.
     */
    function getProviderList() public view returns(uint[] memory p){
        return providerList;
    }
    
    /*
     * Get the list of providers and the services they provide.   
     */
/*    function retrieve()  public {
        
        for(uint i =0; i < providerList.length; i++){

            for(uint j=0; j < provider[providerList[i]].length; j++){
                emit report(providerList[i], provider[providerList[i]][j]);
                //emit test(name);
            }
        }
       
    }
  */ 
  
    /*
     * Get the service details for a specific provider 
     */
    function retrieve(uint _provider)  public {
        //string d; 

        for (uint i = 0; i < serviceCount[_provider]; i++) {
            string memory d = "";
            string memory o = "";
            //emit service( bytes32ToString(provider[_provider][i].name));
            
            for (uint j = 0; j< provider[_provider][i].requiredData.length; j++) {
                //d[j] = bytes32ToString(provider[_provider][i].requiredData[j]);
                d = string(abi.encodePacked(d, bytes32ToString(provider[_provider][i].requiredData[j]), ","));
                //emit data( bytes32ToString(provider[_provider][i].requiredData[j]));
            }
            
            for (uint k = 0; k< provider[_provider][i].operations.length; k++) {
                //o[k] = bytes32ToString(provider[_provider][i].operations[k]);
                o = string(abi.encodePacked(o, bytes32ToString(provider[_provider][i].operations[k]), ","));
                //emit service(bytes32ToString(provider[_provider][i].name), d, bytes32ToString(provider[_provider][i].operations[k]));
                //emit ops( bytes32ToString(provider[_provider][i].operations[k]));
            }
            
            emit service(bytes32ToString(provider[_provider][i].name), d, o);
        }
                //emit test(name);
        
    }
    
    
    /*
    * Record user's consents 
    */
    function vote(uint _user, uint _provider, string memory _service, string[] memory _data, string[] memory _opr, bool _vote) public {
        
  //      customers[_provider][_user] = _vote;
        bytes32[] memory tempd = new bytes32[](_data.length);
        bytes32[] memory tempop = new bytes32[](_opr.length);
        
        for(uint i = 0; i< _data.length; i++) {
            tempd[i] = stringToBytes32(_data[i]);
        }
        for(uint i = 0; i< _opr.length; i++) {
            tempop[i] = stringToBytes32(_opr[i]);
        }

        //If the customer has no vote yet for this provider,
        if (consents[_user][_provider].services < 1){
            
            consents[_user][_provider].votes[0].name = stringToBytes32(_service);   //set the service name
            consents[_user][_provider].votes[0].requiredData = tempd;               //add the consented data params to service details
            consents[_user][_provider].votes[0].operations = tempop;                //add the consented ops to be carried out with this service
            consents[_user][_provider].votes[0].vote = _vote;                       //add the customer consent true/false
            consents[_user][_provider].services = 1;                                //set number of services with consent to 1
        } 
        //If customer has given consent in the past to some services for the same provider,
        else {
            bool matchfound = false;
            for (uint i = 0; i < consents[_user][_provider].services; i++){
                //Check that a vote for this particular service already exists
                
                //A. if yes, replace the consent details for the service.
                if (consents[_user][_provider].votes[i].name == stringToBytes32(_service)){
                    matchfound = true;
                    consents[_user][_provider].votes[i].requiredData = tempd;
                    consents[_user][_provider].votes[i].operations = tempop;
                    consents[_user][_provider].votes[i].vote = _vote;
                    
                }
            }
            //B. if no vote exists for service, add the new consent details for the new service.
            if(!matchfound){
                uint index = consents[_user][_provider].services;
                consents[_user][_provider].votes[index].name = stringToBytes32(_service);   //set the service name
                consents[_user][_provider].votes[index].requiredData = tempd;               //add the consented data params to service details
                consents[_user][_provider].votes[index].operations = tempop;                //add the consented ops to be carried out with this service
                consents[_user][_provider].votes[index].vote = _vote;                       //add the customer consent true/false
                consents[_user][_provider].services += 1; 
            }
        }
 
    }
 
 
    
    /*
     * Function to verify user's consent for a service
     */ 
    function checkConsent(uint _user, uint _provider, string memory _service, string memory _opr, string memory _data) public view returns(bool b) {
        bool matched = false;
        for(uint i = 0; i< consents[_user][_provider].services; i++) {
            //If service exists in consent list,
            if(consents[_user][_provider].votes[i].name == stringToBytes32(_service) ){
                
                
                //Check that the operation exists in list 
                for (uint j = 0; j < consents[_user][_provider].votes[i].operations.length; j++) {
                    //If operation is found in consent list
                    if (consents[_user][_provider].votes[i].operations[j] == stringToBytes32(_opr)) {
                        
                        //check that the list of data in the request matches the data list in consents
                        for (uint k = 0; k < consents[_user][_provider].votes[i].requiredData.length; k++) {
                            if (consents[_user][_provider].votes[i].requiredData[k] == stringToBytes32(_data)) {
                                matched = true;
                            }
                        }
                        
                        
                    }
                }
                
            }
            
            //If a match is found, return the user's vote
            if(matched){
               return consents[_user][_provider].votes[i].vote;
            }
                
            
        }
        
        //If no match is found for the service, matched value will be false
        // because consent must be explicit for services.
        return matched;
    }
  
  
  
    /*
     * Util function to convert input strings to bytes before storage
     */
    function stringToBytes32(string memory source) public pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
            
        }
        
        assembly {
            result := mload(add(source, 32))
            }
        
    }
    
    /* bytes32 to string converter */
    function bytes32ToString(bytes32 _bytes32) public pure returns (string memory result){
        bytes memory bytesArray = bytes32ToBytes(_bytes32);
        return string(bytesArray);
    }
    
    /* bytes32 (fixed-size array) to bytes (dynamically-sized array) */
    function bytes32ToBytes(bytes32 _bytes32) public pure returns (bytes memory result){
        // string memory str = string(_bytes32);
        // TypeError: Explicit type conversion not allowed from "bytes32" to "string storage pointer"
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return bytesArray;
    }
    
 
    
}
//End of privacy smart contract


/**
 * Handles all functions related to 
 * checking that GDPR compliance is met for various operations-
 * data access and transfer and proofiling
 */
contract Compliance {
    
    Privacy p;
    event reports(string report);
    event feedback(string value);
    event test(string a, uint b);
    
    struct Checks {
        uint provider;
        string opr;
        string details;
        bool encr;
        bool consent;
        bool destAllowed;
        
    }
    
    uint numHighRisks;
    mapping (uint => Checks) highRiskViolations;
    uint numMedRisks;
    mapping (uint => Checks) mediumRiskViolations;
    uint numLowRisks;
    mapping (uint => Checks) lowRiskViolations;
    
    constructor (Privacy addr)  {
        p = Privacy(addr);
        numHighRisks = 0;
        numMedRisks  = 0;
        numLowRisks  = 0;
    }
    
    
    
    /*
     * Checks the GDPR compliance for data access requests
     * 1. Verify that user data is encrypted
     * 2. Check that user has given consent to provider to access his data
     */
    function access (uint _user, uint _provider, string  memory  _service, string memory _data, bool _encr) public returns (bool b){
        
        bool result = false;
        //1. Check compliance for data privacy: encryption
        //If data is encrypted,
        if (_encr) {
            emit reports("Privacy verification passed.");
        } else {                                                //return failure if privacy check fails
            emit reports("Privacy verification failed!");
            emit feedback("false");
            return false;
        }
        
        //2. Compliance for user consent is checked if privacy check passes
        
        if (p.checkConsent( _user, _provider, _service, "access", _data)){
            emit reports("Consent verification passed.");
            emit feedback("true");
            result = true;
          //  return true;
        } else {
            emit reports("Consent verification failed!");
            emit feedback("false");
            return false;
        }
        
     //   return result;
        
      
    }
   
   
    /*
     * Checks the GDPR compliance for data transfer operations
     * 1. Check the user consent is given for the transfer.
     * 2. Check that transfer destination is within the EU or part of the BCR list.
     */ 
    function transfer(uint _user, uint _provider, string  memory _service, string memory _data, bool _isEU, bool _inBCR) public returns (bool b){
        

        //Check user consent for the transfer ooepration
        if (p.checkConsent( _user, _provider, _service, "transfer", _data) ){
            emit reports("Consent verification passed.");
        } else {
            emit reports("Consent verification failed!");
            emit feedback("false");
            return false;
        }
        
        //If user consent check passes, 
        // check that transfer destination is compliant with 
        // GDPR policy for personal info transfers
        
        //If destination IP is in EU
        if (_isEU) {
            emit reports("Transfer allowed; destination country is within the EU.");
            emit feedback("true");
            return true;
        } else if (_inBCR) {                                //If not in EU, check destination is in the BCR list.
            emit reports("Transfer allowed; destination country is found in the BCR list.");
            emit feedback("true");
            return true;
        } else {                                            // If destination is neither in EU nor part of the BCR list, report a violation.
            emit reports("Violation! Transfer destination does not conform to GDPR regulations.");
            emit feedback("false");
            return false;
        }
        
        
    }
    
    
    /*
     * Checks the GDPR compliance for data profiling operations
     * 1. Check the user consent is given for the profiling.
     * 2. Check the user age is below eighteen or not.
     */ 
    function profiling(uint _user, uint _provider, string  memory _service, string memory _data, bool _isEighteen) public returns (bool b) {
        
        //Check user consent for the profiling ooepration
        if (p.checkConsent( _user, _provider, _service, "profiling", _data) ){
            emit reports("Consent verification passed.");
        } else {
            emit reports("Consent verification failed!");
            emit feedback("false");
            return false;
        }
        
        //If user consent check passes, 
        // check that profiling is compliant with 
        // GDPR policy for personal info profiling
        
        //If user age is beyond eighteen
        if (_isEighteen) {
            emit reports("Profiling allowed; user age is beyond eighteen.");
            emit feedback("true");
            return true;
        }  else {                                            // If user age is below eighteen, report a violation.
            emit reports("Violation! User age is below eighteen.");
            emit feedback("false");
            return false;
        }
    }
    
    /*
    *breach function is for the classification of the various violations.
    *1. High risk violation : r = 3
    *2. Medium risk violation : r = 2
    *3. Low risk violation : r = 1
    */
/*    function breach(Checks[] memory _array) public  {
        //priceByCurrencyType[_array[0].currencyInt].price=_array[i].price;
        //keccak256(bytes(a)) == keccak256(bytes(b));
        uint r = 0;
        for(uint i=0; i<_array.length; i++){
            if (keccak256(bytes(_array[i].opr)) == keccak256(bytes("access"))) {
                
                r = checkViolation(_array[i].encr, _array[i].consent);
            
            } else {
                r = checkViolation(_array[i].encr, _array[i].consent, _array[i].destAllowed);
            }
            
            
            if ( r == 3) {
                highRiskViolations[numHighRisks] = _array[i];
                //emit test("Highrisk:",highRiskViolations[numHighRisks].provider);
                numHighRisks++;
                
            } else if ( r == 2) {
                mediumRiskViolations[numMedRisks] = _array[i];
                //emit test("MedRisk:",mediumRiskViolations[numMedRisks].provider);
                numMedRisks++;
                
            } else if (r == 1) {
                lowRiskViolations[numLowRisks] = _array[i];
                //emit test("LowRisk:",lowRiskViolations[numLowRisks].provider);
                numLowRisks++;
                
            }
        }
*/        
 /*       
    }
    
    function checkViolation(bool _encr, bool _consent) public  returns ( uint r){
        
        //High Risk
        if (!_encr && !_consent) {
            emit reports("High Risked Violation!");
            return 3;
        
        //Medium risk
        } else if (!_consent && _encr) {
            emit reports("Medium Risked Violation!");
            return 2;
        
        //Low risk
        } else if (!_encr && _consent) {
            emit reports("Low Risked Violation!");
            return 1;
        }
    }
    
    function checkViolation(bool _encr, bool _consent, bool _destAllowed) public  returns ( uint r){
        
        //High Risk
        if (!_consent && !_encr && !_destAllowed) {
            emit reports("High Risked Violation!");
            return 3;
        
        //Medium Risk
        } else if ((!_consent && _encr) && (!_consent && _destAllowed)) {
            emit reports("Medium Risked Violation!");
            return 2;
        
        //Low Risk
        } else if ((_consent && !_encr) || (_consent && !_destAllowed)) {
            emit reports("Low Risked Violation!");
            return 1;
        }
    }
  
  */
  
  
  
    /*
     * Verify that user data is encrypted
     */
    function verifyEncryption(bool _encr) private pure returns (bool){
        
        if (_encr) {
            return true;
        } else{
            return false;
        }
    }
   
}
