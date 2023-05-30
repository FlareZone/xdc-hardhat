// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Bet {
    struct BetInfo {
        address bettor;
        uint256 amount;
        uint256 time;
    }

    BetInfo[] public bets;
    bool public isBet;
    uint256 public betAmount;
    address public betAddress;
    uint256 public endTime;

    function publishPost(bool _isBet, uint256 _betAmount) public {
        // 发布帖子, 并选择是否进行对赌
        if (_isBet) {
            // 质押token到合约
            // ...
            isBet = true;
            betAmount = _betAmount;
            betAddress = msg.sender;
        } else {
            isBet = false;
        }
    }

    function participate() public payable {
        // 参与对赌
        require(isBet == true, "This post is not for betting.");
        require(msg.value == betAmount, "The bet amount is not correct.");
        bets.push(BetInfo({
            bettor: msg.sender,
            amount: msg.value,
            time: block.timestamp
        }));
    }

    function endBet() public {
        // 结束对赌
        require(isBet == true, "This post is not for betting.");
        require(block.timestamp >= endTime, "The betting time has not ended yet.");
        uint256 totalAmount = address(this).balance;
        uint256 bettorCount = bets.length;
        uint256 bettorShare = totalAmount / bettorCount;
        for (uint256 i = 0; i < bettorCount; i++) {
            payable(bets[i].bettor).transfer(bettorShare);
        }
        isBet = false;
        betAmount = 0;
        betAddress = address(0);
        endTime = 0;
    }

    function getBetInfo() public view returns (BetInfo[] memory) {
        // 查询当前帖子的投注情况
        return bets;
    }
}
