//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract BuyPackage{
    
    enum Packages{
        silver,
        gold,
        platinum
    }
    
    struct clientHistory {
        Packages packageName;
        bool payStatus;
    }

    mapping (bytes32 => clientHistory) private clientsHistory;
    mapping (address => bytes32) private addressToHistory;
    
    uint256 private silver;
    uint256 private gold;
    uint256 private platinum;

    constructor(uint256 _silver, uint256 _gold, uint256 _platinum){
        silver = _silver;
        gold = _gold;
        platinum = _platinum;
    }

    function getClientHistory(address client) public view returns (Packages packageType, bool _payStatus){
        return( clientsHistory[addressToHistory[client]].packageName,
                clientsHistory[addressToHistory[client]].payStatus);
    }

    function purchasePackage(uint8 packageType) public payable returns (bool success){
        bytes32 uniKey = getUniKey(packageType, msg.sender);
        addressToHistory[msg.sender] = uniKey;

        if (packageType == 0) {
            require(msg.value == silver, "send amount of silver");
            clientsHistory[uniKey].packageName = Packages(packageType);
            clientsHistory[uniKey].payStatus = true;
            
            return true;
        } else if(packageType == 1){
            require(msg.value == gold, "send amount of gold");
            clientsHistory[uniKey].packageName = Packages(packageType);
            clientsHistory[uniKey].payStatus = true;

            return true;

        } else if(packageType == 2){
            require(msg.value == platinum, "send amount of platinum");
            clientsHistory[uniKey].packageName = Packages(packageType);
            clientsHistory[uniKey].payStatus = true;

            return true;

        } else{
            revert("choose correct package type");
        }

        return false;
    }

    function setPackagePrice(uint256 _silver, uint256 _gold, uint256 _platinum) public /*onlyOwner*/ {
        silver = _silver;
        gold = _gold;
        platinum = _platinum;
    }

    function getPackagePrice() public view returns(uint256 _silver, uint256 _gold, uint256 _platinum){
        return(silver, gold, platinum);
    }

    function getCurrencyBalance() public view returns(uint256 ethBalance){
        return (address(this).balance);
    }

    function withdrawCurrency() public /*onlyOwner*/{
        payable(msg.sender).transfer(address(this).balance);
    }

    function getUniKey(uint8 num, address caller) public view returns(bytes32 uniKey){
        return (keccak256(abi.encodePacked(block.timestamp, caller, num)));
    }

    receive() external payable{}
    fallback() external payable{}

}