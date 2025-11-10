pragma solidity ^0.8.00;

/**
 * 合并两个有序数组 (Merge Sorted Array)
题目描述：将两个有序数组合并为一个有序数组。
 */
contract MergeSortedArray {

    function merge(uint[] calldata arr1, uint[] calldata arr2) public pure returns (uint[] memory) {
        uint[] memory res = new uint[](arr1.length + arr2.length);

        uint i1 = 0;
        uint i2 = 0;
        uint i = 0;
        while (i1<arr1.length || i2<arr2.length) {
            if(i1<arr1.length && i2<arr2.length){
                if (arr1[i1] <= arr2[i2]){
                    res[i] = arr1[i1];
                    i1++;
                }else if (arr1[i1] >= arr2[i2]) {
                    res[i] = arr2[i2];
                    i2++;
                }
            } else if (i1 >= arr1.length && i2 < arr2.length){
                res[i] = arr2[i2];
                i2++;
            } else if (i2 >= arr2.length && i1 < arr1.length) {
                res[i] = arr1[i1];
                i1++;
            }
            i++;
        }
        return res;
    }
}