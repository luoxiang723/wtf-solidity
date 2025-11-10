pragma solidity ^0.8.21;


contract Pair2 {
    address public factory;
    address public token0;
    address public token1;

    constructor() payable  {
        factory = msg.sender;
    }

    function initialize(address _token0, address _token1) external {
        token0 = _token0;
        token1 = _token1;
    }
}

contract PaieFactory2 {
    mapping( address => mapping(address =>address )) public getPair;
    address[] public allPairs;

    /**
    WBNB地址: 0x2c44b726ADF1963cA47Af88B284C06f30380fC78
    BSC链上的PEOPLE地址: 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c
     */
    function createPair2(address tokenA, address tokenB) external returns (address pairAddr) {
        require (tokenA != tokenB, "IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) :(tokenB, tokenA);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        Pair2 pair = new Pair2{salt:salt}();
        pair.initialize(tokenA, tokenB);
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }

    function calculateAddr(address tokenA, address tokenB) external view returns (address predictedAddr) {
        require (tokenA != tokenB, "IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) :(tokenB, tokenA);
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        predictedAddr = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(type(Pair2).creationCode)
        )))));
    }
}