pragma solidity ^0.8.21;

contract DemoContract {

}

contract Selector {
    event Log(bytes data);
    event SelectorEvent(bytes4);

    struct User {
        uint256 uid;
        bytes name;
    }

    enum School{
        SCHOOL1,
        SCHOOL2,
        SCHOOL3
    }

    function mint(address ) external{
        emit Log(msg.data);
    }

    function mintSelector() external  pure returns(bytes4 mSelector) {
        return bytes4(keccak256("mint(address)"));
    }

    function nonParamSelector() external returns (bytes4 selectorWithNonParam) {
        emit SelectorEvent(this.nonParamSelector.selector);
        return bytes4(keccak256("nonPramSelector()"));
    }

    function elementaryParamSelector (uint256 param1, bool param2) external  returns (bytes4 selectWithElementaryParam) {
        emit SelectorEvent(this.elementaryParamSelector.selector);
        return bytes4(keccak256("elementaryParamSelector(uint256,bool)"));
    }

//    fixedSizeParamSelector

//    nonFixedSizeParamSelector

//    mappingParamSelector

//    callWithSignature
}