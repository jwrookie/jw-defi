//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/Math.sol";
contract Test_Math {
    function ceilDiv(uint256 a, uint256 b) public pure returns (uint256) {
        return Math.ceilDiv(a,b) ;
    }
}
