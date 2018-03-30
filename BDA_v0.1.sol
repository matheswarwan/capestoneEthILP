//TODO: Add error handling
// Add Events

pragma solidity ^0.4.21;

contract BDA {
    
    struct Project { 
        string projLocation;
        string name;
        uint256 id;
        uint256 surveyNumber;
        //string authorityType;
        approval lakeAuthority;
        approval forestAuthority;
    }
    
    struct approval {
        bool approvalStatus;
        string reasonForRejection;
    }
    
    mapping (address => Project) project;
    //Project[] public projectAddersses;

    function getProject (address _address) public view 
            returns (string,string,uint256) {
        return( project[_address].projLocation, 
                project[_address].name, 
                project[_address].surveyNumber);
    }
    
    function setProject (   string  _location, 
                            string  _name,
                            address _address,
                            uint256 _surveyNumber) public{ 
        project[_address].projLocation = _location;
        project[_address].name = _name;
        project[_address].surveyNumber = _surveyNumber;

    }
    
     
    function lakeAuthorityApproval (    address _address,
                                        bool _lakeAuthority,
                                        string _reasonForRejection) public payable returns (bool) { 
        //TODO: Check if valid project
        project[_address].lakeAuthority.approvalStatus = _lakeAuthority;
        project[_address].lakeAuthority.reasonForRejection = _reasonForRejection;
        return true;

    }
    
    function forestAuthorityApproval (    address _address,
                                        bool _forestAuthority,
                                        string _reasonForRejection) public payable returns (bool) { 
        //TODO: Check if valid project
        project[_address].forestAuthority.approvalStatus = _forestAuthority;
        project[_address].forestAuthority.reasonForRejection = _reasonForRejection;
        return true;

    }
    
    function overallApprovalStatus ( address _address) public view returns (bool,bool,string,bool,string) {
        
        if(!(project[_address].lakeAuthority.approvalStatus == true &&  project[_address].forestAuthority.approvalStatus == true)) {
            
            return (   false, 
                        project[_address].lakeAuthority.approvalStatus, 
                        project[_address].lakeAuthority.reasonForRejection,
                        project[_address].forestAuthority.approvalStatus,
                        project[_address].forestAuthority.reasonForRejection

                    );
        }
        else {
            return (true, project[_address].lakeAuthority.approvalStatus, 
                        project[_address].lakeAuthority.reasonForRejection,
                        project[_address].forestAuthority.approvalStatus,
                        project[_address].forestAuthority.reasonForRejection);
        }
    }
}

/*

contract ForestAuthority {
    
}

contract LakeAuthority {
    
}
*/