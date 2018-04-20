var Web3 = require('web3');
var web3 = new Web3();
var providerURL = "HTTP://127.0.0.1:7545";
var contractAddress = "0x5db3f744a874c30701747c3f9ccca0e65b0be344"; 
var abi = [{"constant":true,"inputs":[{"name":"_id","type":"bytes32"}],"name":"viewLand","outputs":[{"name":"_projLocation","type":"string"},{"name":"_surveyNumber","type":"uint256"},{"name":"_nocStatus","type":"uint8"},{"name":"_lakeApproverStatus","type":"uint8"},{"name":"_lakeComments","type":"string"},{"name":"_forestApproverStatus","type":"uint8"},{"name":"_forestComments","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"contractOwner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"land","outputs":[{"name":"projLocation","type":"string"},{"name":"name","type":"string"},{"name":"id","type":"bytes32"},{"name":"surveyNumber","type":"uint256"},{"name":"nocStatus","type":"uint8"},{"name":"lakeAuthApproverStatus","type":"uint8"},{"name":"lakeAuthComments","type":"string"},{"name":"forestAuthApproverStatus","type":"uint8"},{"name":"forestAuthComments","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"lakeApprover","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"forestApprover","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"projLocation","type":"string"},{"indexed":false,"name":"name","type":"string"},{"indexed":false,"name":"id","type":"bytes32"},{"indexed":false,"name":"surveyNumber","type":"uint256"},{"indexed":false,"name":"nocStatus","type":"uint8"},{"indexed":false,"name":"lakeAuthApproverStatus","type":"uint8"},{"indexed":false,"name":"lakeAuthComments","type":"string"},{"indexed":false,"name":"forestAuthApproverStatus","type":"uint8"},{"indexed":false,"name":"forestAuthComments","type":"string"},{"indexed":false,"name":"datetime","type":"uint256"}],"name":"eRequestForNOC","type":"event"},{"constant":false,"inputs":[{"name":"_approverType","type":"uint8"},{"name":"_id","type":"bytes32"},{"name":"_approvalStatus","type":"uint8"},{"name":"_approverComments","type":"string"}],"name":"approveNOC","outputs":[{"name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[{"name":"_newOwnerAddress","type":"address"}],"name":"changeContractOwner","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_location","type":"string"},{"name":"_name","type":"string"},{"name":"_id","type":"bytes32"},{"name":"_surveyNumber","type":"uint256"}],"name":"registerLand","outputs":[{"name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"projLocation","type":"string"},{"indexed":false,"name":"name","type":"string"},{"indexed":false,"name":"surveyNumber","type":"uint256"},{"indexed":false,"name":"nocStatus","type":"uint8"},{"indexed":false,"name":"lakeAuthApproverStatus","type":"uint8"},{"indexed":false,"name":"lakeAuthComments","type":"string"},{"indexed":false,"name":"forestAuthApproverStatus","type":"uint8"},{"indexed":false,"name":"forestAuthComments","type":"string"},{"indexed":false,"name":"datetime","type":"uint256"}],"name":"eApprovalStatus","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"projLocation","type":"string"},{"indexed":false,"name":"name","type":"string"},{"indexed":false,"name":"id","type":"bytes32"},{"indexed":false,"name":"surveyNumber","type":"uint256"},{"indexed":false,"name":"nocStatus","type":"uint8"},{"indexed":false,"name":"lakeAuthApproverStatus","type":"uint8"},{"indexed":false,"name":"lakeAuthComments","type":"string"},{"indexed":false,"name":"forestAuthApproverStatus","type":"uint8"},{"indexed":false,"name":"forestAuthComments","type":"string"},{"indexed":false,"name":"datetime","type":"uint256"}],"name":"eRegisteredLand","type":"event"},{"constant":false,"inputs":[{"name":"_id","type":"bytes32"}],"name":"requestForNOC","outputs":[{"name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function"}]; 

//Empty Declarations
var MyContract, myContractInstance;

function connectToNetwork() {
    web3.setProvider(new web3.providers.HttpProvider(providerURL)); 
	console.log("Connected to network");
}

function connectToContract() {
	MyContract = web3.eth.contract(abi);
	myContractInstance = MyContract.at(contractAddress);
	console.log("connect to contract");
}

function readABI(_jsonFileName) { 
	var fs = require('fs');
	var jsonFile = "contract/"+_jsonFileName+".json";
	var parsed= JSON.parse(fs.readFileSync(jsonFile));
	var abi = parsed.abi;
	console.log("ABI Loaded is - " + abi);
	
	return abi;
	//var YourContract= new web3.eth.Contract(abi, 0x12345678912345678912345678912345678912);
}

function nocStatusDecode(_code) {
	if(_code == 0) 
		return ("Land Registered");
	else if (_code == 1)
		return ("NOC Requested");
	else if (_code == 2)
		return ("NOC In Progres");
	else if (_code == 3)
		return ("<font color='green'>NOC Approved</font>");
	else if (_code == 4)
		return ("<font color='red'>NOC Rejected</font>");
}

function approverStatusDecode(_code) {
	if(_code == 0) 
		return ("NOC Not Requested");
	else if (_code == 1)
		return ("<font color='green'>NOC Approved</font>");
	else if (_code == 2)
		return ("<font color='red'>NOC Rejected</font>");
}

function getGasValue() {
	return (parseInt(web3.eth.getBlock("latest").gasLimit));
}

/*
function requestForNOC(string _id) { 
	//myContractInstance

}

*/
