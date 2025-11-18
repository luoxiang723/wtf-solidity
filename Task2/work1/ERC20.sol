pragma solidity ^0.8.21;

import {IERC20} from "./IERC20.sol";

contract ERC20 is IERC20 {

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping (address=> uint256)) public allowances;

    string name;
    string symbol;

    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
        mint(msg.sender, 1000000);
    }


    /**
     * @dev Returns the value of tokens in existence.
     */
    // function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    // function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external override returns (bool) {
        require(balanceOf[msg.sender] > value, "balance not enouph");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value; 
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view override returns (uint256) {
        return allowances[owner][spender];
    }

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external override  returns (bool) {
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(balanceOf[from] > value, "balance not enough");
        require(allowances[from][msg.sender] > value, "allowance not enough");

        allowances[from][msg.sender] -= value;
        balanceOf[from] -= value;
        balanceOf[to] += value; 
        emit Transfer(from, to, value);
        return false;
    }

    function mint(address to, uint256 value) public {
        balanceOf[to] += value;
        totalSupply += value;
        emit Transfer(address(0), to, value); 
    }

    function burn(address from, uint256 value) external {
        balanceOf[from] -= value;
        totalSupply -= value;
        emit Transfer(from, address(0), value); 
    }
}