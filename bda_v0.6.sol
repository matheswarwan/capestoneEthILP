//Limiting parameters in emit 

contract BDA {

    struct Land { 
        string projLocation;
        string name;
        bytes32 id;
        uint256 surveyNumber;
        uint8 nocStatus;
        uint8 lakeAuthApproverStatus;
        string lakeAuthComments;
        uint8 forestAuthApproverStatus;
        string forestAuthComments;
    }
    
    
    mapping (bytes32 => Land) public land;
    address public contractOwner = msg.sender;
    mapping (address => bool) public lakeApprover;
    mapping (address => bool) public forestApprover;

    modifier isOpenForApproval (uint8 _approverType, bytes32 _id) {
        if(_approverType == 0) {
            require(land[_id].lakeAuthApproverStatus == 0);
        }
        else if(_approverType == 1) 
        {
            require(land[_id].forestAuthApproverStatus == 0);
        }
        require(land[_id].nocStatus == 1);
        _;
    }

    modifier isOpenForNOC (bytes32 _id) {
        require(land[_id].nocStatus == 0);
        _;
        
    }
    
    modifier onlyOwner() {
        require(keccak256(msg.sender) == keccak256(contractOwner));
        _;
    }
    
    event eRegisteredLand(bytes32 id, address msgSender, uint256 datetime);    
    event eRequestForNOC(bytes32 id, address msgSender, uint256 datetime);
    event eApprovalStatus(bytes32 id, address msgSender, uint256 datetime);

    function changeContractOwner (address _newOwnerAddress) public onlyOwner {
        contractOwner = _newOwnerAddress;
    }
    
    /* function addLakeApprover(address _lakeApprover)  public onlyOwner {
        lakeApprover[_lakeApprover] = true;
    }
    
    function addForestApprover(address _forestApprover)  public onlyOwner {
        forestApprover[_forestApprover] = true;
    }*/
    
    function viewLand(bytes32 _id) public constant returns (string  _projLocation, uint256 _surveyNumber, uint8 _nocStatus, uint8 _lakeApproverStatus, string _lakeComments, uint8 _forestApproverStatus, string _forestComments)  {
        return (land[_id].projLocation, land[_id].surveyNumber, land[_id].nocStatus, land[_id].lakeAuthApproverStatus, land[_id].lakeAuthComments, land[_id].forestAuthApproverStatus, land[_id].forestAuthComments);
    }
    
    /*function isValidLakeApprover(address _lakeApprover) returns (bool){
        return lakeApprover[_lakeApprover];
    }
    
	function isValidForestApprover(address _forestApprover) returns (bool){
        return forestApprover[_forestApprover];
    }*/
    
   function registerLand (string  _location, string  _name, bytes32 _id, uint256 _surveyNumber) public onlyOwner payable returns (bool) { 
        if(!isLandAlreadyRegistered(_id)) {
            land[_id].projLocation = _location;
            land[_id].name = _name;
            land[_id].id = _id;
            land[_id].surveyNumber = _surveyNumber;
            land[_id].nocStatus = 0;
        
            emit eRegisteredLand(land[_id].id, msg.sender, now);
            
            return (true);
        } else { 
            return (false);
        }
        
            
    }
    
    function requestForNOC( bytes32 _id) public isOpenForNOC (_id) payable returns (bool) {
        if(isLandAlreadyRegistered(_id)) {
            land[_id].nocStatus = 1;
            land[_id].lakeAuthApproverStatus = 0;
            land[_id].forestAuthApproverStatus = 0;
            
            emit eRequestForNOC(land[_id].id, msg.sender, now);
        
            return true;
        } else { 
            return false;
        }
        
            
    }

    function isLandAlreadyRegistered(bytes32 _id) private returns (bool) {
        bytes memory tempEmptyStringTest = bytes(land[_id].projLocation); // Uses memory
        if (tempEmptyStringTest.length == 0) {
            return false;
        }
        else 
        {
            return true;
        }
        
    }
    
    function approveNOC (uint8 _approverType, bytes32 _id, uint8 _approvalStatus, string _approverComments) public payable isOpenForApproval(_approverType,_id) returns (bool) {
        if(_approverType == 0) { //Lake
            //Ensure that this is a valid lake approver
            //if(isValidLakeApprover(msg.sender)) 
            {
                land[_id].lakeAuthApproverStatus = _approvalStatus;
                land[_id].lakeAuthComments = _approverComments;
            }
        }else if (_approverType == 1) {  //Forest
            //Ensure that this is a valid Forest approver
            //if(isValidForestApprover(msg.sender)) 
            {
                land[_id].forestAuthApproverStatus = _approvalStatus;
                land[_id].forestAuthComments = _approverComments;
            }
        }
        
        //Check if Overall NOC status can be updated
        if(land[_id].lakeAuthApproverStatus!= 0 && land[_id].forestAuthApproverStatus !=0) {
            if(land[_id].lakeAuthApproverStatus== 1 && land[_id].forestAuthApproverStatus ==1) { //Fully Approved
                land[_id].nocStatus = 3;
            }  else { 
                land[_id].nocStatus = 4;
            }
        }
        
        emit eApprovalStatus(land[_id].id, msg.sender, now);
        
        return true;
                
    }

}
