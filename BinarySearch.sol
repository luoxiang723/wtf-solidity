pragma solidity ^0.8.00;

/**
 * 反转字符串 (Reverse String)
题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"
 */
contract ReverseString {

    function reverseString(string calldata str) public pure returns (string memory) {
        bytes memory strbytes = bytes(str);
        bytes memory newBytes = new bytes(strbytes.length);
        for (uint i=0; i<strbytes.length; i++) {
            newBytes[i] = strbytes[strbytes.length -1 -i];
        }

//        uint i = 0;
//        while (i < strbytes.length) {
//            newBytes[i] = strbytes[strbytes.length -1 -i];
//            i++;
//        }
        return string(newBytes);

    }
}