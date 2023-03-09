//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract AssetExchange {
    mapping(address => mapping(address => uint256)) public assets;

    uint256 public feePercentage = 1;
    event Trade(address indexed _from, address indexed _to, uint256 _value, uint256 _fee);

     function setFeePercentage(uint256 _percentage) public {
        require(_percentage <= 10, "Fee percentage too high");
        feePercentage = _percentage;
    }

    function trade(address _to, uint256 _value) public {
        require(assets[msg.sender][_to] >= _value, "Insufficient balance");
        uint256 fee = (_value * feePercentage) / 100;
        assets[msg.sender][_to] -= _value;
        assets[_to][msg.sender] += _value - fee;
        assets[msg.sender][address(this)] += fee;
        emit Trade(msg.sender, _to, _value, fee);
    }
}
