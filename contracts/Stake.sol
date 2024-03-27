// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Stake {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    uint256 public rewardRate = 3 * 10 ** 13;

    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    uint256 private _totalStakedTokens;

    uint256 public activeInvestors;

    mapping(address => uint256) public userRewardPerTokenPaid;

    mapping(address => uint256) public userTotalRewardPaid;

    mapping(address => uint256) public rewards;

    mapping(address => uint256) private _balances;

    event StakeEvent(address indexed buyerAddress, uint256 indexed amount);
    event Withdraw(address indexed receivedAddress, uint256 indexed amount);
    event GetReward(address indexed receivedAddress, uint256 indexed amount);

    constructor(address _staking, address _rewardToken) {
        stakingToken = IERC20(_staking);
        rewardToken = IERC20(_rewardToken);
    }

    ////////////////////////////////////////////////////////////
    //                       Stake                            //
    ////////////////////////////////////////////////////////////

    function stake(uint256 _amount) external updateReward(msg.sender) {
        if (_balances[msg.sender] == 0) {
            activeInvestors += 1;
        }
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        _balances[msg.sender] += _amount;
        _totalStakedTokens += _amount;
    }

    modifier updateReward(address acount) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        rewards[acount] = earned(acount);

        userRewardPerTokenPaid[acount] = rewardPerTokenStored;
        _;
    }

    function earned(address account) public view returns (uint256) {
        return (rewards[account] +
            (_balances[account] *
                (rewardPerToken() - userRewardPerTokenPaid[account])) /
            1e18);
    }

    /////////////////////////////////////////////////////////////
    //                       withdraw                          //
    ////////////////////////////////////////////////////////////

    function withdraw(uint256 _amount) public updateReward(msg.sender) {
        _totalStakedTokens -= _amount;
        _balances[msg.sender] -= _amount;

        if (_balances[msg.sender] == 0) {
            activeInvestors--;
        }

        stakingToken.transfer(msg.sender, _amount);
    }

    function rewardPerToken() public view returns (uint256) {
        if (_totalStakedTokens == 0) {
            return 0;
        }
        return (rewardPerTokenStored +
            ((block.timestamp - lastUpdateTime) * rewardRate * 1e18) /
            _totalStakedTokens);
    }

    function getStakingAddress() public view returns (address) {
        return address(this);
    }

    function getTotalStakeTokens() public view returns (uint256) {
        return _totalStakedTokens;
    }

    function getUserStakedTokens(
        address account
    ) public view returns (uint256) {
        return _balances[account];
    }
}
