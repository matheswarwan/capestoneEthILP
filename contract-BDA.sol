contract test {
    
    
    address public contractOwner = msg.sender;

    struct Land { 
        string projLocation;
        string name;
        bytes32 id;
        uint256 surveyNumber;
        uint8 nocStatus;
        //approval lakeAuthority;
        //approval forestAuthority;
        uint8 lakeAuthApproverStatus;
        string lakeAuthComments;
        uint8 forestAuthApproverStatus;
        string forestAuthComments;
    }
    
    struct approval {
        uint8 approvalStatus; //approvalStatus = ['NotRequested','Approved','Rejected']
        string comments;
    }
    
    mapping (bytes32 => Land) public land;
    
    modifier onlyOwner() {
        //require(compare(msg.sender,contractOwner));
        require(keccak256(msg.sender) == keccak256(contractOwner));
        _;
    }
    
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
    
    event eRegisteredLand(string projLocation, string name, bytes32 id, uint256 surveyNumber, uint8 nocStatus, uint8 lakeAuthApproverStatus, string lakeAuthComments, uint8 forestAuthApproverStatus, string forestAuthComments);    
    event eRequestForNOC(string projLocation, string name, bytes32 id, uint256 surveyNumber, uint8 nocStatus, uint8 lakeAuthApproverStatus, string lakeAuthComments, uint8 forestAuthApproverStatus, string forestAuthComments);
    //event eApprovalStatus(string projLocation, string name, bytes32 id, uint256 surveyNumber, uint8 nocStatus, uint8 lakeAuthApproverStatus, string lakeAuthComments, uint8 forestAuthApproverStatus, string forestAuthComments);
    event eApprovalStatus(string projLocation, string name, uint256 surveyNumber, uint8 nocStatus, uint8 lakeAuthApproverStatus, string lakeAuthComments, uint8 forestAuthApproverStatus, string forestAuthComments);

    function changeContractOwner (address _newOwnerAddress) public onlyOwner {
        contractOwner = _newOwnerAddress;
    }
    
    function viewLand(bytes32 _id) public returns (string  _projLocation, 
                            //string  _name,
                            uint256 _surveyNumber,
                            uint8 _nocStatus,
                            uint8 _lakeApproverStatus,
                            string _lakeComments,
                            uint8 _forestApproverStatus,
                            string _forestComments
                            )  {
        
        return (land[_id].projLocation,
            //land[_id].name,
            land[_id].surveyNumber,
            land[_id].nocStatus,
            land[_id].lakeAuthApproverStatus,
            land[_id].lakeAuthComments,
            land[_id].forestAuthApproverStatus,
            land[_id].forestAuthComments
            );
    }
    
    function approveNOC (uint8 _approverType, bytes32 _id, uint8 _approvalStatus, string _approverComments) 
        public payable isOpenForApproval(_approverType,_id) returns (bool) {
        if(_approverType == 0) {
            //Lake
            land[_id].lakeAuthApproverStatus = _approvalStatus;
            land[_id].lakeAuthComments = _approverComments;
        }else if (_approverType == 1) {
            //Forest
            land[_id].forestAuthApproverStatus = _approvalStatus;
            land[_id].forestAuthComments = _approverComments;
        }
        
        emit eApprovalStatus(land[_id].projLocation, land[_id].name, land[_id].surveyNumber, land[_id].nocStatus, land[_id].lakeAuthApproverStatus, land[_id].lakeAuthComments, land[_id].forestAuthApproverStatus, land[_id].forestAuthComments);
        
        return true;
                
    }

    function requestForNOC(     string  _location, 
                            string  _name,
                            bytes32 _id,
                            uint256 _surveyNumber) 
                            public
                            isOpenForNOC (_id)
                            payable returns (bool) {
        if(isLandAlreadyRegistered(_id)) {
            land[_id].projLocation = _location;
            land[_id].name = _name;
            land[_id].surveyNumber = _surveyNumber;
            land[_id].nocStatus = 1;
            land[_id].lakeAuthApproverStatus = 0;
            land[_id].forestAuthApproverStatus = 0;
            
            emit eRequestForNOC(land[_id].projLocation, land[_id].name, land[_id].id, land[_id].surveyNumber, land[_id].nocStatus, land[_id].lakeAuthApproverStatus, land[_id].lakeAuthComments, land[_id].forestAuthApproverStatus, land[_id].forestAuthComments);
        
            return true;
        } else { 
            return false;
        }
        
            
    }

   function registerLand (   string  _location, 
                            string  _name,
                            bytes32 _id,
                            uint256 _surveyNumber) public onlyOwner payable returns (bool) { 
        if(!isLandAlreadyRegistered(_id)) {
            land[_id].projLocation = _location;
            land[_id].name = _name;
            land[_id].surveyNumber = _surveyNumber;
            land[_id].nocStatus = 0;
        
            emit eRegisteredLand(land[_id].projLocation, land[_id].name, land[_id].id, land[_id].surveyNumber, land[_id].nocStatus, land[_id].lakeAuthApproverStatus, land[_id].lakeAuthComments, land[_id].forestAuthApproverStatus, land[_id].forestAuthComments);
            
            return (true);
        } else { 
            return (false);
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
}
