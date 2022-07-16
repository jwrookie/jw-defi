// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract TestMultiCall {
    function test1(uint _i) external pure returns (uint) {
        return _i;
    }

    function test2() external pure returns (string memory) {
        return "2";
    }

    function getTest1(uint _i) external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.test1.selector, _i);
    }

    function getTest2() external pure returns (bytes4) {
        return this.test2.selector;
    }
}

contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data)
    external
    view
    returns (bytes[] memory)
    {
        require(targets.length == data.length, "target length != data length");

        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "call failed");
            results[i] = result;
        }

        return results;
    }
}