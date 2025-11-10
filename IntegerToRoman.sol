pragma solidity ^0.8.00;

/**
罗马数字包含以下七种字符: I， V， X， L，C，D 和 M。

字符          数值
I             1
V             5
X             10
L             50
C             100
D             500
M             1000
例如， 罗马数字 2 写做 II ，即为两个并列的 1 。12 写做 XII ，即为 X + II 。 27 写做  XXVII, 即为 XX + V + II 。

通常情况下，罗马数字中小的数字在大的数字的右边。但也存在特例，例如 4 不写做 IIII，而是 IV。数字 1 在数字 5 的左边，
所表示的数等于大数 5 减小数 1 得到的数值 4 。同样地，数字 9 表示为 IX。这个特殊的规则只适用于以下六种情况：

I 可以放在 V (5) 和 X (10) 的左边，来表示 4 和 9。  IV=4  IX=9
X 可以放在 L (50) 和 C (100) 的左边，来表示 40 和 90。 XL=40 XC=90
C 可以放在 D (500) 和 M (1000) 的左边，来表示 400 和 900。  CD=400   CM=900
给定一个罗马数字，将其转换成整数。
 **/

contract IngeterToRoman {
    string constant private I = "I";//1
    string constant private V = "V";//5
    string constant private X = "X";//10
    string constant private L = "L";//50
    string constant private C = "C";//100
    string constant private D = "D";//500
    string constant private M = "M";//1000

    mapping(uint=>string) private specialMap;

    constructor() {
        specialMap[4] = "IV";
        specialMap[9] = "IX";
        specialMap[40] = "XL";
        specialMap[90] = "XC";
        specialMap[400] = "CD";
        specialMap[900] = "CM";
    }

    //3949
    function Ingeter2Roman(uint16 i) public view returns (string memory) {
        uint16 temp = i;
        string memory res = "";
        if(i > 4000){
            return "";
        }

        //处理千位
        uint mQty = temp/1000;//3
        while ( mQty>0) {
            res = string.concat(res, M);
            mQty--;
        }

        //处理百位
        temp = temp%1000;//949
        if(temp >= 900){
            res = string.concat(res, specialMap[900]);
            temp = temp - 900;
        } else if (temp >= 500) {
            res = string.concat(res, D);
            temp = temp - 500;
        }
        {
            if(temp >= 400){
                res = string.concat(res, specialMap[400]);
                temp = temp - 400;
            }else {
                uint cQty = temp/100;
                while ( cQty>0) {
                    res = string.concat(res, C);
                    cQty--;
                }
            }
        }

        //处理十位
        temp = temp%100;//49
        if(temp >= 90){
            res = string.concat(res, specialMap[90]);
            temp = temp - 90;
        }else if(temp >= 50){
            res = string.concat(res, L);
            temp = temp - 50;
        }
        {
            if(temp >= 40){
                res = string.concat(res, specialMap[40]);
                temp = temp - 40;
            }else {
                uint xQty = temp/10;
                while ( xQty>0) {
                    res = string.concat(res, X);
                    xQty--;
                }
            }

        }

        //处理个位
        temp = temp%10;
        if(temp >= 9){
            res = string.concat(res, specialMap[9]);
            temp = temp - 9;
        }else if(temp >= 5){
            res = string.concat(res, V);
            temp = temp - 5;
        }
        {
            if(temp >= 4){
                res = string.concat(res, specialMap[4]);
                temp = temp - 4;
            }else {
                uint iQty = temp/1;
                while ( iQty>0) {
                    res = string.concat(res, I);
                    iQty--;
                }
            }
        }
        return res;

    }
}