// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract ICO {
    address admin;
    IERC20 public token;
    uint256 public tokenPrice = 10 ** 15 wei;

    uint256 public airDropAmount = 100 * 1e18;
    uint256 public maxAirdropAmount = 1_000_000 * 1e18;
    uint256 public totalReleasedAirdrop;
    uint256 public icoEndTime;
    uint256 public holdersCount;

    mapping(address => uint256) public airdrops;
    mapping(address => uint256) public holders;
    mapping(address => bool) public isInList;

    event Buy(address indexed buyer_address, uint256 indexed amount);
    event AirDrop(address indexed receiver_address, uint256 indexed amount);

    constructor(address _token, address _admin) {
        admin = _admin;
        token = IERC20(_token);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin can call this function");
        _;
    }

    modifier icoIsActive() {
        require(
            icoEndTime > 0 && block.timestamp < icoEndTime,
            "Ico is inActive!"
        );
        _;
    }

    modifier icoIsInactive() {
        require(icoEndTime == 0, "Ico is already activated!");
        _;
    }

    function activate(uint256 duration) external onlyAdmin {
        require(duration > 0, "duration must be more than 0");
        icoEndTime = block.timestamp + duration;
    }

    function deactive() external onlyAdmin {
        icoEndTime = 0;
    }

    function airDrop(address receiver) public icoIsActive {
        //Check conditions
        require(
            airdrops[receiver] == 0,
            "this address has been airdroped before"
        );

        require(
            totalReleasedAirdrop + airDropAmount <= maxAirdropAmount,
            "All airdrop tokens were released!"
        );

        require(
            balanceOfToken(address(this)) >= airDropAmount,
            "Contract balance is insufficient"
        );

        //airdrop tokens
        token.transfer(receiver, airDropAmount);

        airdrops[receiver] = airDropAmount;
        totalReleasedAirdrop += airDropAmount;

        if (!isInList[receiver]) {
            holdersCount++;
            isInList[receiver] = true;
        }

        holders[receiver] += airDropAmount;
        emit AirDrop(receiver, airDropAmount);
    }

    function purchase(uint amount) public payable icoIsActive {
        require(
            msg.value == ((tokenPrice * amount) / 1e18),
            "not currect value!"
        );

        token.transfer(msg.sender, amount);

        if (!isInList[msg.sender]) {
            isInList[msg.sender] = true;
            holdersCount++;
        }
        holders[msg.sender] += amount;
        emit Buy(msg.sender, amount);
    }

    function depositTokens(uint256 amount) external onlyAdmin {
        token.transferFrom(msg.sender, address(this), amount);
    }

    function withdrawTokens(uint256 amount) external onlyAdmin {
        require(
            amount <= balanceOfToken(address(this)),
            "withdraw amount is higher than the balance."
        );
        token.transfer(admin, amount);
    }

    function withdrawEth(uint256 amount) external onlyAdmin {
        require(
            amount <= balanceOfEth(address(this)),
            "amount is higher than balance"
        );
        payable(admin).transfer(amount);
    }

    function balanceOfEth(address account) public view returns (uint256) {
        return account.balance;
    }

    function balanceOfToken(address account) public view returns (uint256) {
        return token.balanceOf(account);
    }

    function getIcoAddr() public view returns (address) {
        return address(this);
    }

    function getTokenAddr() public view returns (address) {
        return address(token);
    }

    function updateAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
    }
}
