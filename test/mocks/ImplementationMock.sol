// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ImplementationMock {
    uint256 public value;

    error CustomError(uint256 value);

    constructor() {}

    function initialize(uint256 initData) public returns (uint256) {
        value = initData;
        return value;
    }

    function setValue(uint256 _value) public {
        value = _value;
    }

    function revertWithError() public view {
        revert CustomError(value);
    }

    function initializeWithError(uint256 errorValue) public pure {
        revert CustomError(errorValue);
    }
}
