pragma solidity ^0.8.21;

import './Yeye.sol';
import {Yeye} from './Yeye.sol';

contract Import {

    Yeye yeye = new Yeye();
    function test() external {
        yeye.hip();
    }
}